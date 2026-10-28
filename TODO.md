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
- **Engenharia Antifrágil:** Conformidade estrita com os 22 Princípios UNIX, réguas de 32/64 colunas, biblioteca semântica `_ui_*` e quality gates automatizados.

---

## 📌 Backlog & Próximos Passos

### 🔴 1. Correções Críticas de Sessão Gráfica, EWM e EXWM (Baseado em Logs)

- [x] **Correção de Segfault e Inicialização DRM/D-Bus no EWM (`wewm` / `libewm_core.so`):**
    - ✅ **Implementado (pendente validação no host FreeBSD — recompilar via `Setup/common/editors/ewm.sh`):** patch FreeBSD no `drm-rs` (tipo do nó derivado do `devname`, não do `minor(dev)` arbitrário do devfs) aplicado via `--config patch.crates-io`; `ewm-input-config` sem nomes XKB (evita `set_xkb_config` → segfault; keymap via `XKB_DEFAULT_*`); `wewm` sob `dbus-run-session` quando não há barramento; `RUST_LOG` silencia `login1`/`xwayland-satellite`; tool-bar habilitada com offset combinado menu-bar + tool-bar (`ewm-show-tool-bar`).
    - **Memory Safety (`libxkbcommon`):** Investigar e corrigir o _Segmentation fault_ em `xkb_keymap_unref` (`0x8499e3513`) e `xkb_state_unref` (`0x8499e63ef`) disparado dentro de `libewm_core.so` imediatamente após a atualização de input (`Input config updated: 3 entries` / `Keyboard repeat: rate=50, delay=200`).
    - **Detecção de Outputs DRM:** Diagnosticar por que o backend DRM inicializa em `/dev/dri/card0` (`DrmNode { dev: 96, ty: Control }`) reportando área zerada (`Total output area: 0x0 (0 outputs)` / `Sent 0 output_detected events`).
    - **Barramento D-Bus e Serviços no FreeBSD / Ambientes Non-Systemd:**
        - Corrigir a falha de conexão ao socket D-Bus em `/var/run/xdg/$USER/bus` (`os error 2` ao iniciar `org.freedesktop.ScreenSaver`) e o erro `exit status: 71` (`EX_OSERR`) no `import-environment`.
        - Tratar graciosamente a ausência de `org.freedesktop.login1` em sistemas com `seatd`/ConsoleKit2 (`Failed to acquire lid switch inhibitor`) e tornar opcional/silencioso o spawn de `xwayland-satellite` quando o binário não estiver instalado (`os error 2`).
    - **Tool-Bar no EWM (`wewm`):** Investigar e restaurar a exibição, estilização e offsets de renderização consistentes da `tool-bar` (Bar-Tools) dentro do ambiente EWM.
- [x] **Estabilização do Ciclo de Vida X11 / EXWM (`xewm` / `xinit` no FreeBSD 15.1):**
    - ✅ **Implementado (pendente validação no host FreeBSD):** `ck-launch-session` nunca recebe flags (script de sessão auto-reexecutado via `dbus-run-session -- ck-launch-session "$0"`); `xinit` com `-auth` pré-criado em `0600` preferido sobre `startx` (fim do `~/.serverauth.*`); aviso de fallback `scfb` quando `/dev/dri/card0` não existe; ruído do `xkbcomp`/`scfb trace` filtrado da saída de diagnóstico.
    - **Flag Inválida no ConsoleKit2:** Remover a flag `--exit-with-session` passada indevidamente ao `ck-launch-session` (`WARNING: Unknown option --exit-with-session` — flag pertence ao `dbus-launch`, não ao `ck-launch-session`), que aborta o processo cliente imediatamente e derruba o servidor Xorg (`xinit: connection to X server lost`).
    - **Driver Gráfico & Higiene Xorg:** Avaliar o fallback em `scfb` (`scfb trace: probe start/done` em `Xorg.1.log`), garantir a pré-criação limpa do arquivo de autoridade `xauth` (`~/.serverauth.*`) e silenciar os warnings benignos do `xkbcomp` de redefinição de `<FK23>`/`<FK24>` e keysyms ausentes (`XF86ElectronicPrivacyScreenOn`, etc.).

---

### 🖥️ 2. Compositores Wayland/X11, Lançadores `(x/w)gui` e Despachante `wm`

