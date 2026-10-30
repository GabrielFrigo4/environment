# 🗺️ Roadmap & Status — Universal Environment

> **Status:** 🟢 **100% Operacional & Estável — Zero Pendências Ativas**
> O orquestrador central do Quarteto de Produtividade atingiu maturidade arquitetural plena. Todos os 10 grandes épicos do ecossistema foram integralmente entregues, testados e auditados em Linux, FreeBSD e Windows.

---

## 📊 Matriz de Maturidade do Ecossistema

| Repositório              | Papel                       | Maturidade | Cobertura / Estado                                                                                                                                                                            |
| :----------------------- | :-------------------------- | :--------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Environment**          | Hub central & Makefile      | 🟢 Estável | Orquestração global, quality gates unificados (`make ci`), documentos canônicos, suíte de editores e compositores                                                                             |
| **Shell**                | Motor de terminal & prompts |  🟢 100%   | Latência < 31ms (ULTRA), despachante universal de display server (`window-manager`, `graphical-launcher`, `emacs-window-manager`), simetria Wayland/X11 e ciclo tripartite do `_exec_wayland` |
| **Setup**                | Provisionador de sistema    | 🟢 Estável | Arquitetura modular `core/`, tétrade Wayland (`sway/river/labwc/cage`), players mídia (`mpv`), Terminus console/TTF e mouse `gpm`/`moused`                                                    |
| **Vault**                | Cofre privado de segredos   | 🟢 Estável | Chaves SSH, auditoria canônica `age`, backups e `.env` seguros                                                                                                                                |
| **Profile**              | Dotfiles & skills de IA     | 🟢 Estável | Paridade multiplataforma, foco em emuladores gráficos e skills                                                                                                                                |
| **Emacs**                | Editor Elisp extensível     | 🟢 Estável | Arquitetura sensorial, aweww "LSP da Web" Dual-Engine (Chromium/dump-dom por SO + fallback eww), player `mpv` IPC e ergonomia TTY                                                             |
| **Helix / NeoVim / Vim** | Suíte de Editores modais    | 🟢 Estável | Runtimes soberanos, Mason LSP, mouse SGR 1006 no FreeBSD `vt(4)`, cursores em bloco coloridos por modo no TTY e `:terminal` 16 cores                                                          |
| **Template**             | Arquétipo de novos projetos | 🟢 Estável | Scaffolding `init.sh`, suíte de auditoria e TUI semântica                                                                                                                                     |

---

## 🛡️ Atributos e Conquistas Centrais

