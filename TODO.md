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

- [ ] **Ajuste da Barra de Ferramentas (Tool-Bar / Bar-Tools) no EWM:** Investigar e restaurar a exibição e estilização consistente da `tool-bar` dentro do ambiente EWM (`wewm`), alinhando layout e offsets de renderização.
- [ ] **Correção de Diálogo de Arquivo no GUI Emacs / Sway e Diretório Inicial:**
    - Investigar erro disparado no Sway ("there are errors in your config file" em vermelho) ao acionar "open new file" / diálogo gráfico de seleção de arquivo no `wgui`/`xgui emacs`, que bloqueia subsequentes popups de seleção.
    - Blindar o `default-directory` do Emacs no ciclo pós-inicialização para garantir que inicialize sempre no diretório home (`~`) do usuário, evitando captura esporádica de diretórios transitórios de build do Elpaca (ex: `~/.emacs.d/var/lib/elpaca/builds/ob-mermaid`).
- [ ] **Autodocumentação Integral no GNU Emacs (Self-Documenting Philosophy):** Auditar e enriquecer progressivamente todos os módulos Elisp (`etc/`, `lib/`, `usr/local/aweshell`, `usr/local/aweww`) para que 100% das funções (`defun`/`defmacro`), variáveis (`defvar`/`defcustom`), faces (`defface`) e keymaps possuam docstrings canônicas introspectáveis via `C-h f`, `C-h v`, `C-h k`, `M-x apropos` e `which-key` (1ª linha concisa $\le 80$ colunas, parâmetros em `MAIÚSCULAS` e hiperlinks `` `simbolo' `` para o buffer `*Help*`).

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
