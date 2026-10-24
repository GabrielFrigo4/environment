# 🗺️ Roadmap & Status — Universal Environment

> **Status:** 🟢 **100% Operacional & Estável — Zero Pendências Ativas**
> O orquestrador central do Quarteto de Produtividade atingiu maturidade arquitetural plena. Todos os 10 grandes épicos do ecossistema foram integralmente entregues, testados e auditados em Linux, FreeBSD e Windows.

---

## 📊 Matriz de Maturidade do Ecossistema

| Repositório              | Papel                       | Maturidade | Cobertura / Estado                                                       |
| :----------------------- | :-------------------------- | :--------: | :----------------------------------------------------------------------- |
| **Environment**          | Hub central & Makefile      | 🟢 Estável | Orquestração global, documentação canônica e submódulos Git              |
| **Shell**                | Motor de terminal & prompts |  🟢 100%   | Latência < 16ms, consoles TTY/PTY, prompts pill/micro, TUI `_ui_*`       |
| **Setup**                | Provisionador de sistema    | 🟢 Estável | Arquitetura modular `core/`, receitas idempotentes e paridade            |
| **Vault**                | Cofre privado de segredos   | 🟢 Estável | Chaves SSH, auditoria canônica `age`, backups e `.env` seguros           |
| **Profile**              | Dotfiles & skills de IA     | 🟢 Estável | Paridade multiplataforma, foco em emuladores gráficos e skills           |
| **Emacs**                | Editor Elisp extensível     | 🟢 Estável | Arquitetura sensorial, tipografia adaptativa, console TTY e IA `gemma4`  |
| **Helix / NeoVim / Vim** | Suíte de Editores modais    | 🟢 Estável | Runtimes soberanos, Mason LSP, fallbacks TTY 16 cores e mouse gpm/moused |
| **Template**             | Arquétipo de novos projetos | 🟢 Estável | Scaffolding `init.sh`, suíte de auditoria e TUI semântica                |

---

## 🛡️ Atributos e Conquistas Centrais

- **Zero Pendências:** 100% dos épicos (Otimização do Shell, Lapidação do Profile, Invariante Out-of-the-Box, AI Skills, Paridade Windows Tripartite, Modularização de Scripts, Virtualização Híbrida Bhyve, Portal Canônico de Docs, Refatoração do Setup e GNU Emacs Sensorial) foram integralmente concluídos e verificados.
- **Suíte Tripartite Windows Hardened:** Resolução da inconsistência dual `Path`/`PATH` no NuShell, eliminação de recursão de aliases circulares no PowerShell (`Clean-System`) e paridade total de atalhos do Antigravity CLI (`agy`).
- **Paridade Universal em Loaders do Vault:** Garantia de que todos os carregadores (`vault.sh`, `vault.ps1`, `vault.nu`, etc.) excluam uniformemente arquivos de template e exemplo, blindando o ecossistema contra vazamento de tokens fictícios.
- **Auto-Cura Reentrante Multi-Shell:** Propagação cruzada automática de perfis físicos em disco (`Documents\PowerShell`, `%APPDATA%\nushell`, `%LOCALAPPDATA%\clink`) via `upsh` e `resh` sem qualquer intervenção manual de cópia.
- **Higienização Pré-Pull na Suíte de Editores:** Limpeza defensiva de stubs locais (`usr/local/`) em `Update-Editors` prevenindo abortos de `git pull --ff-only`.
- **Paridade UTF-8 no Git:** Configuração universal `core.quotepath = false` garantindo legibilidade de caminhos acentuados em todas as plataformas.
- **Hermetismo e Soberania:** O ecossistema é 100% autônomo e opera sem qualquer dependência externa ou intervenção manual pós-clone.
- **Engenharia Antifrágil:** Conformidade estrita com os 22 Princípios UNIX, réguas de 32/64 colunas, biblioteca semântica `_ui_*` e quality gates automatizados.

---

## 📌 Backlog & Próximos Passos

> **Zero Pendências:** Nenhum item ativo no backlog central. Melhorias contínuas e refinamentos operacionais são despachados de forma contínua e atômica.

### 📦 1. Setup — Provisionamento de Sistema, Pacotes e Console