- **Zero Pendências:** 100% dos épicos (Otimização do Shell, Lapidação do Profile, Invariante Out-of-the-Box, AI Skills, Paridade Windows Tripartite, Modularização de Scripts, Virtualização Híbrida Bhyve, Portal Canônico de Docs, Refatoração do Setup e GNU Emacs Sensorial) foram integralmente concluídos e verificados.
- **Despachante Universal de Display Server (`_dispatch_display_server`):** Arquitetura desacoplada onde comandos universais (`window-manager`, `graphical-launcher`, `emacs-window-manager`) despacham transparentemente para variantes `-wayland` ou `-x11`, com autocompletion semântico unificado e aliases ergonômicos (`wm`, `win`, `wwm`, `way`, `xwm`, `xorg`, `x11`, `gui`, `wgui`, `xgui`, `ewm`, `wewm`, `xewm`).
- **Inicialização Multi-SO de Wayland (`_exec_wayland`) & X11 (`_exec_x11`):** Execução adaptativa com detecção e preservação íntegra de `/run/user/$UID/bus` no Linux com systemd (eliminando crashes no GNOME session target a partir do TTY), integração nativa com ConsoleKit2 no FreeBSD, `dbus-run-session` / `dbus-launch` no OpenBSD e ambientes sem systemd, e resolução universal de terminais virtuais (`vtN`) no Linux (`/dev/tty*`), FreeBSD (`/dev/ttyv*`) e OpenBSD wscons (`/dev/ttyC*`).
- **Lançadores Efêmeros Multi-TTY (`graphical-launcher`):** Isolamento de processos gráficos atrelados a consoles TTY via Wayland (`sway > river > labwc > cage`) e Xorg (`xinit`) com restauração instantânea de console (VT bounce) no FreeBSD.
- **Sessões Soberanas de Emacs OS (`emacs-window-manager`):** Lançadores dedicados para Wayland nativo (base Smithay/Rust com DRM/seatd direto) e X11 legado (EXWM).
- **Aweww — "LSP da Web" & MPV IPC:** Hidratação assíncrona de páginas web dinâmicas via motor headless Dual-Engine (Chromium-first com `--dump-dom` por SO, fallback nativo EWW), pesquisa sem captcha, perfil efêmero temporário (`aweww-profile/`) e reprodução multimídia assíncrona com sentinelas defensivas prevenindo processos zumbis.
- **Paridade de Mouse e Cursor em Raw TTY:** Protocolo SGR 1006 no console FreeBSD para Vim e NeoVim, cursor colorido em bloco por modo no TTY e `:terminal` embutido sincronizado com 16 cores.
- **Tétrade de Compositores e Tipografia Terminus:** Provisionamento idempotente de compositores Wayland, players multimídia e fontes Terminus no Linux e FreeBSD.
- **Suíte Tripartite Windows Hardened:** Resolução da inconsistência dual `Path`/`PATH` no NuShell, eliminação de recursão de aliases circulares no PowerShell (`Clean-System`) e paridade total de atalhos do Antigravity CLI (`agy`).
- **Paridade Universal em Loaders do Vault:** Garantia de que todos os carregadores (`vault.sh`, `vault.ps1`, `vault.nu`, etc.) excluam uniformemente arquivos de template e exemplo, blindando o ecossistema contra vazamento de tokens fictícios.
- **Auto-Cura Reentrante Multi-Shell:** Propagação cruzada automática de perfis físicos em disco (`Documents\PowerShell`, `%APPDATA%\nushell`, `%LOCALAPPDATA%\clink`) via `upsh` e `resh` sem qualquer intervenção manual de cópia.
- **Higienização Pré-Pull na Suíte de Editores:** Limpeza defensiva de stubs locais (`usr/local/`) em `Update-Editors` prevenindo abortos de `git pull --ff-only`.
- **Paridade UTF-8 no Git:** Configuração universal `core.quotepath = false` garantindo legibilidade de caminhos acentuados em todas as plataformas.
- **Hermetismo e Soberania:** O ecossistema é 100% autônomo e opera sem qualquer dependência externa ou intervenção manual pós-clone.
- **Engenharia Antifrágil:** Conformidade estrita com os 22 Principles UNIX, réguas de 32/64 colunas, biblioteca semântica `_ui_*` e quality gates automatizados.

---

## 📌 Backlog & Próximos Passos

### 🔥 0. Blindagem de Kernel, GPU (`i915kms` Alder Lake) & ZFS contra Congelamentos Gráficos (FreeBSD 15.1)

> **Contexto do Incidente:** Congelamento total do display e do input (teclado/mouse param de responder, até o LED do Caps Lock trava, enquanto o áudio em segundo plano continua tocando normalmente). Ocorre tanto em Wayland (KDE Plasma, Sway) quanto em X11 (KDE X11, EXWM), sendo acelerado pelo tempo de uptime do sistema, abertura de múltiplas abas/aplicações pesadas e disparo de _file watchers_ sobre múltiplos repositórios (ex: abrir `~/Documents` no VS Code).

