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

- [ ] **Utilitários Base & Micro-Compositores Wayland (Linux & FreeBSD):**
    - Instalar utilitários base: `busybox`, `seatd`, `foot` e `wlr-randr`.
    - Instalar compositores da cascata principal (Tier 1): `sway` (tiling estático), `river` (tiling dinâmico em Zig controlado via IPC), `labwc` (stacking/floating) e `cage` (kiosk single-app).
    - Avaliar compositores minimalistas extras (Tier 2): `hikari` (nativo do mundo FreeBSD, estilo `cwm`) e `dwl` (estilo `dwm`/suckless). _(Ignorar compositores pesados/inchados como Hyprland, Wayfire e Weston)._
    - Habilitar o serviço `seatd` (`sysrc seatd_enable="YES"`) e garantir o usuário no grupo `video`.
    - **Dependências p/ Emacs OS (`emacs-window-manager` / EWM):** Instalar toolchain Rust (`cargo`/`rustc`), `pkgconf`, `libinput`, `libxkbcommon`, `pixman`, `mesa-libs`/`libgbm` e `hwdata` para compilar o módulo dinâmico do compositor.

- [ ] **Tipografia Terminus Unificada:**
    - **Linux & FreeBSD:** Instalar `terminus-fonts` e `terminus-ttf`.
    - **Linux:** Instalar `terminus-fonts-console`.

- [ ] **Mouse e Teclado no Console Kernel (Raw TTY):**
    - **FreeBSD:** Habilitar `moused_enable="YES"` e `keyrate="fast"` via `sysrc`.
    - **Linux:** Baixar e habilitar o `gpm`.

---

### 🐚 2. Shell — Função `gui` (Cascata `sway > river > labwc > cage` & Multi-TTY)

- [ ] **Implementar a função POSIX `gui` no Shell (Lançador Gráfico Isolado por TTY):**
    - **Filosofia:** Não é um Desktop Environment, mas um wrapper para abrir qualquer aplicação gráfica diretamente de um TTY cru, permitindo alternar para outro TTY (`Ctrl+Alt+F*`), rodar outro `gui <app>` simultaneamente e retornar ao TTY limpo assim que o app fechar.
    - **Sem argumentos = `foot`:** Se chamada apenas como `gui`, assume `set -- foot` por padrão.
    - **Aparência e Input:** Variáveis do Breeze/KDE, escala `1.25`, layout `br` (`abnt2`) e repeat rate rápido (`delay 200`, `rate 50`).
    - **Hierarquia de Inicialização com Saída Silenciosa (`sway > river > labwc > cage`):**
        1. **`sway`:** Prioridade 1. Config efêmero sem bordas, gerencia sub-janelas/modais em tiling, troca de TTY funcional e auto-exit via `exec sh -c '$* ; swaymsg exit'`.
        2. **`river`:** Prioridade 2. Script init POSIX efêmero (`chmod +x`) rodando `riverctl` sem bordas, teclado ABNT2 e auto-exit via `riverctl exit` ao encerrar o processo principal.
        3. **`labwc`:** Prioridade 3. Compositor floating leve, executa via `labwc -C "$XDG_RUNTIME_DIR" -s "$*"`.
        4. **`cage`:** Prioridade 4 (Fallback Kiosk). Executa com troca de TTY liberada via `cage -s -- "$@"`.
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

### 🔮 3. Emacs (No Window, Geral, Comando `ewm`/`ew` & Ideia do "Neo-EWW")

- [ ] **Configurações Básicas no Terminal (`-nw`):**
    - Habilitar o uso do mouse no Emacs No Window (`xterm-mouse-mode`).
    - Habilitar respostas curtas (`use-short-answers t`).
    - Desativar som irritante do Emacs (`ring-bell-function #'ignore`).

- [ ] **Saneamento de Pacotes Externos (Emacs 31+):**
    - Corrigir mensagens de erro/aviso de macro obsoleta (`when-let` -> `when-let*` / `and-let*`) geradas nas compilações do Elpaca:

```text
Wrote /home/gabrielf/cage.sh
.emacs.d/var/lib/elpaca/builds/apheleia/apheleia-formatters.el: Warning: ‘when-let’ is an obsolete macro (as of 31.1); use ‘when-let*’ or ‘and-let*’ instead. [5 times]
.emacs.d/var/lib/elpaca/builds/apheleia/apheleia-rcs.el: Warning: ‘when-let’ is an obsolete macro (as of 31.1); use ‘when-let*’ or ‘and-let*’ instead.
Mark set
```

- [ ] **Implementar o Comando `emacs-window-manager` (Aliases: `ewm` e `ew`):**
    - **Além de `gui emacs`:** O comando `ewm` / `ew` transforma o próprio Emacs no **Compositor Soberano** falando direto com o kernel/DRM/seatd (sem compositor intermediário como Sway/River). E se der qualquer BO, basta trocar de TTY (`Ctrl+Alt+F*`) para consertar no terminal ou subir um KDE de emergência.
    - **Função Shell + Aliases (`ewm` e `ew`):**
        - Preparar `XDG_RUNTIME_DIR`, teclado ABNT2 (`delay 200`, `rate 50`) e flag `EMACS_OS_MODE="1"`.
        - Subir via `emacs --eval "(ewm-start-module)"` e executar o VT bounce do `vidcontrol` ao sair no FreeBSD.
    - **Arquitetura Dual no `init.el` ("Documentar os 2, Ativar 1 por Ambiente"):**
        - **Wayland Nativo (EWM + Rust/Smithay):** Módulo dinâmico em thread separada (interface não trava com Elisp ocupado), janelas externas viram buffers e suporte a `text-input-v3`.
        - **X11 Legado (EXWM Condicional):** Bloco isolado com `:if (eq window-system 'x)` para testes em OpenBSD/Xenocara ou hardware sem DRM moderno.

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