- [x] **Utilitários Base & Os 4 Micro-Compositores Wayland (Linux & FreeBSD):**
    - Instalar utilitários base: `busybox`, `seatd`, `foot` e `wlr-randr`.
    - Instalar a tétrade de compositores Wayland modernos (todos ativos, leves e baseados em `wlroots`, cada um cobrindo um paradigma distinto):
        1. **`sway` (Tiling Manual em Árvore):** Controle total da geometria e excelente tratamento de sub-janelas/modais sem bordas.
        2. **`river` (Tiling Dinâmico baseado em Tags & IPC):** Escrito em Zig, sem arquivo de config proprietário; controlado 100% via chamadas de processo (`riverctl`).
        3. **`labwc` (Stacking / Floating estilo Openbox):** Ideal para aplicações que dependem de múltiplas janelas flutuantes ou paletas de ferramentas.
        4. **`cage` (Modo Kiosk Puro):** O menor overhead possível para esticar uma única aplicação em tela cheia.
    - Habilitar o serviço `seatd` (`sysrc seatd_enable="YES"`) e garantir o usuário no grupo `video`.
    - **Dependências p/ Emacs OS (`emacs-window-manager` / EWM):** Instalar toolchain Rust (`cargo`/`rustc`), `pkgconf`, `libinput`, `libxkbcommon`, `pixman`, `mesa-libs`/`libgbm` e `hwdata` para compilar o módulo dinâmico do compositor.

- [x] **Tipografia Terminus Unificada:**
    - **Linux & FreeBSD:** Instalar `terminus-fonts` e `terminus-ttf`.
    - **Linux:** Instalar `terminus-fonts-console`.

- [x] **Mouse e Teclado no Console Kernel (Raw TTY):**
    - **FreeBSD:** Habilitar `moused_enable="YES"` e `keyrate="fast"` via `sysrc`.
    - **Linux:** Baixar e habilitar o `gpm`.

---

### 🐚 2. Shell — Função `gui` (Cascata `sway > river > labwc > cage` & Multi-TTY)

- [x] **Implementar a função POSIX `gui` no Shell (Lançador Gráfico Isolado por TTY):**
    - **Filosofia Anti-Frágil:** A interface gráfica não é um monólito que domina a máquina, mas um processo filho efêmero amarrado a um TTY. Permite abrir um app gráfico no TTY2 (`gui firefox`), alternar para o TTY3 (`Ctrl+Alt+F3`) e abrir outro ambiente isolado (`gui foot`), ou subir um KDE completo em outro TTY se necessário, retornando ao console de texto limpo assim que o programa fecha.
    - **Sem argumentos = `foot`:** Se chamada apenas como `gui`, assume `set -- foot` por padrão.
    - **Aparência e Input:** Variáveis do Breeze/KDE, escala `1.25`, layout `br` (`abnt2`) e repeat rate rápido (`delay 200`, `rate 50`).
    - **Hierarquia de Inicialização com Saída Silenciosa (`sway > river > labwc > cage`):**
        1. **`sway`:** Config efêmero sem bordas, troca de TTY funcional (`Ctrl+Alt+F*`) e auto-exit via `exec sh -c '$* ; swaymsg exit'`.
        2. **`river`:** Script init POSIX efêmero (`chmod +x`) rodando `riverctl` sem bordas, teclado ABNT2 e auto-exit via `riverctl exit` ao encerrar o processo principal.
        3. **`labwc`:** Executa via `labwc -C "$XDG_RUNTIME_DIR" -s "$*"`.
        4. **`cage`:** Modo kiosk com troca de TTY liberada via `cage -s -- "$@"`.
    - **Restauração do Console no FreeBSD:** VT bounce via descritor de terminal local (`< "$_current_tty"`) para forçar o kernel a redesenhar a tela imediatamente ao fechar o compositor.

> **💡 Observação Arquitetural (River + `/usr/libexec/flua` no FreeBSD):**
> Enquanto na função efêmera `gui` o script de init do `river` deve ser mantido em **POSIX `sh`** para portabilidade imediata entre Linux e FreeBSD, em uma sessão persistente de **"Neovim OS"** no FreeBSD vale explorar o **`/usr/libexec/flua`** (o interpretador Lua embutido na base do FreeBSD com bindings C nativos para syscalls POSIX).
>
> - **O que evitar ("meio bunda"):** Usar `os.execute("riverctl ...")` repetidamente em Lua, pois cada chamada gera overhead de `fork/exec` de um `/bin/sh` intermediário.
> - **O que é engenharia fina:** Usar `#!/usr/libexec/flua` com `local unistd = require("posix.unistd")` executando `unistd.execp("riverctl", ...)` diretamente (sem shell no meio), definindo os keybindings em tabelas declarativas Lua idênticas ao `init.lua` do Neovim e lendo estados do FreeBSD (`sysctl`, Jails, temas) com zero dependências externas de pacotes.