- [ ] **Correção Definitiva da OID do LinuxKPI (`Setup` / `/boot/loader.conf`):**
    - **Correção Crítica de Sintaxe de Módulo:** Auditoria revelou que as flags no `/boot/loader.conf` estavam declaradas com o prefixo obsoleto/incorreto `compat.kpi.` em vez de `compat.linuxkpi.`, fazendo com que o kernel ignorasse silenciosamente todas as proteções (`enable_dc`, `enable_psr`, `enable_fbc`). Garantir que todos os scripts do repositório `Setup` injetem estritamente com `compat.linuxkpi.`:
        ```ini
        compat.linuxkpi.i915_enable_psr="0"
        compat.linuxkpi.i915_enable_psr2_sel_fetch="0"
        compat.linuxkpi.i915_enable_fbc="0"
        compat.linuxkpi.i915_enable_dc="0"
        compat.linuxkpi.i915_enable_guc="3"
        ```
- [ ] **Mitigação de Pressão de Memória ZFS ARC vs. Alocador DRM `LinuxKPI` (`Setup` / `/boot/loader.conf`):**
    - **Migração da Sysctl Depreciada:** Substituir definitivamente `vfs.zfs.arc_max` (com _underline_, que gera `WARNING: sysctl vfs.zfs.arc_max is deprecated. Use vfs.zfs.arc.max instead` no boot) pela nova OID `vfs.zfs.arc.max` (com ponto) nos scripts do repositório `Setup`.
    - **Redução do Teto do ZFS ARC (8 GB $\rightarrow$ 4 GB):** Em máquinas de 16 GB de RAM com GPU integrada Intel Iris Xe (que compartilha RAM do sistema e exige alocações físicas rápidas via `LinuxKPI`), reduzir `vfs.zfs.arc.max` de `8589934592` (8 GB) para `4294967296` (4 GB) e definir `vfs.zfs.arc.min=1073741824` (1 GB). Isso impede que a varredura de repositórios Git inche o ARC a ponto de sufocar e travar o driver `i915kms` ao abrir novas janelas/abas.
- [ ] **Aceleração de Hardware VA-API para Intel Gen 12 (`Setup`):**
    - [x] Instalado manualmente no host (`sudo pkg install libva-intel-media-driver` + `gmmlib`), eliminando o erro `vaInitialize failed: unknown libva error` no Chromium/Electron.
    - [ ] Automatizar a instalação de `libva-intel-media-driver` e `libva-utils` nos scripts de provisionamento de hardware Intel do repositório `Setup` e exportar `LIBVA_DRIVER_NAME=iHD` no `Profile`.
- [ ] **Tuning de File Descriptors (`maxfiles`), IPC Shared Memory e Inotify/Kqueue (`Setup` / `/etc/sysctl.conf`):**
    - Garantir nos scripts do `Setup` um piso superior explícito para workloads pesados de desenvolvimento + Wayland/X11, além de memória compartilhada (`shm`) generosa para Chromium/Firefox/KDE:
        ```ini
        kern.maxfiles=1048576
        kern.maxfilesperproc=524288
        vfs.zfs.arc.max=4294967296
        kern.ipc.shmmax=2147483648
        kern.ipc.shmall=524288
        kern.ipc.shm_allow_removed=1
        ```
- [ ] **Desativação Total de File Watchers (`kqueue`) e Indexadores de Background (`Profile` & `Setup`):**
    - **Neutralização do File Watcher no VS Code (`Profile` / `settings.json`):** No FreeBSD, cada arquivo monitorado via `libinotify`/`kqueue` consome 1 _file descriptor_ real no kernel e pressiona o cache de metadados do ZFS. Adicionar ao `settings.json` versionado no `Profile` a desativação global do _watcher_ (`"**/*": true`):
        ```json
        "files.watcherExclude": {
            "**/*": true
        }
        ```
    - **Desativação do Indexador `baloo` no KDE Plasma:** Incluir nos scripts de configuração do ambiente desktop a desativação do indexador de arquivos do KDE (`balooctl6 disable && balooctl6 purge`), que falhava no `way.log` e disputava I/O e descritores ao varrer diretórios com múltiplos repositórios.

