# Diagnóstico Profundo e Guia de Resolução: Travamentos da GPU Intel Iris Xe (Alder Lake) sob Pressão de Memória no FreeBSD 15.1 e o Panorama do FreeBSD 15.2

A sua intuição técnica está correta: o congelamento gráfico que você enfrenta no seu Dell Vostro 3520 (Intel Core i7-1255U / GPU Alder Lake-UP3 GT2 Iris Xe) decorre de regressões reais na interação entre o driver de vídeo, a camada de compatibilidade do kernel e o gerenciamento de memória RAM, e há uma razão exata para o problema não ter ocorrido no FreeBSD 15.0 e ter passado a ocorrer de forma severa no FreeBSD 15.1. Quando o FreeBSD 15.1-RELEASE foi lançado em 16 de junho de 2026, o meta-pacote `graphics/drm-kmod` alterou o driver padrão da série 15: enquanto o FreeBSD 15.0 instalava o **`drm-66-kmod`** (baseado no kernel Linux 6.6 LTS), o FreeBSD 15.1 passou a instalar o **`drm-612-kmod`** (baseado no Linux 6.12 LTS). Essa atualização do porte gráfico expôs falhas críticas na comunicação entre o driver `i915kms`, a camada `LinuxKPI` do kernel FreeBSD e o subsistema de memória virtual (`vm`): uma falha de perda de propriedade de páginas `shmem` (_shared memory_) quando o sistema operacional reclama caches da GPU ou realiza _swap_ sob uso intenso de RAM, além de um bug de corrupção de estado do escalonador de microcódigo GuC causado pela semântica invertida da função `cancel_delayed_work_sync()` no `LinuxKPI`.

Em relação à arquitetura de versões do FreeBSD e ao status das correções em novembro de 2026, é fundamental esclarecer onde o **FreeBSD 15.2** se encontra: no modelo de desenvolvimento do projeto, a versão `-CURRENT` corresponde atualmente ao ramo experimental **FreeBSD 16.0-CURRENT** (`main`), enquanto o FreeBSD 15.2 deriva do ramo estável `stable/15`, que entrou em _code slush_ em 23 de outubro de 2026, gerou a ramificação `releng/15.2` com o **FreeBSD 15.2-BETA1** em 6 de novembro de 2026 e terá o lançamento final (**15.2-RELEASE**) anunciado em **8 de dezembro de 2026**. Você **não deve migrar para o 16.0-CURRENT** na expectativa de corrigir esse problema: além de o `16.0-CURRENT` ainda apresentar o mesmo travamento do `i915` quando páginas `shmem` sofrem _page-out_ para o _swap_, o ramo `main` passa por uma refatoração estrutural invasiva no gerenciamento de páginas do `LinuxKPI` (`PAGE_IS_LKPI_PAGE`) que tem gerado novos _kernel panics_ em drivers DRM. O FreeBSD 15.2 continuará usando o `drm-612-kmod` como padrão, visto que os portes DRM 6.13, 6.14 e 6.15 destinam-se ao FreeBSD 16.

Para resolver o problema de forma prática na sua máquina hoje, **você não precisa esperar pelo 15.2 nem pular para o `-CURRENT`**, pois o driver gráfico reside na árvore de _Ports_ e soluções comprovadas já estão ao seu alcance no próprio FreeBSD 15.1-RELEASE por meio de três abordagens diretas:

1. **A solução imediata e mais estável (Recomendada):** Substituir o pacote `drm-612-kmod` pelo **`drm-66-kmod`** no seu FreeBSD 15.1 atual. O `drm-66-kmod` suporta nativamente a arquitetura Alder Lake / Iris Xe, utiliza a versão 3 do mapeamento GTT (`i915_gem_mmap_gtt_version = 3`) que não aciona o bug de tomada de páginas do `LinuxKPI`, e restaura a estabilidade que você tinha no FreeBSD 15.0.
2. **A atualização da série 6.12 via repositório `latest`:** Se você utiliza o repositório padrão `quarterly` do FreeBSD 15.1, você está executando a versão inicial **`drm-612-kmod-6.12.85_2`**. Ao migrar os repositórios `FreeBSD-ports` e `FreeBSD-ports-kmods` para o ramo **`latest`**, você receberá a versão **`drm-612-kmod-6.12.110_3`** (lançada em 7 de outubro de 2026), que corrige falhas de Vulkan para GPUs Intel no FreeBSD 15.1 e reduziu substancialmente a frequência de congelamentos em GPUs Alder Lake segundo relatos no Bugzilla PR 295625.
3. **O estado dos patches de kernel para o bug de memória (`shmem`):** O patch específico para a perda de páginas `shmem` sob pressão de RAM e _swap_ foi isolado entre o final de outubro e 4 de novembro de 2026 (Commit `5258f1d` no `drm-kmod` e revisões Phabricator `D59481` e `D59883` no `freebsd-src`), mas permanece em fase de revisão e testes, não estando integrado por padrão nas imagens binárias do 15.1-RELEASE ou do 15.2-BETA1.