- [ ] **Detecção de Binários Gráficos vs. TUI no `(x/w)gui` (`graphical-launcher`):**
    - **Classificação Incorreta de Apps Gráficos (`firefox` / `chrome`):** Corrigir a heurística do `(x/w)gui` que identifica erroneamente o Firefox e o Chrome/Chromium como aplicações de terminal (TUI), fazendo com que abram encaixotados/sem fullscreen e com uma janela de emulador de terminal (`foot`/`xterm`) presa ao fundo.
    - **Execução Silenciosa Falha no VS Code (`(x/w)gui vscode`):** Investigar por que a invocação do VS Code via wrapper gráfico falha silenciosamente sem abrir janela (verificar resolução de binário `code`/`code-oss`, flags de Electron/Wayland `--ozone-platform-hint=auto` ou bloqueio de sandbox).
    - **Peculiaridade de Binário no FreeBSD (`chrome` vs `chromium`):** Documentar e tratar nos scripts de despacho o fato de que o pacote Chromium no FreeBSD instala o binário executável sob o nome `chrome` (`/usr/local/bin/chrome`), evitando falhas de detecção ou colisão com o Google Chrome no Linux.
- [ ] **Soberania e Pré-Configuração da Tétrade Wayland (`sway`, `river`, `labwc`, `cage`) e X11:**
    - Garantir que todos os compositores possuam configurações base autônomas, elegantes e respeitando a filosofia de cada projeto — funcionando perfeitamente tanto como alternativas leves ao KDE/GNOME (via `way`/`xorg`) quanto acoplados ao `(x/w)gui` e `(x/w)ewm`, sem regredir ou quebrar os ambientes principais.
    - **Polimento de Input, Locale e Escala (HiDPI):** Padronizar layout de teclado correto, variáveis de idioma/locale e escala de resolução (ex: 125% condicional).
    - **Ajuste Visual do `labwc` e `foot`:** Corrigir a escala desproporcional do terminal `foot` dentro do `labwc` (que aparenta abrir em ~150% mesmo com resolução em 100%) e estilizar o menu raiz do `labwc` (substituindo o fundo 100% preto e o popup cru `terminal/reconfigure/exit` por uma configuração visual limpa e intuitiva).
    - **Sway Config & Diálogo de Arquivo no Emacs GUI:** Corrigir o erro de sintaxe na linha 6 da configuração do Sway (banner vermelho `"there are errors in your config file"`) e corrigir o bug onde acionar _"open new file"_ (diálogo gráfico de arquivo) no `wgui`/`xgui emacs` trava a abertura de popups subsequentes.
- [ ] **Novo Despachante / Alias `wm` (Window Manager Puro):**
    - Criar o comando/alias `wm` (`wwm` / `xwm`) seguindo a fila de prioridade do `gui` (`Sway > Labwc > River > Cage`), herdando toda a pré-configuração de teclado, escala e estética do `(x/w)gui` e `(x/w)ewm`, mas iniciando o compositor **puro** (sem atrelar a vida da sessão a um aplicativo alvo único).
    - Em compositores orientados a quiosque/janela única onde iniciar vazio não faz sentido (como `cage`), inicializar automaticamente com o terminal padrão da sessão (`foot` no Wayland / `xterm` no X11), permitindo digitar `wm` direto do TTY e já ter um ambiente gráfico produtivo sem depender de KDE ou GNOME.
- [ ] **Simetria Multi-SO nos Comandos `way` e `x11`/`xorg`:**
    - Auditar e unificar o tratamento de erros e diferenças de inicialização de sessão gráfica entre FreeBSD e Linux nos despachantes `way`, `x11` e `xorg`.

---

### 🐃 3. GNU Emacs, Editores Modais e Ergonomia em Raw TTY

- [ ] **Fluidez no Redimensionamento de Janelas do GNU Emacs (FreeBSD / KDE Plasma):**
    - Investigar e corrigir o travamento/congelamento que ocorre **exclusivamente com o Emacs** ao redimensionar sua janela no FreeBSD sob o KDE Plasma / KWin (e validar se o comportamento também se manifesta no GNOME/Mutter, indicando ser uma questão intrínseca do Emacs/toolkit gráfico no FreeBSD e não do compositor).
    - Ajustar propriedades de geometria do frame no Elisp (`frame-resize-pixelwise`, `frame-inhibit-implied-resize`), `size hints` ICCCM/EWMH (incrementos de coluna/linha vs. pixels) e sincronização de repintura do toolkit (GTK3/PGTK ou Lucid).