---

### 🔴 1. Correções Críticas de Sessão Gráfica, EWM e EXWM (Baseado em Logs)

- [ ] **Correções Pós-Teste no Host FreeBSD (`wewm`, `xewm` e Higiene de TTY):**
    - [x] **Fim do Segfault e Detecção de GPU/Output Confirmada no `wewm`:** O patch no `drm-rs` resolveu a detecção da GPU (`DrmNode { dev: 96, ty: Primary }`, `eDP-1 1920x1080@120Hz`) e a remoção de `:xkb-layouts` eliminou o segfault no `libxkbcommon`.
    - [ ] **Tela Cinza no `wewm` (Frame do Emacs não exibido sobre o compositor):** O compositor inicia, prepara o frame para `eDP-1` e conecta o `IM relay`, mas o frame gráfico do Emacs (`--fg-daemon=ewm`) não é mapeado/renderizado na superfície Wayland (`wayland-ewm`). Investigar se o daemon está conectando ao display X11/Wayland errado ou se `ewm-start-module` requer criação explícita de frame client PGTK em `WAYLAND_DISPLAY=wayland-ewm`.
    - [x] **Erro Elpaca `Duplicate item ID queued: intern` no `xewm` (`exwm.el`) & `when-let` Obsoleto:** Corrigida a chamada macro `(elpaca (intern pkg))` (que passava o símbolo literal `intern` duas vezes ao Elpaca) para `(elpaca xelb)` / `(elpaca exwm)`, e substituído `when-let` por `when-let*` em `init.el`.
    - [x] **Lixo no Prompt do Terminal (`$&.`) ao Sair do `xgui` / `xewm`:** Removida a emissão de sequências OSC 112 (`\e]112\a\e]112\e\\`) em consoles Raw TTY (`_is_raw_tty`) dentro de `_restore_tty_cursor` + adicionado `stty sane`.
- [x] **Correção de Segfault e Inicialização DRM/D-Bus no EWM (`wewm` / `libewm_core.so`):**
    - ✅ **Implementado (pendente validação no host FreeBSD — recompilar via `Setup/common/editors/ewm.sh`):** patch FreeBSD no `drm-rs` (tipo do nó derivado do `devname`, não do `minor(dev)` arbitrário do devfs) aplicado via `--config patch.crates-io`; `ewm-input-config` sem nomes XKB (evita `set_xkb_config` → segfault; keymap via `XKB_DEFAULT_*`); `wewm` sob `dbus-run-session` quando não há barramento; `RUST_LOG` silencia `login1`/`xwayland-satellite`; tool-bar habilitada com offset combinado menu-bar + tool-bar (`ewm-show-tool-bar`).
    - **Memory Safety (`libxkbcommon`):** Investigar e corrigir o _Segmentation fault_ em `xkb_keymap_unref` (`0x8499e3513`) e `xkb_state_unref` (`0x8499e63ef`) disparado dentro de `libewm_core.so` imediatamente após a atualização de input (`Input config updated: 3 entries` / `Keyboard repeat: rate=50, delay=200`).
    - **Detecção de Outputs DRM:** Diagnosticar por que o backend DRM inicializa em `/dev/dri/card0` (`DrmNode { dev: 96, ty: Control }`) reportando área zerada (`Total output area: 0x0 (0 outputs)` / `Sent 0 output_detected events`).
- [x] **Estabilização do Ciclo de Vida X11 / EXWM (`xewm` / `xinit` no FreeBSD 15.1):**
    - ✅ **Implementado (pendente validação no host FreeBSD):** `ck-launch-session` nunca recebe flags (script de sessão auto-reexecutado via `dbus-run-session -- ck-launch-session "$0"`); `xinit` com `-auth` pré-criado em `0600` preferido sobre `startx` (fim do `~/.serverauth.*`); aviso de fallback `scfb` quando `/dev/dri/card0` não existe; ruído do `xkbcomp`/`scfb trace` filtrado da saída de diagnóstico.