---

## 1. Anatomia Técnica do Bug: Por Que Abrir Muitos Softwares Derruba a Placa de Vídeo?

Para compreender por que o seu Dell Vostro 3520 congela especificamente quando você abre muitos programas — mesmo tendo limitado o ARC do ZFS a 4 GB — e por que o `kwin_wayland` (ou o Xorg) morre sem conseguir reconectar, é necessário examinar o que mudou entre o `drm-66-kmod` (FreeBSD 15.0) e o `drm-612-kmod` (FreeBSD 15.1) na interação entre espaço de usuário, kernel e hardware.

### 1.1. O Gatilho Principal: O Bug de Propriedade de Páginas `shmem` e `mmap_offset` no `drm-612-kmod`

A sua GPU Intel Iris Xe (Alder Lake-UP3 GT2) é uma unidade gráfica integrada sem VRAM dedicada; todo o armazenamento de texturas, _framebuffers_ e _command buffers_ (denominados objetos **GEM** — _Graphics Execution Manager_) utiliza a memória RAM física do sistema por meio de objetos de memória compartilhada (`shmem` VM objects). Nas versões anteriores do driver (`drm-61-kmod` e `drm-66-kmod`, padrão no FreeBSD 15.0), o driver `i915` configurava internamente a variável `i915_gem_mmap_gtt_version` com o valor **3**. Quando o FreeBSD 15.1 atualizou o pacote padrão para o **`drm-612-kmod`** (Linux 6.12), o driver `i915` passou a definir `i915_gem_mmap_gtt_version` como **5**, ativando a interface moderna `I915_GEM_MMAP_OFFSET` (incluindo mapeamentos _Write-Back_ `I915_MMAP_OFFSET_WB`).

Essa mudança de versão de mapeamento expôs uma falha estrutural na camada `LinuxKPI` do FreeBSD (`sys/compat/linuxkpi/common/src/linux_page.c`) quando o sistema entra sob pressão de memória. Quando o KWin, o Mesa (drivers `iris` e `anv`) ou um navegador aloca um buffer gráfico GEM e realiza um `mmap()` via `I915_GEM_MMAP_OFFSET`, a função `lkpi_vmf_insert_pfn_prot_locked()` do `LinuxKPI` retira a página física (`vm_page_t`) do seu objeto `shmem` original (invocando `vm_page_remove(page)`) e a transfere para o objeto VM do paginador de dispositivos do FreeBSD (`device_pager` / `cdev_pager`) a fim de mapeá-la no espaço de usuário. Enquanto há bastante RAM livre nos seus 16 GB, essas páginas permanecem mapeadas sem incidentes. Contudo, à medida que você abre múltiplos softwares pesados, a memória livre diminui e dois mecanismos do kernel entram em ação: o _shrinker_ do `i915` é acionado para liberar caches de buffers inativos (`i915_gem_drop_caches` / `DROP_UNBOUND`), revogando as entradas da tabela de páginas (PTEs) do `device_pager`, e o paginador do sistema começa a enviar páginas `shmem` para o _swap_.

Como a página havia sido removida do objeto `shmem` original pelo `LinuxKPI`, quando o `device_pager` do FreeBSD executa a limpeza ou revoga o mapeamento, **a propriedade da página não é devolvida ao objeto `shmem` original antes de ser liberada de volta ao sistema**. Um teste determinístico de reprodução documentado em 4 de novembro de 2026 no FreeBSD 15.1-RELEASE-p6 com `drm-612-kmod` (`6.12.85`) comprovou esse mecanismo: ao criar um objeto GEM de 4 MiB com `I915_MADV_WILLNEED`, mapeá-lo via `I915_MMAP_OFFSET_WB`, gravar um padrão de dados e acionar a reclamação de memória `DROP_UNBOUND`, a releitura do mapeamento no módulo original resultou em **perda de dados (`RESULT=DATA_LOSS`)**. Adicionalmente, se dois mapeamentos simultâneos tentam acessar a mesma página em GTT v5, `lkpi_vmf_insert_pfn_prot_locked()` recusa a operação por não suportar dois mapeamentos ativos da mesma página (`lkpi_vmf_insert_pfn_prot_locked: page rename failed: page is mapped`), retornando `VM_FAULT_NOPAGE` e prendendo `linux_cdev_pager_populate()` em um loop contínuo de tentativas de _page fault_.