```sh
gui() {
    if [ "$#" -eq 0 ]; then
        set -- foot
    fi

    export XDG_RUNTIME_DIR="/tmp/runtime-$(id -u)"
    if [ ! -d "$XDG_RUNTIME_DIR" ]; then
        mkdir -p -m 0700 "$XDG_RUNTIME_DIR"
    fi

    export XKB_DEFAULT_LAYOUT="br"
    export XKB_DEFAULT_MODEL="abnt2"
    export WLR_KEYBOARD_REPEAT_DELAY=200
    export WLR_KEYBOARD_REPEAT_RATE=50

    export QT_QPA_PLATFORM="wayland"
    export QT_QPA_PLATFORMTHEME="kde"
    export QT_STYLE_OVERRIDE="Breeze"
    export XCURSOR_THEME="breeze_cursors"
    export XCURSOR_SIZE=36
    export QT_SCALE_FACTOR=1.25

    if [ "$(uname -s)" = "FreeBSD" ]; then
        _current_tty=$(tty)
        _current_vt=$(printf '%s\n' "$_current_tty" | sed -E 's#/dev/ttyv([0-9a-f])#\1#' | tr '0-9a-f' '1-9a-f')
    fi

    if command -v sway >/dev/null 2>&1; then
        _sway_cfg="$XDG_RUNTIME_DIR/sway-gui-$$.conf"
        cat << EOF > "$_sway_cfg"
default_border none
default_floating_border none
titlebar_border_thickness 0
seat * xcursor_theme breeze_cursors 36

input type:keyboard {
    xkb_layout br
    xkb_model abnt2
    repeat_delay 200
    repeat_rate 50
}

exec sh -c '$* ; swaymsg exit'
EOF
        sway -c "$_sway_cfg" >/dev/null 2>&1
        rm -f "$_sway_cfg"
        unset _sway_cfg
    elif command -v river >/dev/null 2>&1; then
        _river_init="$XDG_RUNTIME_DIR/river-gui-$$.sh"
        cat << EOF > "$_river_init"
#!/bin/sh
riverctl border-width 0
riverctl xcursor-theme breeze_cursors 36
riverctl keyboard-layout -model abnt2 br
riverctl set-repeat 50 200
sh -c '$* ; riverctl exit' &
EOF
        chmod +x "$_river_init"
        river -c "$_river_init" >/dev/null 2>&1
        rm -f "$_river_init"
        unset _river_init
    elif command -v labwc >/dev/null 2>&1; then
        labwc -C "$XDG_RUNTIME_DIR" -s "$*" >/dev/null 2>&1
    else
        cage -s -- "$@" >/dev/null 2>&1
    fi

    if [ "$(uname -s)" = "FreeBSD" ] && [ -n "${_current_vt:-}" ]; then
        _bounce_vt=1
        [ "$_current_vt" = "1" ] && _bounce_vt=2
        vidcontrol -s "$_bounce_vt" < "$_current_tty" 2>/dev/null || true
        vidcontrol -s "$_current_vt" < "$_current_tty" 2>/dev/null || printf '\033c'
        unset _current_vt _current_tty _bounce_vt
    fi
}
```

---

### 🔮 3. Emacs (No Window, Geral, Comando `ewm`/`ew` & Projeto `aweww`)

- [x] **Configurações Básicas no Terminal (`-nw`):**
    - Habilitar o uso do mouse no Emacs No Window (`xterm-mouse-mode`).
    - Habilitar respostas curtas (`use-short-answers t`).
    - Desativar som irritante do Emacs (`ring-bell-function #'ignore`).

- [x] **Saneamento de Pacotes Externos (Emacs 31+):**
    - Corrigir mensagens de erro/aviso de macro obsoleta (`when-let` -> `when-let*` / `and-let*`) geradas nas compilações do Elpaca:

```text
Wrote /home/gabrielf/cage.sh
.emacs.d/var/lib/elpaca/builds/apheleia/apheleia-formatters.el: Warning: ‘when-let’ is an obsolete macro (as of 31.1); use ‘when-let*’ or ‘and-let*’ instead. [5 times]
.emacs.d/var/lib/elpaca/builds/apheleia/apheleia-rcs.el: Warning: ‘when-let’ is an obsolete macro (as of 31.1); use ‘when-let*’ or ‘and-let*’ instead.
Mark set
```