---

### 🖥️ 2. Compositores Wayland/X11, Lançadores `(x/w)gui` e Despachante `wm`

- [ ] **Detecção de Binários Gráficos vs. TUI no `(x/w)gui` (`graphical-launcher`):**
    - 🔄 **Parcialmente implementado:** whitelist explícita de binários GUI (`firefox`, `chrome`, `chromium`, `vscode`/`code`, `emacs`, etc.) adicionada em `_is_terminal_app` para impedir que wrappers POSIX em `/usr/local/bin/` sejam abertos dentro do `foot`/`xterm`. Falta testar `xgui`/`wgui vscode` no host FreeBSD.
    - **Peculiaridade de Binário no FreeBSD (`chrome` vs `chromium`):** Documentar e tratar nos scripts de despacho o fato de que o pacote Chromium no FreeBSD instala o binário executável sob o nome `chrome` (`/usr/local/bin/chrome`), evitando falhas de detecção ou colisão com o Google Chrome no Linux.
- [ ] **Soberania e Pré-Configuração da Tétrade Wayland (`sway`, `river`, `labwc`, `cage`) e X11:**
    - [x] **Sway Config & Diálogo de Arquivo no Emacs GUI:** Corrigido `seat * hide_cursor when-typing disable` (substituindo `hide_cursor_when_typing no` inválido na linha 6) e restringido `fullscreen enable` apenas a janelas `tiling`/`normal` (excluindo `dialog`, `utility`, `popup_menu` e `floating`).
- [x] **Novo Despachante / Alias `wm` (Window Manager Puro):**
    - ✅ **Implementado (pendente validação no host):** `wm` (`wwm` / `xwm`) desacoplado de `way`/`xorg`, priorizando `Sway > Labwc > River > Cage (com foot)` no Wayland e WMs leves (`i3 > openbox > bspwm > awesome > dwm...`) no X11 antes de cair em fallback para `way`/`xorg` (KDE/GNOME).

---

### 🐃 3. GNU Emacs, Editores Modais e Ergonomia em Raw TTY

- [ ] **Fluidez no Redimensionamento de Janelas do GNU Emacs (FreeBSD / KDE Plasma):**
    - Investigar e corrigir o travamento/congelamento que ocorre **exclusivamente com o Emacs** ao redimensionar sua janela no FreeBSD sob o KDE Plasma / KWin. Ajustar propriedades de geometria do frame no Elisp (`frame-resize-pixelwise`, `frame-inhibit-implied-resize`).
- [x] **Comandos Interativos de Lançamento de Apps Gráficos no Emacs:**
    - ✅ **Implementado:** adicionados `M-x kate`, `M-x gimp`, `M-x wireshark`, `M-x kdeconnect` / `M-x kdeconnect-app`, `M-x thunderbird`, `M-x chrome` e `M-x chromium` em `etc/apps/apps.el`.
- [ ] **Ergonomia, Keymaps e Latência em Console Puro (Raw TTY):**
    - **Navegação por Palavra (`Ctrl+Left` / `Ctrl+Right`) no TTY:** Corrigir o mapeamento de teclas de modificação no console puro do FreeBSD (`vt(4)`) e do Linux injetando regras customizadas via `kbdcontrol` (FreeBSD) e `loadkeys` (Linux) mapeando `Ctrl+Left/Right` para as sequências CSI modificadas padrão xterm (`^[[1;5D` e `^[[1;5C`).

---

### 🐚 4. Repositório `Shell` & `Profile` — Camada GNU Coreutils, Skills Bhyve & Reforma de Aliases (`open-*`)

