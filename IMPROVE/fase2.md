# ----------------------------------------------------------------

# Plano de Execução: Fase 2 — Shell & Lançadores Gráficos (Wayland & Xorg)

# ----------------------------------------------------------------

### ================================

### 1. OBJETIVO DA FASE

### ================================

Implementar no motor interativo do Shell a suíte simétrica de lançadores gráficos
efêmeros multi-TTY para Wayland (`gui`) e Xorg (`xgui`), e os pontos de entrada
canônicos para o Emacs como Window Manager soberano: o `emacs-window-manager`
(aliases `ewm` e `ew` para Wayland) e o `emacs-x-window-manager` (aliases `xewm`,
`xew`, `exwm` e `exw` para X11/Xenocara), eliminando duplicações de código.

### ================================

### 2. ARQUIVOS ALVO

### ================================

| Arquivo                           | Componente | Ação                                                                                                                                       |
| :-------------------------------- | :--------- | :----------------------------------------------------------------------------------------------------------------------------------------- |
| `Shell/context/desktop/common.sh` | Shell      | Implementar rotinas `_wayland_session_env`, `_freebsd_vt_bounce`, funções `gui`, `xgui`, `emacs-window-manager` e `emacs-x-window-manager` |
| `Shell/docs/ALIASES.md`           | Shell      | Documentar comandos `gui`, `xgui`, `ewm`, `ew`, `xewm`, `xew`, `exwm`, `exw`                                                               |

### ================================

### 3. CONTRATOS TÉCNICOS

### ================================

- **Modularização DRY (Zero Duplicação):**
    - `_wayland_session_env()`: Configura `$XDG_RUNTIME_DIR` (0700), teclado ABNT2 (`delay 200`, `rate 50`), cursor Breeze e escala.
    - `_freebsd_vt_bounce()`: Inspeciona TTY ativo e executa VT bounce via `vidcontrol -s` exclusivamente em consoles locais FreeBSD (`/dev/ttyv*`).
- **Lançadores Efêmeros por TTY (App fecha = Volta ao Prompt limpo):**
    - **`gui` (Wayland):**
        - Se `$# -eq 0`, assume `foot` por padrão.
        - Cascata estrita: `sway` -> `river` -> `labwc` -> `cage`.
        - Auto-exit ao fechar o app e troca livre de TTY (`Ctrl+Alt+F*`).
    - **`xgui` (Xorg):**
        - Se `$# -eq 0`, assume `xterm` / terminal padrão.
        - Inicia sessão X11 efêmera isolada via `xinit "$@" -- :$vt vt$vt` ou script mínimo com auto-exit.
- **Suíte Emacs OS Soberano:**
    - **`emacs-window-manager` (Aliases `ewm`, `ew` — Wayland):**
        - Exporta flag canônica `EMACS_OS_MODE="wayland"`.
        - Sobe o compositor Wayland EWM com aceleração GPU (DMA-BUF / Vulkan).
        - Aplica `_freebsd_vt_bounce` ao sair.
    - **`emacs-x-window-manager` (Aliases `xewm`, `xew`, `exwm`, `exw` — X11):**
        - Exporta flag canônica `EMACS_OS_MODE="x11"`.
        - Sobe o EXWM (XELB Elisp nativo) sobre Xorg/Xenocara via `xinit emacs` com auto-exit.

### ================================

### 4. CRITÉRIOS DE ACEITE

### ================================

- [x] Validação sintática rigorosa com Zsh, Bash e FreeBSD `/bin/sh`.
- [x] Latência do shell mantida em conformidade (< 16ms / 64ms) — 32ms aferido no bench.
- [x] `make test` em `Shell/` aprovado 100%.
- [x] Commit semântico atômico no sub-repositório `Shell`: `feat(desktop): add symmetrical gui/xgui launchers and ewm/xewm commands` (commit `5df320a`).