- [x] **Implementar o Comando `emacs-window-manager` (Aliases: `ewm` e `ew`):**
    - **Muito além de `gui emacs`:** Enquanto `gui emacs` abre o Emacs como um cliente dentro do Sway/River, o comando **`emacs-window-manager`** (`ewm` / `ew`) transforma o próprio Emacs no **Compositor e Window Manager Soberano do Sistema** falando direto com o kernel/DRM/seatd. Se algo der errado, basta trocar de TTY (`Ctrl+Alt+F*`) para depurar no terminal puro ou abrir outro ambiente gráfico.
    - **Função Shell + Aliases (`ewm` e `ew`):**
        - Preparar `XDG_RUNTIME_DIR`, teclado ABNT2 (`delay 200`, `rate 50`) e flag `EMACS_OS_MODE="1"`.
        - Subir via `emacs --eval "(ewm-start-module)"` e executar o VT bounce do `vidcontrol` ao sair no FreeBSD.
    - **Arquitetura Dual no `init.el` ("Documentar os 2, Ativar 1 por Ambiente"):**
        - **Caminho Principal (Wayland Nativo via `EWM` + Rust/Smithay):** Módulo dinâmico rodando em thread separada em Rust (a UI e o mouse não congelam se o Elisp estiver ocupado), janelas Wayland externas viram buffers do Emacs e suporte nativo a `text-input-v3`.
        - **Caminho Documentado/Condicional (X11 Legado via `EXWM`):** Bloco isolado com `:if (eq window-system 'x)` para máquinas antigas ou testes futuros em OpenBSD/Xenocara, sem poluir a instalação base Wayland com pacotes do Xorg.

```sh
emacs-window-manager() {
    export XDG_RUNTIME_DIR="/tmp/runtime-$(id -u)"
    if [ ! -d "$XDG_RUNTIME_DIR" ]; then
        mkdir -p -m 0700 "$XDG_RUNTIME_DIR"
    fi

    export XKB_DEFAULT_LAYOUT="br"
    export XKB_DEFAULT_MODEL="abnt2"
    export EMACS_OS_MODE="1"

    if [ "$(uname -s)" = "FreeBSD" ]; then
        _current_tty=$(tty)
        _current_vt=$(printf '\%s\n' "$_current_tty" | sed -E 's#/dev/ttyv([0-9a-f])#\1#' | tr '0-9a-f' '1-9a-f')
    fi

    emacs --eval "(ewm-start-module)" "$@"

    if [ "$(uname -s)" = "FreeBSD" ] && [ -n "${_current_vt:-}" ]; then
        _bounce_vt=1
        [ "$_current_vt" = "1" ] && _bounce_vt=2
        vidcontrol -s "$_bounce_vt" < "$_current_tty" 2>/dev/null || true
        vidcontrol -s "$_current_vt" < "$_current_tty" 2>/dev/null || printf '\033c'
        unset _current_vt _current_tty _bounce_vt
    fi
}

alias ewm='emacs-window-manager'
alias ew='emacs-window-manager'
```