- [ ] **Consciência de Topologia Híbrida nas AI Skills (`agy` em Bhyve VM vs. Host FreeBSD):**
    - Refinar as instruções das skills e prompts de contexto no repositório `Profile` para que o `agy` (Antigravity CLI), ao rodar dentro da VM Linux sob **Bhyve** com diretórios do hospedeiro **FreeBSD** montados/compartilhados, distingua o ambiente de execução local da VM do sistema operacional real dos arquivos/host (`FreeBSD`).
- [ ] **Reforma da Família de Aliases `o*` / `open-*` (Shell & Emacs `aweshell`):**
    - **Remoção de Wrappers Redundantes para Editores TUI:** Remover `open-vim` (`ov`), `open-neovim` / `open-nvim` (`on`) e `open-micro` (`om`).
    - **Nova Matriz de Aliases de Aplicações e Sessão:**
        - `ov` $\rightarrow$ **VLC**
        - `om` $\rightarrow$ **MPV**
        - `os` $\rightarrow$ **Wireshark**
        - `of` $\rightarrow$ **Firefox**
        - `ow` $\rightarrow$ **Web Browser Universal** (`chrome` / `chromium` / `firefox`)
        - `oo` $\rightarrow$ **OnlyOffice**
        - `ol` $\rightarrow$ **LibreOffice**
        - `wm` $\rightarrow$ **Window Manager Puro** (`<Sway, Labwc, River, Cage>`)

---

## 💡 Insights & Notas Arquiteturais (Diagnósticos de Referência)

> [!NOTE]
> Registro técnico das causas-raiz identificadas durante a triagem de logs e testes em FreeBSD e Linux para guiar a implementação:

- **Por que o FreeBSD congela o display e o teclado (nem o Caps Lock responde), mas o áudio continua tocando (Wayland & X11):** O sintoma ocorre quando o módulo do kernel `i915kms` (que roda sob a camada _LinuxKPI_ em GPUs Intel 12th Gen Alder Lake) entra em _deadlock_ de alocação de páginas físicas ou sofre um _GPU Hang_ em transições de estados de energia devido ao prefixo incorreto `compat.kpi.` em vez de `compat.linuxkpi.` no `/boot/loader.conf`. Com `vfs.zfs.arc.max` configurado na sintaxe antiga e em 8 GB (`8589934592`) num sistema de 16 GB de RAM, o uso prolongado ou a abertura de uma pasta com 16 repositórios no VS Code faz o ZFS ARC e a tabela `kqueue` ocuparem e fragmentarem a RAM física. Quando o navegador ou o compositor gráfico pede memória contígua à GPU integrada, a thread DRM do servidor gráfico trava esperando a liberação do ARC ou do firmware GuC. Como o servidor gráfico (KWin, Sway ou Xorg) é o dono dos descritores `evdev`/`libinput` e da atualização de LEDs do teclado em modo gráfico, o teclado congela junto com a imagem na tela, enquanto o kernel FreeBSD e o subsistema de som (`snd_hda`/`pcm`) continuam executando o áudio do navegador normalmente em background.
- **Correção da OID do LinuxKPI:** O uso correto no `/boot/loader.conf` para tunar o driver i915 no FreeBSD é `compat.linuxkpi.i915_enable_dc="0"` e `compat.linuxkpi.i915_enable_psr="0"` (e não `compat.kpi.*`).
- **Por que `firefox` e `chrome` abrem encaixotados e com terminal ao fundo no `(x/w)gui`:** Discrepâncias no nome do `.desktop` — especialmente no FreeBSD, onde o binário do Chromium chama-se `chrome` (`/usr/local/bin/chrome`), mas o arquivo de entrada pode ser `chromium-browser.desktop` — ou wrappers de shell intermediários fazem o lançador cair no _fallback_ de "aplicativo de terminal", executando equivocadamente `foot -e chrome` ou `xterm -e firefox`.
- **Por que `Ctrl+Left` e `Ctrl+Right` emitem `^[[D` / `^[[C` (setas normais) no Raw TTY:** Por herança histórica da emulação VT100/cons25, os mapas de teclado do kernel tanto no FreeBSD (`vt(4)` em `/usr/share/vt/keymaps/`) quanto no Linux (`kbd` / `loadkeys`) não diferenciam a tecla `Left` de `Ctrl+Left` na tabela de scancodes padrão. A solução definitiva no repositório `Setup` consiste em injetar regras customizadas via `kbdcontrol` (FreeBSD) e `loadkeys` (Linux) mapeando `Ctrl+Left/Right` para as sequências CSI modificadas padrão xterm (`^[[1;5D` e `^[[1;5C`).
- **Por que apenas o GNU Emacs trava ao redimensionar no FreeBSD (KDE):** Por padrão (`frame-resize-pixelwise nil`), o Emacs negocia o tamanho da sua janela com o Manager em múltiplos exatos da largura/altura da fonte. Ativar `(setq frame-resize-pixelwise t)` no `early-init.el` elimina o gargalo.