- [ ] **Explorar um "Neo-EWW" (Navegação em Sites Modernos c/ JS no Buffer do Emacs):**
    - **O Problema do `eww` padrão e do `xwidget-webkit`:** O `eww` não roda JS (quebra em 99% dos sites atuais com React/SPA como Facebook/YouTube), e o `xwidget-webkit` roda dentro do processo do Emacs (pesado, instável e incompatível com `W^X` nos BSDs).
    - **Arquitetura Headless CDP (Texto & Botões ultra-rápidos):**
        - Rodar um motor Chromium/Firefox em modo Headless externo (processo separado) conectado ao Emacs via socket local (CDP).
        - O motor executa o HTML5/CSS3/JS real e devolve a **Árvore de Acessibilidade / DOM Semântico** para o Emacs desenhar o buffer com texto puro, campos de input e botões reais (`button.el` / `widget.el`).
        - **Performance para o usuário:** Zero lag para leitura e clique (resposta em $< 20\text{ ms}$ via socket local, pois não há streaming de pixels).
    - **Limitações e Soluções p/ Vídeo (YouTube) dentro do Buffer:**
        - Streaming de imagem inline via Elisp (`Page.startScreencast`) engasga a thread única do Emacs acima de 15 FPS.
        - **Alternativa 1 (Inline em Buffer Terminal via Sixel/TrueColor):** Testar renderização embutida no buffer usando `eat`/`vterm` com `mpv --vo=sixel` ou `mpv --vo=tct` (ou avaliar o projeto `browsh`, que já faz exatamente esse bridge de Firefox Headless para terminal/Emacs).
        - **Alternativa 2 (Controle no Neo-EWW + Vídeo via IPC):** Ler toda a página, comentários e busca do YouTube no buffer do Neo-EWW e controlar o player (`mpv` acelerado por GPU) diretamente pelos atalhos do buffer via socket JSON IPC.

---

### 📝 4. Editores no GUI, PTY e TTY (Mouse, Formato de Cursor e `:terminal`)

- [ ] **Investigar e Corrigir Comportamento do Mouse no FreeBSD:**
    - **Emacs:** O mouse às vezes funciona no PTY e TTY no FreeBSD e às vezes não (investigar se tem relação com abrir uma instância GUI antes/depois).
    - **Vim / NeoVim:** O mouse funciona sempre no PTY mas nunca no TTY no FreeBSD — enquanto tanto o Micro quanto o Helix funcionam com o mouse no TTY. Descobrir a causa e arrumar no Vim e NeoVim.

- [ ] **Padronizar Cursor em Bloco Colorido por Modo no TTY:**
    - No TTY do FreeBSD não é possível mudar o formato físico do cursor (barra/underline), mas o **Helix** contorna isso mudando a cor do cursor por modo; como no TTY o cursor é um bloco inteiro, o efeito visual ficou excelente.
    - Migrar esse comportamento de mudar a cor do bloco inteiro do cursor para todos os outros editores (Vim, NeoVim e Emacs) no TTY do FreeBSD.
    - Avaliar se no Linux TTY mantemos a alteração de formato ou se padronizamos esse mesmo efeito de bloco colorido.

- [ ] **Padronizar Cores e Comportamento do `:terminal` Embutido (Vim, Neovim & Emacs — Base p/ "Neovim OS"):**
    - **Sincronia da Paleta ANSI (16 cores):** Garantir que os emuladores de terminal internos do **Vim** e do **Neovim** usem exatamente os mesmos códigos hexadecimais configurados no `foot` e no TTY:
        - **Neovim:** Definir o array/variáveis `g:terminal_color_0` até `g:terminal_color_15` (ou via Lua `vim.g.terminal_color_*`).
        - **Vim:** Definir a lista equivalente em `g:terminal_ansi_colors` (16 posições hexadecimais), já que o Vim ignora `g:terminal_color_*`.
        - **Emacs (`vterm` / `eat` / `ansi-term`):** Sincronizar o vetor `ansi-color-names-vector` e as faces `vterm-color-*` com a mesma paleta de 16 cores.
    - **Ergonomia de "Neovim OS" no `:terminal`:**
        - Mapear `Esc` ou `C-\ C-n` de forma consistente entre Vim, Neovim e `vterm` do Emacs para sair do modo de inserção do terminal e navegar pelo buffer como texto normal.
        - Ocultar números de linha (`nonumber`, `norelativenumber`) e colunas de sinal (`signcolumn=no`) automaticamente ao abrir buffers `term://` no Vim/Neovim para que o terminal embutido pareça nativo.

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