Quando o motor de renderização 3D/Compute da sua Iris Xe (`rcs0`) tenta ler instruções ou texturas de uma página GEM que foi corrompida, descartada ou paginada para o _swap_ sem preservação de posse, o processador gráfico para de responder. O _watchdog_ do driver detecta que o motor `rcs0` excedeu o tempo limite de preempção e registra nos logs do kernel (`/var/log/messages` ou `dmesg`) a sequência clássica desse bug: `drmn0: [drm] GPU HANG: ecode 12:1:85dffffb, in kwin_wayland` (ou `QSGRenderThread` / `Renderer`), seguida de `drmn0: [drm] Resetting rcs0 for preemption time out`, `drmn0: [drm] kwin_wayland context reset due to GPU hang` e múltiplos avisos de `Fence expiration time out i915-drmn0`.

### 1.2. Qual é a Correlação com o ZFS?

Você mencionou que utiliza ZFS e que já configurou o limite superior do ZFS ARC para 4 GB (`vfs.zfs.arc.max`), mas os travamentos continuaram. A correlação do ZFS com o problema **não é de falha no sistema de arquivos**, mas de **orçamento de memória física**:

Em um notebook com 16 GB de RAM, alocar 4 GB para o ZFS ARC somados à memória _wired_ do próprio kernel FreeBSD deixa aproximadamente 10 a 11 GB livres para o espaço de usuário e para a aceleração gráfica DRM. Quando você executa o KDE Plasma 6.7.5 juntamente com navegadores modernos (Chrome/Firefox), ferramentas de desenvolvimento e outros aplicativos pesados, cada processo aloca buffers `shmem` e objetos GEM compartilhados com a GPU integrada. Ao atingir o limiar de pressão de RAM em que o kernel passa a reclamar caches inativos da GPU ou fazer _page-out_ para o _swap_, o bug de perda de propriedade de páginas `shmem` do `drm-612-kmod` é engatilhado. A confirmação empírica dessa correlação está documentada na _Issue_ #527 do repositório `freebsd/drm-kmod`: desativar o arquivo/partição de _swap_ resolveu os congelamentos recorrentes do `i915` naquele cenário justamente por impedir que as páginas `shmem` fossem paginadas para fora da RAM.

### 1.3. Por Que Alterar a Opção `enable_guc` (3, 2, 1) Só "Melhorou um Pouquinho"?

Você relatou ter testado no boot as configurações de GuC (`enable_guc` em `3`, `2` e `1`), percebendo uma leve melhora, mas sem impedir que a tela travasse ao abrir muitos softwares. Isso acontece porque, no FreeBSD 15.1, coexistem **dois mecanismos de falha distintos**:

O primeiro problema afeta especificamente a submissão de comandos via microcódigo GuC (`enable_guc=1` ou `enable_guc=3`). Fora do driver `i915`, a função `linux_cancel_delayed_work_sync()` no `LinuxKPI` do FreeBSD 15.1 apresentava uma divergência semântica em relação ao kernel Linux: enquanto o Linux retorna `true` sempre que um trabalho agendado é cancelado antes de iniciar sua execução, a implementação do FreeBSD removia a tarefa pendente da fila mas retornava **`false`** (e retornava `true` caso o _callback_ já estivesse em execução e precisasse aguardar seu término). O escalonador GuC do `i915` depende desse valor booleano para decidir se deve fazer o _unpin_ imediato do contexto gráfico ou aguardar a conclusão do fechamento de contexto. Devido ao retorno invertido no `LinuxKPI`, o GuC seguia o caminho incorreto de ciclo de vida, produzindo um estado inválido de escalonamento (`GT0: GUC: Bad context sched_state 0x6`), falhas de mensagens CT/HXG e travamentos de anel (_GPU ring hangs_). Somado a isso, como explicado pelo desenvolvedor Austin Shafer (`amshafer`) na _Issue_ #457, o `LinuxKPI` do FreeBSD processa interrupções em _threads_ preemptíveis (`ithread`) em vez de _hardirq_ direto; sob carga elevada, o atraso na execução da `ithread` permite que a GPU entre no estado de economia de energia **RC6** antes da leitura dos registradores de interrupção, corrompendo o estado lido pelo driver.

Quando você alterou o parâmetro para **`compat.linuxkpi.i915_enable_guc="2"`** (que carrega apenas o microcódigo **HuC** para decodificação de vídeo, mas **desativa a submissão de comandos via GuC**, mantendo o escalonamento via CPU), você evitou o bug de estado `0x6` do GuC. Foi exatamente por isso que o sistema "melhorou um pouquinho". Entretanto, como a perda de páginas `shmem` em `lkpi_vmf_insert_pfn_prot_locked()` e os bugs da versão inicial `6.12.85` do `drm-612-kmod` ocorrem no gerenciamento de memória independentemente do GuC, abrir muitos softwares continuou provocando o congelamento do motor `rcs0`.