- [ ] **Blindagem do Diretório Inicial (`default-directory`) no GNU Emacs:**
    - Garantir no ciclo pós-inicialização que o Emacs abra sempre no diretório home (`~`) do usuário, impedindo a captura esporádica de diretórios transitórios de build do Elpaca (ex: `~/.emacs.d/var/lib/elpaca/builds/ob-mermaid`).
- [ ] **Comandos Interativos de Lançamento de Apps Gráficos no Emacs:**
    - Expandir a suíte de comandos nativos do Emacs (seguindo o padrão já existente de `M-x firefox`) para abrir diretamente aplicativos de produtividade e diagnóstico do ecossistema:
        - **Kate** (`M-x kate`)
        - **GIMP** (`M-x gimp`)
        - **Wireshark** (`M-x wireshark`)
        - **KDE Connect** (`M-x kdeconnect` / `kdeconnect-app`)
        - **Thunderbird** (`M-x thunderbird`)
        - **Google Chrome & Chromium** (`M-x chrome` / `M-x chromium` — _Observação técnica: no FreeBSD, o binário do pacote Chromium chama-se `chrome`; o comando deve resolver ambos de forma transparente entre Linux e FreeBSD_).
- [ ] **Autodocumentação Integral no GNU Emacs (Self-Documenting Philosophy):**
    - Auditar e enriquecer progressivamente todos os módulos Elisp (`etc/`, `lib/`, `usr/local/aweshell`, `usr/local/aweww`) para que 100% das funções (`defun`/`defmacro`), variáveis (`defvar`/`defcustom`), faces (`defface`) e keymaps possuam docstrings canônicas introspectáveis via `C-h f`, `C-h v`, `C-h k`, `M-x apropos` e `which-key` (1ª linha concisa $\le 80$ colunas, parâmetros em `MAIÚSCULAS` e hiperlinks `` `simbolo' `` para o buffer `*Help*`).
- [ ] **Ergonomia, Keymaps e Latência em Console Puro (Raw TTY):**
    - **Navegação por Palavra (`Ctrl+Left` / `Ctrl+Right`) no TTY:** Corrigir o mapeamento de teclas de modificação no console puro do FreeBSD (`vt(4)`) e do Linux, onde pressionar `Ctrl+Left` / `Ctrl+Right` emite a mesma sequência bruta das setas normais (`^[[D` / `^[[C`) em vez de sequências modificadas (`^[[1;5D` / `^[[1;5C`), impedindo o avanço/recuo por palavra (`backward-word` / `forward-word`) no Shell e no Emacs TTY (enquanto `Home` e `End` já operam normalmente). Configurar `kbdcontrol` / keymaps de console e fallbacks de input no Shell/Emacs.
    - **Latência de Encerramento do NeoVim no TTY:** Investigar e eliminar o delay de ~1 a 2 segundos ao sair (`:q`) do NeoVim exclusivamente em sessões Raw TTY (verificar timeouts de provider de clipboard tentando buscar display X11/Wayland inexistente, encerramento de daemons LSP/autocommands `VimLeave` ou resquícios de configurações legadas de terminal como `ttyfast`).

---

### 🐚 4. Repositório `Shell` — Camada GNU Coreutils & Reforma de Aliases (`open-*`)

- [ ] **Camada Opcional de GNU Coreutils em Sistemas BSD/Unix (Repositório `Shell`):**
    - Avaliar e definir a arquitetura ideal para ativar o userland GNU (`coreutils`, `gsed`, `gawk`, `ggrep`, `gtar`, `gfind`) de forma opcional no FreeBSD e demais BSDs/macOS sem torná-lo o padrão impositivo e sem quebrar scripts nativos do sistema base ou da árvore de Ports.
    - Comparar trade-offs entre: (1) flag de ambiente opt-in (ex: `SHELL_GNU_USERLAND=1`) que mapeia aliases seguros apenas em sessões interativas (`gls`, `gcat`, `gcp`, `gmv`, `gstat`, `gsed`), (2) injeção condicional do diretório `/usr/local/libexec/gnubin` no `PATH`, ou (3) gerenciamento de symlinks em `~/.local/bin`.
- [ ] **Reforma da Família de Aliases `o*` / `open-*` (Shell & Emacs `aweshell`):**
    - **Remoção de Wrappers Redundantes para Editores TUI:** Remover `open-vim` (`ov`), `open-neovim` / `open-nvim` (`on`) e `open-micro` (`om` — que além de redundante para um app de terminal, disparava `Error: . is a directory and cannot be opened` ao ser chamado sem argumentos). O alias `on` passa a ficar livre no namespace.
    - **Nova Matriz de Aliases de Aplicações e Sessão:**
        - [ ] `ov` $\rightarrow$ **VLC** (substituindo o antigo `open-vim`)
        - [ ] `om` $\rightarrow$ **MPV** (substituindo o antigo `open-micro`)
        - [ ] `os` $\rightarrow$ **Wireshark** (_open-shark_ / sniffer de pacotes)
        - [ ] `of` $\rightarrow$ **Firefox**
        - [ ] `ow` $\rightarrow$ **Web Browser Universal** (ordem de fallback: `<Google Chrome, Brave, Microsoft Edge, Safari, Chromium, Firefox>`, respeitando o binário `chrome` do Chromium no FreeBSD)
        - [ ] `oo` $\rightarrow$ **OnlyOffice**
        - [ ] `ol` $\rightarrow$ **LibreOffice**
        - [ ] `ot` $\rightarrow$ **Terminal / Thunderbird** _(definir se `ot` assumirá o Terminal padrão e `oth`/`omail` assumirá o Thunderbird para evitar colisão)_
        - [ ] `wm` $\rightarrow$ **Window Manager Puro** (`<Sway, Labwc, River, Cage>`)

---

## 💡 Insights & Notas Arquiteturais (Diagnósticos de Referência)

> [!NOTE]
> Registro técnico das causas-raiz identificadas durante a triagem de logs e testes em FreeBSD e Linux para guiar a implementação:

- **Por que `firefox` e `chrome` abrem encaixotados e com terminal ao fundo no `(x/w)gui`:** Quando um script lançador decide se um binário é TUI ou GUI (checando `Terminal=true` no `.desktop` ou dependências de bibliotecas), discrepâncias no nome do `.desktop` — especialmente no FreeBSD, onde o binário do Chromium chama-se `chrome` (`/usr/local/bin/chrome`), mas o arquivo de entrada pode ser `chromium-browser.desktop` — ou wrappers de shell intermediários fazem o lançador cair no _fallback_ de "aplicativo de terminal", executando equivocadamente `foot -e chrome` ou `xterm -e firefox`.
- **Por que `Ctrl+Left` e `Ctrl+Right` emitem `^[[D` / `^[[C` (setas normais) no Raw TTY:** Por herança histórica da emulação VT100/cons25, os mapas de teclado do kernel tanto no FreeBSD (`vt(4)` em `/usr/share/vt/keymaps/`) quanto no Linux (`kbd` / `loadkeys`) não diferenciam a tecla `Left` de `Ctrl+Left` na tabela de scancodes padrão — ambas apontam para a mesma ação `lkey` (`^[[D`). Ao contrário de `Home` e `End` (que possuem slots dedicados na tabela do kernel), o Shell e o Emacs sequer recebem a informação de que o modificador `Ctrl` foi pressionado. A solução definitiva no repositório `Setup` consiste em injetar regras customizadas via `kbdcontrol` (FreeBSD) e `loadkeys` (Linux) mapeando `Ctrl+Left/Right` para as sequências CSI modificadas padrão xterm (`^[[1;5D` e `^[[1;5C`).
- **Por que apenas o GNU Emacs trava ao redimensionar no FreeBSD (KDE):** Por padrão (`frame-resize-pixelwise nil`), o Emacs negocia o tamanho da sua janela com o Window Manager em múltiplos exatos da largura/altura da fonte (colunas $\times$ linhas via `WM_NORMAL_HINTS`). No FreeBSD sob KWin (Wayland/X11) com compositores modernos e escalas fracionárias, o loop de eventos GTK/X11 do Emacs entra em condição de corrida (_resize loop_) tentando arredondar os pixels enviados pelo compositor e redesenhar o buffer a cada frame. Ativar `(setq frame-resize-pixelwise t)` no `early-init.el` costuma eliminar o gargalo imediatamente.
- **Colisão do Alias `r` com Builtin do Zsh (`fc -e -`):** Enquanto no `sh` e no `bash` a letra `r` está livre, no **Zsh** `r` é um comando _builtin_ histórico pré-definido (equivalente a `fc -e -`, que reexecuta imediatamente o último comando do histórico). Criar `alias r='rg'` funciona no Zsh, mas exige cuidado: se em algum subshell ou função os aliases não forem expandidos (ou antes do carregamento do `.zshrc`), digitar `r` repetirá o comando anterior acidentalmente. Para blindar o Zsh, recomenda-se desativar o builtin obsoleto com `disable r` antes de declarar `alias r='rg'`.

---

## 🔮 Para Depois (Backlog Futuro)

- [ ] **Polimento Estético, Dark Mode Unificado e Herança Dinâmica de Temas nos Compositores (`sway`, `labwc`, `river`, `cage`):**
    - **Estética Clean & Dark Mode Out-of-the-Box:** Refinar o visual dos compositores leves para que iniciem com uma identidade visual minimalista, escura (_Dark Mode_) e coesa (bordas finas, cores harmônicas, fontes Terminus/nerdfonts alinhadas e barras/menus limpos).
    - **Detecção e Herança Inteligente de Temas (KDE / GNOME):** Implementar detecção automática das configurações e temas instalados no sistema hospedeiro (ex: extrair esquema de cores/ícones Breeze Dark do KDE Plasma ou Adwaita Dark do GNOME via `gsettings`, `qt5ct`/`qt6ct`, variáveis `GTK_THEME`, `~/.config/gtk-3.0/settings.ini` e `xdg-desktop-portal`), garantindo que qualquer aplicativo GTK, Qt ou Electron aberto dentro do `(x/w)gui`, `wm` ou `ewm` respeite integralmente o tema escuro, cursores e fontes do ambiente principal.
- [ ] **Expansão de Ferramentas CLI Modernas em Rust & Aliases Ultra-Curtos (Single-Char):**
    - **Objetivo:** Substituir e complementar utilitários UNIX tradicionais por alternativas escritas em **Rust** que sejam estritamente modernas, ativas, altamente performáticas e bem mantidas (descartando crates abandonadas/legadas, como o antigo `exa` em favor do `eza`).
    - **Mapeamento de Aliases de 1 Caractere (`l`, `c`, `b`, `g`, `r`, `f`, `d`, etc.) e Candidatos Rust:**
        - **Busca de Texto (`r` / `g`):** `ripgrep` (`rg`) — tratando a desativação do builtin `r` no Zsh (`disable r`) para evitar reexecução acidental de histórico (`fc -e -`).
        - **Listagem e Árvore (`l`):** `eza` (sucessor ativo do `exa`, com ícones, git status e tree).
        - **Visualização e Paginação (`c` / `b`):** `bat` (substituto do `cat`/`less` com syntax highlighting e integração Git).
        - **Busca de Arquivos (`f`):** `fd` (`fd-find`, alternativa ultra-rápida e ergonômica ao `find`).
        - **Navegação Inteligente (`z` / `j`):** `zoxide` (substituto inteligente do `cd`).
        - **Diffs & Git (`d`):** `delta` (`git-delta`, visualização moderna de diffs lado a lado).
        - **Análise de Disco e Processos (Avaliar):** `dust` (substituto visual do `du`), `procs` (substituto moderno do `ps`), `bottom` (`btm`, monitor de sistema TUI) e `sd` (alternativa intuitiva ao `sed`).
- [ ] **Integração de Agentes e LLMs no Emacs via Assinatura (Zero Custo por Token / Sem API Avulsa):**
    - **Objetivo Central:** Integrar ferramentas de IA no Emacs consumindo assinaturas vigentes/planos de consumidor (Claude Pro/Max, Google AI, etc.) sem faturamento por token via API direta (AI Studio / Anthropic Console).
    - **Ferramentas Alvo:** `agy` (Google Antigravity CLI), `claude` (Claude Code), `opencode` / `open-code-interpreter` e `openclaw`.
    - **Métodos Arquiteturais de Integração:**
        1. **Bridge / Proxy HTTP Local (Adapter `gptel` & `avante.nvim`):**
            - Subir micro-daemon local compatível com endpoints OpenAPI/SSE (`http://127.0.0.1:PORT/v1/chat/completions`) que reaproveita a sessão autenticada.
            - Plugar diretamente no `gptel` (`gptel-make-openai`) e no ecossistema modal com zero fricção.
        2. **Runner de Subprocesso Assíncrono / Headless CLI (Elisp Nativo):**
            - Invocar o modo não interativo das ferramentas (`agy -p`, `claude -p`) via pipes UNIX e buffers efêmeros (`make-process` / `async-shell-command`).
            - Aplicar transformações, refatoração de região selecionada (`shell-command-on-region`) e auto-injeção de diffs sem intermediários.
        3. **Sessão TUI Interativa via Terminal Embutido:**
            - Executar as interfaces nativas TUI com suporte total a permissões e contexto via `vterm` ou `eat` em buffers dedicados/splits laterais.

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
