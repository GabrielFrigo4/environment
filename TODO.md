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
    - Instalar `busybox`, `seatd`, `sway`, `labwc`, `cage`, `foot` e `wlr-randr`.
    - Habilitar o serviço `seatd` (`sysrc seatd_enable="YES"`) e garantir o usuário no grupo `video`.
- [ ] **Tipografia Terminus Unificada:**
    - **Linux & FreeBSD:** Instalar `terminus-fonts` e `terminus-ttf`.
    - **Linux:** Instalar `terminus-fonts-console`.
- [ ] **Mouse e Teclado no Console Kernel (Raw TTY):**
    - **FreeBSD:** Habilitar `moused_enable="YES"` e `keyrate="fast"` via `sysrc`.
    - **Linux:** Baixar e habilitar o `gpm`.

---

### 🐚 2. Shell — Função `gui` (Cascata `sway > labwc > cage` & Multi-TTY)

- [ ] **Implementar a função POSIX `gui` no Shell:**
    - **Sem argumentos = `foot`:** Se chamada apenas como `gui`, assume `set -- foot` por padrão.
    - **Aparência e Input:** Variáveis do Breeze/KDE, escala `1.25`, layout `br` (`abnt2`) e repeat rate rápido.
    - **Hierarquia com Saída Silenciosa (`sway > labwc > cage`):**
        1. **`sway`:** Config efêmero sem bordas, com troca de TTY funcional (`Ctrl+Alt+F*`) e auto-exit via `exec sh -c '$* ; swaymsg exit'`.
        2. **`labwc`:** Executa via `labwc -C "$XDG_RUNTIME_DIR" -s "$*"`.
        3. **`cage`:** Modo kiosk com troca de TTY liberada via `cage -s -- "$@"`.
    - **Restauração do Console no FreeBSD:** VT bounce via descritor de terminal local (`< "$_current_tty"`) para forçar o kernel a redesenhar a tela imediatamente ao fechar o compositor.

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

### 🔮 3. Emacs (No Window & Geral)

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

---

### 📝 4. Editores no GUI, PTY e TTY (Mouse e Formato de Cursor)

- [ ] **Investigar e Corrigir Comportamento do Mouse no FreeBSD:**
    - **Emacs:** O mouse às vezes funciona no PTY e TTY no FreeBSD e às vezes não (investigar se tem relação com abrir uma instância GUI antes/depois).
    - **Vim / NeoVim:** O mouse funciona sempre no PTY mas nunca no TTY no FreeBSD — enquanto tanto o Micro quanto o Helix funcionam com o mouse no TTY. Descobrir a causa e arrumar no Vim e NeoVim.
- [ ] **Padronizar Cursor em Bloco Colorido por Modo no TTY:**
    - No TTY do FreeBSD não é possível mudar o formato físico do cursor (barra/underline), mas o **Helix** contorna isso mudando a cor do cursor por modo; como no TTY o cursor é um bloco inteiro, o efeito visual ficou excelente.
    - Migrar esse comportamento de mudar a cor do bloco inteiro do cursor para todos os outros editores (Vim, NeoVim e Emacs) no TTY do FreeBSD.
    - Avaliar se no Linux TTY mantemos a alteração de formato ou se padronizamos esse mesmo efeito de bloco colorido.

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