### 1.4. Por Que o KWin Morre Definitivamente e o `Ctrl+Alt+F3` Às Vezes Funciona?

Quando o `i915` executa `Resetting rcs0 for preemption time out`, o driver reinicia o contexto gráfico do processo que ocupava o motor 3D no instante do travamento — tipicamente o compositor **`kwin_wayland`** e a thread **`QSGRenderThread`** — invalidando o contexto OpenGL/EGL attivo (`EGL_CONTEXT_LOST`). No KDE Plasma 6.7.5 sob Wayland, o `kwin_wayland` atua como _DRM Master_ e controla diretamente os _pageflips_ via _DRM Atomic KMS_. Após o reset forçado da GPU e a corrupção dos buffers `shmem`, as operações subsequentes de _pageflip_ e _atomic commit_ falham por _timeout_ (`kwin_wayland_drm: Pageflip timed out!` / `atomic commit failed`), impedindo que o KWin restabeleça a comunicação com a placa de vídeo quando você retorna ao `Ctrl+Alt+F2`.

O comportamento intermitente do **`Ctrl+Alt+F3`** depende de quão profunda foi a falha no kernel naquele instante:

- **Quando o `Ctrl+Alt+F3` funciona:** Se o reset de hardware do motor 3D (`rcs0`) foi bem-sucedido e apenas os contextos de usuário do KWin/Qt foram descartados, o motor de exibição 2D (_Display Pipe_) permanece operacional. O console virtual do FreeBSD (`vt(4)`) consegue alternar a tela para o `ttyv2` (`Ctrl+Alt+F3`), e se você iniciar um novo servidor Xorg a partir dali, ele abrirá um novo descritor de arquivo em `/dev/dri/card0` com contextos GEM recém-alocados — funcionando normalmente até que o acúmulo de memória acione um novo _hang_.
- **Quando o `Ctrl+Alt+F3` não funciona:** Se o travamento ocorreu dentro do loop de _page fault_ do `LinuxKPI` (`linux_cdev_pager_populate` repetindo indefinidamente a falha de página mapeada) ou se o hardware falhou ao entrar em estado ocioso (`Failed to idle engines, declaring wedged!`), os _locks_ do subsistema DRM ficam retidos no kernel, bloqueando a troca de terminal virtual e exigindo o desligamento forçado.

---

## 2. O Panorama de Versões: FreeBSD 15.0 vs. 15.1 vs. 15.2 vs. 16.0-CURRENT

Para responder com precisão se a equipe do FreeBSD já corrigiu esses problemas no FreeBSD 15.2 ou no `-CURRENT`, é fundamental distinguir as correções feitas no **repositório de pacotes (`freebsd-ports` / `drm-kmod`)** daquelas feitas no **código-fonte do kernel (`freebsd-src` / `LinuxKPI`)**.

### 2.1. O Que Já Foi Corrigido no `drm-612-kmod` (A Diferença entre `quarterly` e `latest`)

Se você instalou o FreeBSD 15.1-RELEASE e manteve a configuração padrão do gerenciador de pacotes `pkg`, o seu sistema baixa pacotes do repositório **`quarterly`** (trimestral). A tabela abaixo compara as versões de pacotes e o comportamento observado em cada ramo:

| Repositório / Ramo do FreeBSD                                              | Versão do `drm-612-kmod`                                            | Versão do `gpu-firmware-intel-kmod-alderlake` | Versão do `mesa-libs` / `mesa-dri`       | Status para Intel Alder Lake / Iris Xe                                                                                                                              |
| :------------------------------------------------------------------------- | :------------------------------------------------------------------ | :-------------------------------------------- | :--------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **FreeBSD 15.0-RELEASE** (Legado / EoL em 30/09/2026)                      | Não aplicável (Usava **`drm-66-kmod 6.6.25`**)                      | `20250109`                                    | Série `25.x` / `26.0`                    | **Estável:** Usa mapeamento GTT v3, sem acionar a perda de páginas `shmem` ou o bug de Vulkan do 6.12                                                               |
| **FreeBSD 15.1-RELEASE (`quarterly` - Padrão)**                            | **`6.12.85.1501000_2`** (Tag `drm_v6.12.85_2`)                      | `20260519.1501000`                            | `26.2.2`                                 | **Crítico / Instável:** Afetado por bugs de Vulkan, `rcs0 preemption timeout` e perda de páginas `shmem`                                                            |
| **FreeBSD 15.1-RELEASE (`latest`)**                                        | **`6.12.110.1501000_3`** (Tag `drm_v6.12.110_1`, de 07/10/2026)     | `20260519.1501000`                            | `26.2.2_1`                               | **Muito Melhorado:** Corrige o bug de Vulkan no FreeBSD 15.1 para GPUs Intel e melhora a estabilidade sob carga, mas o bug de `shmem` sob _swap_ ainda pode ocorrer |
| **FreeBSD 15.2-BETA1 / `stable/15`** (Lançamento final 15.2 em 08/12/2026) | **`6.12.110_3`** (ou **`drm-66-kmod`** opcional)                    | `20260519`                                    | `26.2.2_1`                               | **Kernel `LinuxKPI` Atualizado:** Inclui correções `PR #2268` (GuC `0x6`), `D58194` e `D58195`, mas aguarda o merge final do patch `shmem` (`D59481` / `D59883`)    |
| **FreeBSD 16.0-CURRENT (`main`)**                                          | **`6.12.110.1600030_3`** (Suporta também `drm_v6.13` e `drm_v6.14`) | `20260519`                                    | `26.2.2_1` (ou `mesa-devel 26.2.b.3834`) | **Não Recomendado:** Em transição do `struct page` (`D58320`/`D58498`), gerando _panics_ de _unwiring_ no `i915` e mantendo o bug da _Issue_ #527                   |