---

## 🔮 Para Depois (Backlog Futuro)

- [ ] **Polimento Estético, Dark Mode Unificado e Herança Dinâmica de Temas nos Compositores (`sway`, `labwc`, `river`, `cage`):** Refinar o visual dos compositores leves para que iniciem com uma identidade visual minimalista, escura (_Dark Mode_) e coesa, integrando temas do KDE/GNOME via `xdg-desktop-portal`.
- [ ] **Expansão de Ferramentas CLI Modernas em Rust & Aliases Ultra-Curtos (Single-Char):** Substituir utilitários tradicionais por alternativas em Rust (`ripgrep`/`rg`, `eza`, `bat`, `fd`, `zoxide`, `delta`).
- [ ] **Integração de Agentes e LLMs no Emacs via Assinatura (Zero Custo por Token / Sem API Avulsa):** Integrar ferramentas como `agy` e `claude` no Emacs consumindo planos de consumidor vigentes via adaptador local (`gptel`) ou processos assíncronos (`make-process`).

---

# ToDo para o ToDo

## Erro que deu no Emacs quando eu salvei esse ToDo

```el
Saving file /home/gabrielf/Documents/Environment/TODO.md...
Wrote /home/gabrielf/Documents/Environment/TODO.md
../../.emacs.d/var/lib/elpaca/builds/apheleia/apheleia-formatters.el: Warning: ‘when-let’ is an obsolete macro (as of 31.1); use ‘when-let*’ or ‘and-let*’ instead. [5 times]
../../.emacs.d/var/lib/elpaca/builds/apheleia/apheleia-rcs.el: Warning: ‘when-let’ is an obsolete macro (as of 31.1); use ‘when-let*’ or ‘and-let*’ instead.
Mark set
```

## Erro que acontece no gui e possivelmente no ewm

O mouse é lerdo... Ele não tem a aceleração que no exwm por exemplo tem (e provavelmente no xgui) e no KDE e no GNOME (tive que configurar? Sim mas está otimo agora nesses ambientes ai, as vezes vem por padrão).

## Melhorar o Emacs

- O Autocomplete dele é instantâneo... Seria legal se tivesse um mini delay antes de aparecer as opções... Ou outra maneira melhor. E o autocomplete me obriga a dar 2 enters no `:w` para salvar vei... pqp.

## Colocar no Setup

- Instalar o Cmake (`cmake-core cmake-man cmake-gui`).

## Melhorar o Environment

- [ ] Arrumar / Adicionar os `.gitattributes` com o do Template.

## Melhorar no Way / X11, Xorg

Eu iniciei o sistema via o comando `way` e o zsh do konsole está no tema do TTY kkkk. E isso acontece com o `:terminal` do vim/nvim e no term e vterm do Emacs... Temos que melhorar isso nos comandos que inicializam um sistema via TTY... Tem que resetar esse tipo de variável.

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