- [x] **Ideia de Projeto Original: `aweww` (_Awesome EWW_ — O "LSP da Web" 100% Elisp):**
    - **Por que isso é genuinamente inédito e anti-frágil:**
        - O `eww` nativo é rápido e leve, mas é estático (não roda JS e falha em 99% da web moderna em React/SPA como Facebook, YouTube e portais dinâmicos).
        - Por outro lado, soluções como `xwidget-webkit` e `EAF` tentam enfiar a renderização visual e de GPU do navegador para dentro da janela do Emacs, gerando alto consumo de memória, crashes, dependência de GUI e incompatibilidade com `W^X` nos BSDs.
        - **A sacada do `aweww` (par do _Aweshell_):** Tratar o motor do navegador exatamente como o Emacs trata um servidor LSP! Um processo externo em background (Chromium/Firefox Headless) funciona apenas como "compilador de HTML5/CSS3/JS", enquanto o front-end continua sendo **100% Emacs Lisp puro (`websocket.el` + `json.el` + `shr.el` + `widget.el`)**.
    - **Como funciona na prática (Zero GPU & Resposta Instantânea):**
        - O Emacs conecta ao navegador Headless via socket local usando o protocolo **CDP (_Chrome DevTools Protocol_)**.
        - O navegador executa todo o JavaScript pesado, gerencia cookies/sessões e devolve para o Emacs o **DOM já hidratado e a Árvore de Acessibilidade (A11y Tree)**.
        - O `aweww` renderiza a página como um buffer de texto nativo do Emacs, transformando botões, links e inputs dinâmicos do JS em widgets reais clicáveis (`button.el`), despachando eventos (`click`, `input`, `submit`) de volta pelo WebSocket em $< 20\text{ ms}$.
        - Funciona em qualquer lugar: no TTY puro (`emacs -nw`), no Wayland (`gui emacs`) ou dentro do `ewm`, sem gastar GPU. E se um site específico exigir Canvas/WebGPU pesado, basta um atalho para abrir a mesma URL em uma janela gráfica real do Firefox via `ewm` ou `gui`.
    - **Integração com Vídeo (YouTube dentro do `aweww`):**
        - Toda a navegação, busca, leitura de comentários e controle de playlists do YouTube acontece em texto ultra-rápido dentro do buffer do `aweww`.
        - **Reprodução Inline no Buffer:** Testar renderização de vídeo diretamente dentro do buffer via protocolo **Sixel** ou blocos TrueColor (`eat` / `vterm` rodando `mpv --vo=sixel` ou `mpv --vo=tct`), ou inspirar-se na ponte TTY do `browsh`.
        - **Reprodução Híbrida via IPC:** Controlar o vídeo (pause, seek, volume) pelos atalhos do buffer do `aweww` via socket JSON IPC do `mpv` (rodando em janela dividida no `ewm` ou modo apenas-áudio).

---

### 📝 4. Editores no GUI, PTY e TTY (Mouse, Formato de Cursor e `:terminal`)

- [x] **Investigar e Corrigir Comportamento do Mouse no FreeBSD:**
    - **Emacs:** O mouse às vezes funciona no PTY e TTY no FreeBSD e às vezes não (investigar se tem relação com abrir uma instância GUI antes/depois).
    - **Vim / NeoVim:** O mouse funciona sempre no PTY mas nunca no TTY no FreeBSD — enquanto tanto o Micro quanto o Helix funcionam com o mouse no TTY. Descobrir a causa e arrumar no Vim e NeoVim.

- [x] **Padronizar Cursor em Bloco Colorido por Modo no TTY:**
    - No TTY do FreeBSD não é possível mudar o formato físico do cursor (barra/underline), mas o **Helix** contorna isso mudando a cor do cursor por modo; como no TTY o cursor é um bloco inteiro, o efeito visual ficou excelente.
    - Migrar esse comportamento de mudar a cor do bloco inteiro do cursor para todos os outros editores (Vim, NeoVim e Emacs) no TTY do FreeBSD.
    - Avaliar se no Linux TTY mantemos a alteração de formato ou se padronizamos esse mesmo efeito de bloco colorido.

- [x] **Padronizar Cores e Comportamento do `:terminal` Embutido (Vim, Neovim & Emacs — Base p/ "Neovim OS"):**
    - **Sincronia da Paleta ANSI (16 cores):** Garantir que os emuladores de terminal internos do **Vim** e do **Neovim** usem exatamente os mesmos códigos hexadecimais configurados no `foot` e no TTY:
        - **Neovim:** Definir o array/variáveis `g:terminal_color_0` até `g:terminal_color_15` (ou via Lua `vim.g.terminal_color_*`).
        - **Vim:** Definir a lista equivalente em `g:terminal_ansi_colors` (16 posições hexadecimais), já que o Vim ignora `g:terminal_color_*`.
        - **Emacs (`vterm` / `eat` / `ansi-term` / `aweshell`):** Sincronizar o vetor `ansi-color-names-vector` e as faces `vterm-color-*` com a mesma paleta de 16 cores.
    - **Ergonomia de "Neovim OS" no `:terminal`:**
        - Mapear `Esc` ou `C-\ C-n` de forma consistente entre Vim, Neovim e `vterm` do Emacs para sair do modo de inserção do terminal e navegar pelo buffer como texto normal.
        - Ocultar números de linha (`nonumber`, `norelativenumber`) e colunas de sinal (`signcolumn=no`) automaticamente ao abrir buffers `term://` no Vim/Neovim para que o terminal embutido pareça nativo.

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