Em **7 de outubro de 2026**, o desenvolvedor Emmanuel Vadot (`manu`) enviou o commit `3e1c3ad47598` para a árvore principal de _Ports_ (`latest`), atualizando o `graphics/drm-612-kmod` da versão `6.12.85_2` para a **`6.12.110_3`** (baseada na release `drm_v6.12.110_1` publicada por Jean-Sébastien Pédron, `dumbbell`). A mensagem oficial do commit registra: _"Update to 6.12.110. This also fixes Vulkan on FreeBSD 15.1 for intel gpu."_. No relatório do Bugzilla do FreeBSD para travamentos em processadores **Alder Lake** (**Bug 295625**), os usuários `Hiroki Tagato` e `Jonathan Chen` relataram entre 12 e 20 de outubro de 2026 que a atualização para o `drm-612-kmod-6.12.110_3` mostrou-se muito mais confiável, suportando dias de uso e testes de carga sem congelar, embora outro usuário (`rkoberman`) ainda tenha registrado um travamento isolado em Alder Lake após mais de um dia de uso.

### 2.2. O Que Mudou no Kernel do FreeBSD 15.2 (`stable/15` / `releng/15.2`) e o Que Ainda Falta?

A atualização do sistema base para o **FreeBSD 15.2-BETA1** (disponível desde 6 de novembro de 2026) ou para o futuro **15.2-RELEASE** (8 de dezembro de 2026) traz três melhorias na camada `LinuxKPI` do kernel, além da atualização do OpenZFS da versão `2.4.2` para a **`2.4.4`**:

1. **Correção do `cancel_delayed_work_sync()` (`freebsd-src` PR #2268 / Commit `79e290d96786`):** Comitada em setembro de 2026 e mesclada via MFC (_Merge From Current_) ao ramo `stable/15` em outubro de 2026, esta alteração alinha o valor de retorno de `linux_cancel_delayed_work_sync()` com a semântica do Linux, corrigindo a corrupção de estado `0x6` do escalonador GuC no `i915`.
2. **Correções de Mapeamento VM no `LinuxKPI` (`D58194` / Commit `8ffe2419e4e7` e `D58195` / Commit `be6e357a3e51`):** Comitadas por `dumbbell` em 7 de setembro de 2026, corrigem uma asserção em `lkpi_vmf_insert_pfn_prot_locked()` (que não capturava um índice de página correspondente ao endereço final) e atualizam a estrutura `struct vm_area_struct` quando um mapeamento existente é estendido.
3. **O Patch de Propriedade `shmem` (Ainda em Revisão):** A causa raiz da perda de dados de buffers GEM quando páginas `shmem` são reclamadas ou paginadas para o _swap_ sob forte pressão de memória está sendo tratada em três frentes técnicas recentes (atualizadas entre 31 de outubro e 4 de novembro de 2026): a revisão **`D59481`** no Phabricator (_"LinuxKPI: preserve shmem backing ownership for managed PFN mappings"_, de Oleg Lelchuk); a revisão **`D59883`** (_"linuxkpi: `lkpi_vmf_insert_special_pte_locked()`"_, proposta por Konstantin Belousov / `kib`); e o commit experimental **`5258f1d`** no `drm-kmod` (_"drm/i915: Restore shmem page ownership after device-pager PTE revocation"_, acompanhado do teste em `https://github.com/lycupay-debug/FreeBSD-i915-LinuxKPI` que validou `RESULT=DATA_PRESERVED` no FreeBSD 15.1-RELEASE-p6).

Como `D59481` e `D59883` ainda estavam em revisão no Phabricator quando a branch `releng/15.2` foi criada em 6 de novembro de 2026, migrar para o 15.2-BETA1 ou para o 16.0-CURRENT hoje não inclui esse patch específico por padrão sem compilação manual de código-fonte.

---

## 3. Plano de Ação Prático: Suas Mudanças Efetivas Hoje

Você dispõe de **três opções práticas** para resolver o problema no seu Dell Vostro 3520, acompanhadas de um conjunto de ajustes recomendados de configuração no `/boot/loader.conf`.

### Opção A (Recomendação Principal): Fazer o "Downgrade Seletivo" para o `drm-66-kmod` no FreeBSD 15.1

Esta é a solução mais direta e amplamente validada por usuários do FreeBSD 15.1 em processadores Intel Comet Lake, Rocket Lake e Alder Lake. Como a GPU Alder Lake Iris Xe possui suporte completo na série 6.6 LTS, regredir apenas o módulo de kernel DRM para o **`drm-66-kmod`** (mantendo todo o restante do seu FreeBSD 15.1-RELEASE e KDE Plasma 6.7.5 intactos) evita os travamentos `rcs0 preemption timeout` e a perda de páginas `I915_GEM_MMAP_OFFSET`, pois o `drm-66-kmod` utiliza o mapeamento GTT versão 3.

Execute os passos abaixo no terminal (como `root` ou via `doas`/`sudo`):

1. **Crie um Boot Environment (BE) de segurança no ZFS antes de substituir módulos de kernel:**

    ```sh
    bectl create pre-drm66-fix
    ```

    Caso ocorra qualquer imprevisto, você pode selecionar o ambiente `pre-drm66-fix` diretamente no menu do bootloader do FreeBSD.

2. **Remova o meta-pacote `drm-kmod` e o `drm-612-kmod`, instale o `drm-66-kmod` e bloqueie-o contra upgrades automáticos:**
   Como `drm-66-kmod` e `drm-612-kmod` possuem conflito de instalação declarado, substitua o pacote e utilize `pkg lock` para impedir que um `pkg upgrade` futuro reinstale a série 6.12:
    ```sh
    pkg delete -f drm-kmod drm-612-kmod
    pkg install drm-66-kmod gpu-firmware-intel-kmod-alderlake
    pkg lock -y drm-66-kmod
    ```
    Verifique com `pkg info drm-66-kmod` se o pacote instalado traz o identificador `.1501000` compilado para a ABI do FreeBSD 15.1. Se preferir compilá-lo localmente a partir da árvore de _Ports_ contra os cabeçalhos exatos do seu kernel em `/usr/src`, execute `cd /usr/ports/graphics/drm-66-kmod && make install clean`.

---

### Opção B: Continuar no `drm-612-kmod`, Migrando para o Repositório `latest` (Versão `6.12.110_3`)

Se você preferir permanecer na série 6.12 do driver DRM, **é essencial sair da versão `6.12.85_2`** fornecida pelo repositório `quarterly` e atualizar para a **`6.12.110.1501000_3`** lançada em 7 de outubro de 2026.

1. **Configure o `pkg` para utilizar os repositórios `latest` (tanto para pacotes gerais quanto para módulos de kernel `kmods` do 15.1):**
   Crie o arquivo `/usr/local/etc/pkg/repos/FreeBSD.conf` com a definição abaixo:

    ```sh
    mkdir -p /usr/local/etc/pkg/repos
    cat << 'EOF' > /usr/local/etc/pkg/repos/FreeBSD.conf
    FreeBSD-ports: {
      url: "pkg+[https://pkg.FreeBSD.org/$](https://pkg.FreeBSD.org/$){ABI}/latest"
    }
    FreeBSD-ports-kmods: {
      url: "pkg+[https://pkg.FreeBSD.org/$](https://pkg.FreeBSD.org/$){ABI}/kmods_latest_${VERSION_MINOR}"
    }
    EOF
    ```

2. **Atualize o catálogo e os pacotes do sistema:**

    ```sh
    pkg update -f
    pkg upgrade -r FreeBSD-ports-kmods
    pkg upgrade
    ```

3. **Verifique as versões atualizadas:**
   Confirme com `pkg info | grep -E 'drm-612-kmod|alderlake|mesa'` que você está executando `drm-612-kmod-6.12.110.1501000_3`, `gpu-firmware-intel-kmod-alderlake-20260519.1501000` e `mesa-libs-26.2.2_1`.

---

### Opção C (Avançada): Mitigação de Swap ou Aplicação Manual do Patch `shmem`

Caso você opte por manter o `drm-612-kmod-6.12.110_3` (Opção B) e ainda enfrente congelamentos quando o uso de memória atingir o limite de paginação, você pode atuar diretamente sobre o gatilho da _Issue_ #527 de duas maneiras:

1. **Desativação de Swap para evitar _page-out_ de objetos `shmem`:** Como documentado na _Issue_ #527, desativar o arquivo ou partição de _swap_ evita que as páginas `shmem` mapeadas pelo `i915` sofram _page-out_, impedindo o gatilho de perda de propriedade (embora exija atenção para não esgotar a RAM física total de 16 GB).
2. **Aplicação de Patch de Código-Fonte (`5258f1d` / `D59481`):** Usuários avançados que compilam o sistema ou os _ports_ localmente podem aplicar o patch de restauração de propriedade `shmem` no `drm-612-kmod` (disponível no commit `5258f1d` referenciado na _Issue_ #527 e no repositório `https://github.com/lycupay-debug/FreeBSD-i915-LinuxKPI`) ou aplicar a revisão **`https://reviews.freebsd.org/D59481`** na árvore `/usr/src` para preservar a posse do objeto `shmem` durante mapeamentos PFN no `LinuxKPI`.

---

## 4. Ajustes Finos de Inicialização (`/boot/loader.conf` e `/etc/rc.conf`)

Na configuração de gráficos Intel no FreeBSD, é fundamental observar dois detalhes técnicos: primeiro, os parâmetros do driver devem ser definidos no **`/boot/loader.conf`** (e não no `/etc/sysctl.conf`), pois precisam estar presentes no ambiente do kernel antes de o módulo `i915kms.ko` ser carregado; segundo, o utilitário `sysrc` não deve ser usado para variáveis contendo pontos (como `compat.linuxkpi.*`), devendo-se editar o `/boot/loader.conf` diretamente.

Adicione ou ajuste os seguintes parâmetros no seu **`/boot/loader.conf`**, otimizados para notebooks Intel Alder Lake (12ª geração) com 16 GB de RAM e ZFS no FreeBSD 15.1/15.2:

```ini
# ===================================================================
# 1. TUNING DO DRIVER INTEL i915 (LinuxKPI) - ALDER LAKE / IRIS XE
# ===================================================================
# Carrega APENAS o microcódigo HuC (aceleração de mídia/VA-API) e
# DESATIVA a submissão de comandos via GuC (evita o bug de estado 0x6
# do cancel_delayed_work_sync no FreeBSD 15.1):
compat.linuxkpi.i915_enable_guc="2"

# Desativa estados profundos de economia de energia de display (DC, PSR, FBC)
# que causam atrasos de interrupção e congelamentos em painéis de notebooks:
compat.linuxkpi.i915_enable_psr="0"
compat.linuxkpi.i915_enable_psr2_sel_fetch="0"
compat.linuxkpi.i915_enable_fbc="0"
compat.linuxkpi.i915_enable_dc="0"
compat.linuxkpi.i915_disable_power_well="0"

# ===================================================================
# 2. LIMITES DE MEMÓRIA COMPARTILHADA (IPC SHM) PARA KDE PLASMA 6 E BROWSERS
# ===================================================================
# Amplia os limites conservadores padrão do FreeBSD para aplicações gráficas
# pesadas, evitando exaustão de segmentos SHM no KWin, Qt6 e navegadores:
kern.ipc.shmseg="1024"
kern.ipc.shmmni="1024"
kern.maxproc="100000"

# ===================================================================
# 3. GESTÃO DE MEMÓRIA ZFS ARC (HOST DE 16 GB)
# ===================================================================
# Define piso de 1 GB e teto de 4 GB (4294967296 bytes), preservando ~11 GB
# livres para o host, aplicativos e buffers GEM da GPU integrada:
vfs.zfs.arc.max="4294967296"
vfs.zfs.arc.min="1073741824"
vfs.zfs.txg.timeout="10"
```

### Verificação de Carregamento do Módulo e Aceleração VA-API (`/etc/rc.conf`)

Certifique-se de que o módulo `i915kms` **não** esteja sendo carregado diretamente pelo `/boot/loader.conf` (onde ele consta na `module_blacklist` padrão do sistema), mas sim na fase posterior do boot via **`/etc/rc.conf`**:

1. **Verifique o carregamento explícito no `/etc/rc.conf`:**
    ```sh
    sysrc kld_list+="/boot/modules/i915kms.ko"
    ```
2. **Permissões de vídeo e pacotes de mídia:** Confirme que o seu usuário pertence ao grupo `video` (`pw groupmod video -m seu_usuario`) e que os pacotes de aceleração de hardware para Alder Lake (`libva-intel-media-driver`, que fornece o driver `iHD`, e `libva-utils`) estão instalados.

### Resumo da Estratégia Recomendada para o Seu Notebook

- **Imediatamente (no FreeBSD 15.1-RELEASE):** Aplique a **Opção A** (instalar e travar o `drm-66-kmod`) juntamente com os parâmetros de `/boot/loader.conf` listados acima. Isso devolverá ao seu Vostro 3520 o mesmo comportamento estável sob uso intenso de memória que você tinha no FreeBSD 15.0, tanto no KDE Plasma 6.7.5 com Wayland quanto no Xorg.
- **A partir de 8 de dezembro de 2026 (no FreeBSD 15.2-RELEASE):** Quando atualizar para o 15.2-RELEASE, você já contará com as correções de kernel `PR #2268`, `D58194` e `D58195`. Assim que as revisões `D59481` / `D59883` (ou o commit `5258f1d` no pacote `drm-612-kmod`) tiverem sido integradas à árvore estável, você poderá destravar o pacote (`pkg unlock drm-66-kmod`) e utilizar o `drm-612-kmod` sem sofrer quedas sob pressão de RAM.

Sources:
[1] https://github.com/freebsd/drm-kmod/issues/467
[2] https://github.com/freebsd/drm-kmod/issues/527
[3] https://www.tgeppert.com/category/it/operating-systems/freebsd/
[4] https://doc.bsdcn.org/di-10-zhang-xian-ka-qu-dong/di-10.1-jie-xian-ka-qu-dong-gai-lun
[5] https://www.sacredheartsc.com/blog/freebsd-15-on-a-laptop/
[6] https://github.com/freebsd/drm-kmod/issues/481
[7] https://reviews.freebsd.org/D53440?id=173438
[8] https://github.com/freebsd/drm-kmod/issues/315
[9] https://github.com/freebsd/drm-kmod/issues/457
[10] https://www.freebsd.org/releases/15.2R/schedule/
[11] https://www.reddit.com/r/freebsd/comments/1xprrml/freebsd_152beta1_now_available/
[12] https://reviews.freebsd.org/D58320?id=182714
[13] https://www.phoronix.com/news/FreeBSD-drm-kmod-Linux-6.12
[14] https://github.com/freebsd/drm-kmod/pulls
[15] https://github.com/freebsd/drm-kmod/releases
[16] https://www.freshports.org/graphics/drm-612-kmod/
[17] https://github.com/freebsd/drm-kmod/issues/509
[18] https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=295625
[19] https://reviews.freebsd.org/differential/diff/184109/
[20] https://reviews.freebsd.org/p/adrian/
[21] https://github.com/GabrielFrigo4/setup/blob/main/docs/BSD.md
[22] https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=298279
[23] https://github.com/freebsd/drm-kmod/issues/441
[24] https://forums.developer.nvidia.com/t/610-and-615-71-09-tx-4070-gpu-lost-after-s3-resume-kwin-wayland-errordevicelost-driver-610-57-04-and-615-71-09-nvidia-open/387871
[25] https://www.reddit.com/r/archlinux/comments/1c8ugwx/i915_hang_and_kwin_wayland_pageflip_timeout/
[26] https://bbs.archlinux.org/viewtopic.php?id=313680
[27] https://forums.opensuse.org/t/kde-plasma-6-8-intermittent-1-2-second-freezes/196672
[28] https://github.com/freebsd/drm-kmod/issues/366
[29] https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=253797
[30] https://github.com/watchthelight-labs/XeGfx/blob/main/README.md
[31] https://forums.freebsd.org/threads/nvidia-packages-in-quarterly-repos-are-un-fit-for-installation-on-freebsd-15-1-use-latest-repos.104039/
[32] https://www.freebsd.org/releases/
[33] https://www.freshports.org/graphics/gpu-firmware-kmod/
[34] https://www.freshports.org/graphics/mesa-libs
[35] https://www.freshports.org/graphics/gpu-firmware-intel-kmod
[36] https://reviews.freebsd.org/p/dumbbell/
[37] https://lists.freebsd.org/archives/dev-ci/2026-October/025411.html
[38] https://www.freshports.org/graphics/mesa-devel
[39] https://cgit.freebsd.org/ports/commit/?id=3e1c3ad475984e424b30424c306bcdbb1a091569
[40] https://www.freebsd.org/releases/15.2R/relnotes/
[41] https://freebsd-git-weekly.tarsnap.net/2026-09-07.html
[42] https://reviews.freebsd.org/p/bz/
[43] https://note.com/jamesmondo/n/n5aaaaa634db1?hl=en
[44] https://www.freshports.org/graphics/drm-66-kmod
[45] https://www.reddit.com/r/freebsd/comments/1ugomc1/freeebsd_151_nvidia_woes/
[46] https://github.com/freebsd/freebsd-ports/blob/main/graphics/drm-612-kmod/files/pkg-message.in
[47] https://bugs.freebsd.org/296195
[48] https://forums.freebsd.org/threads/vt-vga-resolution-640x480-change-at-early-boot-stage-possible.73109/
