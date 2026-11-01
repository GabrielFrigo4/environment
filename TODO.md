# 🗺️ Roadmap & Status — Universal Environment

> **Status:** 🟢 **100% Operacional & Estável — Zero Pendências Ativas**
> O orquestrador central do Quarteto de Produtividade atingiu maturidade arquitetural plena. Todos os 10 grandes épicos do ecossistema e as rodadas finais de polimento gráfico, suítes modulares de escritório e dimensionamento dinâmico de memória foram integralmente entregues, testados e auditados em Linux, FreeBSD e Windows.

---

## 📊 Matriz de Maturidade do Ecossistema

| Repositório              | Papel                       | Maturidade | Cobertura / Estado                                                                                                                                                                                                                                                                                                                                                                                |
| :----------------------- | :-------------------------- | :--------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Environment**          | Hub central & Makefile      |  🟢 100%   | Orquestração global, quality gates unificados (`make ci`), documentos canônicos, suíte de editores e compositores                                                                                                                                                                                                                                                                                 |
| **Shell**                | Motor de terminal & prompts |  🟢 100%   | Latência < 16ms, `wwm-bar` GTK3 (botões pill GTK4/Qt6, workspaces `+`/`−`, isolamento `swaymsg exec`, `Close` seguro `[con_id=...] kill`), `xgui-tabbar` 26px sem sobreposição (`#2b2b30`/`#1e1e22`, `10pt Bold`), menu dinâmico de 8 categorias no `xwm` (sem `&`), despachante `o`/`open`, pipeline 11-DE/10-compositor, sincronização X11/Wayland de ícones e LibreOffice VCL gtk3, `userland` |
| **Setup**                | Provisionador de sistema    |  🟢 100%   | Arquitetura modular `core/`, provisão de `djvulibre`/`poppler-utils`/`poppler-glib`/`autoconf`/`automake`/`png` para `pdf-tools` (`epdfinfo`), suíte LibreOffice tema escuro GTK3 com lançador genérico (`NoDisplay=false`), `emacs.desktop` unificado, cálculo 16 partes ARC/VM e dicionários Hunspell                                                                                           |
| **Vault**                | Cofre privado de segredos   |  🟢 100%   | Chaves SSH, auditoria canônica `age`, backups e `.env` seguros                                                                                                                                                                                                                                                                                                                                    |
| **Profile**              | Dotfiles & skills de IA     |  🟢 100%   | Paridade multiplataforma, temas escuros Adwaita/Breeze Dark, ciclo unificado de cursor 1200ms em GTK3/4 e XTerm, tipografia determinística e skills de IA                                                                                                                                                                                                                                         |
| **Emacs**                | Editor Elisp extensível     |  🟢 100%   | Suíte Soberana de Leitores (`pdf-tools` com servidor C `epdfinfo` nativo, cores naturais nítidas, toggle dark mode `i`/`m`, auto `fit-page`, cursor oculto, atalhos unificados, `doc-view-mode`, `nov-mode`), substitutos nativos de apps (`sqlite-mode`, `arc-mode`, `proced`, `ediff`, `calc`, `hex`), cursor 1200ms, estabilidade global de cursor com `track-mouse nil` e aweww Dual-Engine   |
| **Helix / NeoVim / Vim** | Suíte de Editores modais    |  🟢 100%   | Runtimes soberanos, ciclo unificado de cursor 1200ms (`blinkwait600-blinkoff600-blinkon600`), Mason LSP, mouse SGR 1006 no FreeBSD `vt(4)` e cursores em bloco no TTY                                                                                                                                                                                                                             |
| **Template**             | Arquétipo de novos projetos |  🟢 100%   | Scaffolding `init.sh`, suíte de auditoria e TUI semântica                                                                                                                                                                                                                                                                                                                                         |

---

## 🛡️ Atributos e Conquistas Centrais

- **Zero Pendências:** 100% dos épicos (Otimização do Shell, Lapidação do Profile, Invariante Out-of-the-Box, AI Skills, Paridade Windows Tripartite, Modularização de Scripts, Virtualização Híbrida Bhyve, Portal Canônico de Docs, Refatoração do Setup e GNU Emacs Sensorial) foram integralmente concluídos e verificados.
- **Suíte LibreOffice Completa e Tema Escuro GTK3 (`office.sh`):** Provisão declarativa de todos os 6 aplicativos oficiais (`Writer`, `Calc`, `Impress`, `Draw`, `Math`, `Base`) juntamente com `libreoffice-gtk3` e `libreoffice-gtk4`, habilitando o lançador genérico oficial (`libreoffice-startcenter.desktop` com `NoDisplay=false`). Injeção de variáveis de tema escuro nos `.desktop` locais (`SAL_USE_VCLPLUGIN=gtk3`, `GTK_THEME=adw-gtk3-dark`, `GTK_APPLICATION_PREFER_DARK_THEME=1`), persistência via `environment.d` e overrides para Flatpak.
- **Padronização de Editores e Lançador Único do Emacs (`editors.sh`):** Consolidação do lançador `emacs.desktop` apontando para `emacsclient --create-frame --alternate-editor="" %F` com tema escuro GTK3 forçado, ocultando lançadores secundários redundantes (`emacsclient.desktop`, `emacs-mail.desktop`, `emacsclient-mail.desktop`) via `NoDisplay=true`.
- **Dimensionamento Dinâmico de Memória Proporcional 16 Partes:** Cálculo automático baseado na memória física real (`hw.realmem || hw.physmem`) em `zfs-arc.sh` e `bhyve.sh`: alocação de `1/16` para máquinas virtuais (mínimo 1 GB, teto 2 GB), `4/16` para o ZFS ARC (mínimo 1 GB, teto 4 GB) e preservação de `11/16` para o host gráfico e subsistema DRM.
- **Dicionários Bilíngues e Fontes de Alta Densidade no FreeBSD:** Instalação oficial dos dicionários Hunspell em inglês e português do Brasil (`hunspell`, `en-hunspell`, `pt_BR-hunspell`) e tipografia de alta densidade (`jetbrains-mono`, `nerd-fonts`).
- **Despachante Universal de Display Server (`_dispatch_display_server`):** Arquitetura desacoplada onde comandos universais (`window-manager`, `graphical-launcher`, `emacs-window-manager`) despacham transparentemente para variantes `-wayland` ou `-x11`, com autocompletion semântico unificado e aliases ergonômicos (`wm`, `win`, `wwm`, `way`, `xwm`, `xorg`, `x11`, `gui`, `wgui`, `xgui`, `ewm`, `wewm`, `xewm`).
- **Gerenciadores de Janela Puros (`wwm` e `xwm`):** `wwm` opera sobre compositores Wayland com barra superior interativa GTK3 (`wwm-bar`) com botões em formato pílula GTK4/Qt6 sem colchetes (`Web Browser`, `Terminal`, `Files`, `Emacs`, `Menu`, `Close`, `Exit`), isolamento de processos despachados via `swaymsg exec`, botão `Close` seguro e não-suicida (`[con_id=...] kill`), gerenciamento dinâmico de workspaces com criação sob demanda (`+`) e destruição com migração de contêineres (`−`), e fallback contínuo para `swaybar` JSON. `xwm` opera sobre Openbox com suporte completo a redimensionamento em 8 direções (bordas, cantos, grips) e `Alt+RightClick` para janelas SSD (Terminal, Emacs, etc.), além de menu de contexto categorizado dinamicamente em 8 grupos canônicos sem `&` em rótulos (`Editors`, `Development`, `Internet`, `Office`, `Graphics`, `Media Player`, `Tools`, `System`) a partir dos arquivos `.desktop`.
- **Quiosques Efêmeros com Abas Dinâmicas (`wgui` e `xgui`):** `wgui` integra o daemon reativo `wgui-tabwatch` para auto-ocultar abas em tela cheia com 1 janela e comutar para abas no topo quando há $\ge 2$ janelas. `xgui` opera sobre Openbox com barra dinâmica de abas superior em Python 3 + GTK3 + X11 (`xgui-tabbar`) de 26px com reserva estrita de espaço (`_NET_WM_STRUT_PARTIAL`) que surge apenas sob $\ge 2$ janelas normais, com 100% de paridade estética, dimensional (26px) e tipográfica com `wgui` (Sway `titlebar_padding 10 4` em `10pt Bold`) sem sobreposição com janelas maximizadas.
- **Despachante Universal de Abertura Inteligente (`o` / `open`):** Roteamento inteligente em `Shell/context/desktop/common.sh` abrindo documentos estruturados (PDF, EPUB, DjVu, SQLite, compactados, código) diretamente nos buffers soberanos do Emacs (`emacsclient`), com fallback transparente para o inicializador do sistema operacional (`open`, `cygstart`, `xdg-open` ou `gio open`) para URLs web e formatos proprietários pesados.
- **Suíte Soberana de Leitores de Documentos & Substitutos Nativos no Emacs:** Visualização primária de alto desempenho para PDF via `pdf-tools` (servidor nativo `epdfinfo` sobre Poppler-GLib, cores naturais nítidas por padrão, Midnight mode sob demanda via `i` ou `m`, auto-fit `fit-page` na abertura, cursor oculto `cursor-type nil` e atalhos unificados da comunidade `j`/`k`, `n`/`p`/`SPC`, `+`/`=`/`-`/`0`, `w`/`W`, `h`/`H`, `f`/`P`, `r`/`R`, `o`/`t`, `g`/`G`), retaguarda contínua a 192 DPI para PDF e DjVu (`doc-view-mode` com MuPDF, Poppler e `graphics/djvulibre` acelerado via `ddjvu`, com inversão instantânea para modo escuro `i`), e-books EPUB com reflow dinâmico (`nov-mode`), bancos de dados relacionais (`sqlite-mode` via `sql`), visualizador de compactados (`arc-mode`/`tar-mode`), monitor de processos (`proced` via `procs`/`htop`), comparador visual (`ediff`), calculadora simbólica (`calc`), editor hexadecimal (`hexl-mode` via `hex`) e edição de pastas em lote (`dired` + `wdired`).
- **Ciclo Unificado de Piscar de Cursor (1200ms):** Padronização estrita de 1200ms (`600ms` aceso, `600ms` apagado) sincronizada em todo o ecossistema: GNU Emacs (`blink-cursor-interval 0.6`, `blink-cursor-delay 0.6`, `blink-cursor-blinks 0`), NeoVim e Vim (`blinkwait600-blinkoff600-blinkon600`), GTK3 e GTK4 (`gtk-cursor-blink-time=1200`) e XTerm (`*cursorBlink: always`).
- **Pipeline Universal de Detecção de 11 DEs & 10 Compositores no `Shell`:** Identificação precisa da cascata de ambientes de desktop (`KDE > GNOME > MATE > Cinnamon > XFCE > LXQt > LXDE > Budgie > Pantheon > Deepin > COSMIC`) e compositores Wayland/X11 (`sway`, `hyprland`, `river`, `labwc`, `cage`, `niri`, `wayfire`, `dwl`, `openbox`, `cwm`), harmonizando dinamicamente temas GTK, estilos Qt, temas de cursor (`XCURSOR_THEME`, `XCURSOR_SIZE=24`) e fontes determinísticas.
- **Sessões Emacs OS Otimizadas (`ewm` e `exwm`):** `ewm` Wayland opera com `tool-bar` desabilitada por padrão (`tool-bar-lines 0`) para visual limpo. `exwm` X11 adota simulação contextual de teclas (`emacs/wm-gui-simulation-keys` vs `emacs/wm-terminal-simulation-keys`) baseada na classe da janela.
- **Comutação de Userland & Hypervisor NetBSD (`userland` e `nb`):** Comandos ergonômicos para chaveamento de utilitários de sistema (`userland gnu`, `userland bsd`, `userland default`) e gerenciamento do ciclo de vida da VM NetBSD (`nb -s`, `nb`, `nb -c`).
- **Aweww — "LSP da Web" & MPV IPC:** Hidratação assíncrona de páginas web dinâmicas via motor headless Dual-Engine (Chromium-first com `--dump-dom` por SO, fallback nativo EWW), pesquisa sem captcha, perfil efêmero temporário (`aweww-profile/`) e reprodução multimídia assíncrona com sentinelas defensivas prevenindo processos zumbis.
- **Paridade de Mouse e Cursor em Raw TTY:** Protocolo SGR 1006 no console FreeBSD para Vim e NeoVim, cursor colorido em bloco por modo no TTY e `:terminal` embutido sincronizado com 16 cores.
- **Suíte Tripartite Windows Hardened:** Resolução da inconsistência dual `Path`/`PATH` no NuShell, eliminação de recursão de aliases circulares no PowerShell (`Clean-System`) e paridade total de atalhos do Antigravity CLI (`agy`).
- **Hermetismo e Soberania:** O ecossistema é 100% autônomo e opera sem qualquer dependência externa ou intervenção manual pós-clone.

---

## 📌 Backlog & Histórico de Entregas

### 🔥 0. Blindagem de Kernel, GPU (`i915kms` Alder Lake) & ZFS contra Congelamentos Gráficos (FreeBSD 15.1)

- [x] **Correção Definitiva da OID do LinuxKPI e Desativação do GuC Submission/RC (`Setup` / `/boot/loader.conf`):**
    - [x] **Prefixo `compat.linuxkpi.` aplicado no `/boot/loader.conf` do host:** Flags `i915_enable_psr="0"`, `i915_enable_psr2_sel_fetch="0"`, `i915_enable_fbc="0"` e `i915_enable_dc="0"` configuradas com prefixo canônico.
    - [x] **Adição de `compat.linuxkpi.i915_enable_guc="2"` no `/boot/loader.conf` e receitas do `Setup`:** Ativação exclusiva de HuC firmware sem engasgos de GuC submission/RC.
- [x] **Mitigação de Pressão de Memória ZFS ARC vs. Alocador DRM `LinuxKPI` (`Setup` / `/boot/loader.conf`):**
    - [x] **Redução do Teto do ZFS ARC para 4 GB:** Aplicado proporcionalmente em `zfs-arc.sh` com persistência em `/boot/loader.conf` e `/etc/sysctl.conf`.
    - [x] **Expurgo de entradas legadas `vfs.zfs.arc_max`:** Limpeza executada nas receitas do Setup e piso mínimo `vfs.zfs.arc.min="1073741824"` definido.
- [x] **Desativação de Autostart da VM Bhyve no Boot e Cache do KDE no ZFS (`Shell` & `Setup`):**
    - [x] **Economia de 2 GB de RAM Física (`vm-bhyve`):** Autostart desativado via `sysrc vm_list=""`, operando com ciclo de vida sob demanda (`lx -s`, `lx -c`).
    - [x] **Correção do Cache KDE no ZFS:** Configuração de `KDEVARTMP="/tmp"` em `/usr/local/etc/xdg/plasma-workspace/env/kdevartmp.sh`.
    - [x] **Isolamento de Redes no Devd:** Prevenção de loops de erro do driver Wi-Fi quando a interface Ethernet cabeada está ativa.
- [x] **Aceleração de Hardware VA-API para Intel Gen 12 (`Setup`):**
    - [x] Instalação automatizada de `multimedia/libva-intel-media-driver` e `multimedia/libva-utils` no FreeBSD e Linux.
- [x] **Tuning de File Descriptors (`maxfiles`), IPC Shared Memory e Inotify/Kqueue (`Setup` / `/etc/sysctl.conf`):**
    - [x] Parâmetros de escalabilidade aplicados: `kern.maxfiles=1048576`, `kern.maxfilesperproc=524288`, `kern.ipc.shmmax=2147483648`, `kern.ipc.shmall=524288`.
- [x] **Desativação Total de File Watchers (`kqueue`) e Indexadores de Background (`Profile` & `Setup`):**
    - [x] Neutralização de watchers no VS Code e desativação do indexador `baloo` no KDE Plasma (`balooctl6 disable && balooctl6 purge`).

---

### 🔴 1. Correções de Sessão Gráfica, EWM e EXWM

- [x] **Estabilização Pós-Teste no Host FreeBSD (`wewm`, `xewm` e Higiene de TTY):**
    - [x] Detecção de GPU/Output corrigida no `drm-rs` e keymap XKB estabilizado sem segfaults.
    - [x] Frame gráfico PGTK mapeado e inicializado com sucesso no `wewm`.
    - [x] Limpeza de sequências OSC 112 no encerramento de sessões TTY.
- [x] **EWM Frame Limpo sem Tool-Bar:**
    - [x] Configuração padrão `tool-bar-lines 0` em frames gráficos e TTY, preservando espaço útil.
- [x] **Estabilização do Ciclo de Vida X11 / EXWM (`xewm` / `xinit` no FreeBSD 15.1):**
    - [x] Reexecução transparente via `dbus-run-session` e `ck-launch-session` sem flags inválidas.
    - [x] Simulação contextual de teclas (`emacs/wm-gui-simulation-keys` vs `emacs/wm-terminal-simulation-keys`) configurada por classe de janela.

---

### 🖥️ 2. Compositores Wayland/X11, Lançadores `(x/w)gui` e Despachante `wm`

- [x] **Classificação Determinística de Binários no `(x/w)gui`:**
    - [x] Whitelist de aplicações GUI (`firefox`, `chrome`, `chromium`, `code`, `emacs`, `libreoffice`) impedindo abertura acidental dentro de emuladores de terminal.
    - [x] Resolução de nomes multiplataforma (suporte ao binário `chrome` do pacote Chromium no FreeBSD).
- [x] **Gerenciadores de Janela Puros (`wwm` e `xwm`):**
    - [x] `wwm` com barra interativa GTK3 (`wwm-bar`) com botões em formato pílula GTK4/Qt6 sem colchetes (`Web Browser`, `Terminal`, `Files`, `Emacs`, `Menu`, `Close`, `Exit`), isolamento de processos via `swaymsg exec`, botão `Close` seguro (`[con_id=...] kill`), gerenciamento dinâmico de workspaces com botões de criação (`+`) e destruição (`−`), e fallback para `swaybar` JSON.
    - [x] `xwm` com Openbox, suporte completo a redimensionamento em 8 direções e `Alt+RightClick` para janelas SSD (Terminal, Emacs, etc.), e menu dinâmico de 8 categorias indexadas via arquivos `.desktop` sem `&` (`Editors`, `Development`, `Internet`, `Office`, `Graphics`, `Media Player`, `Tools`, `System`).
- [x] **Quiosques Efêmeros com Abas Dinâmicas (`wgui` e `xgui`):**
    - [x] `wgui` com daemon reativo auto-ocultando abas com 1 janela e ativando modo tabbed com $\ge 2$ janelas.
    - [x] `xgui` com barra superior dinâmica em Python 3 + GTK3 + X11 (`xgui-tabbar` dock de 26px sem sobreposição) ativada apenas sob $\ge 2$ janelas normais, com 100% de paridade estética, dimensional (26px) e tipográfica com `wgui` (Sway `titlebar_padding 10 4` em `10pt Bold`).
- [x] **Pipeline Universal de 11 DEs & 10 Compositores (`Shell`):**
    - [x] Detecção em cascata (`KDE > GNOME > MATE > Cinnamon > XFCE > LXQt > LXDE > Budgie > Pantheon > Deepin > COSMIC`) e compositores independentes.
    - [x] Unificação estética automática de GTK, Qt, fontes e temas de cursor (`XCURSOR_THEME`, `XCURSOR_SIZE=24`).

---

### 🐃 3. GNU Emacs, Editores Modais e Ergonomia em Raw TTY

- [x] **Suíte Soberana de Leitores de Documentos & Despachante `o` / `open`:**
    - [x] Leitor nativo acelerado para PDF via `pdf-tools` (servidor `epdfinfo` nativo, cores naturais nítidas, Midnight mode `i`/`m`, auto `fit-page`, cursor oculto `cursor-type nil`, atalhos unificados) e retaguarda contínua a 192 DPI para PDF e DjVu (`doc-view-mode` com MuPDF, Poppler e `graphics/djvulibre` acelerado via `ddjvu`, com dark mode invertido `i`).
    - [x] Leitor de e-books EPUB com reflow tipográfico dinâmico (`nov-mode`).
    - [x] Despachante inteligente `open-smart` (`o` / `open`) integrando buffers do Emacs para documentos, SQLite, compactados e código.
- [x] **Suíte de Substitutos Nativos de Aplicações no Emacs:**
    - [x] Navegador de banco de dados SQLite nativo (`sqlite-mode` via `$ o db.sqlite3` / `$ sql`).
    - [x] Visualizador e extrator de arquivos compactados (`arc-mode` e `tar-mode` via `$ o archive.zip`).
    - [x] Monitor de processos do sistema interativo (`proced` via `$ procs` / `$ htop`).
    - [x] Comparador visual e mesclador interativo de diferenças lado a lado (`ediff` via `$ ediff`).
    - [x] Calculadora científica, algébrica e simbólica RPN (`calc` via `$ calc`).
    - [x] Editor e inspetor binário hexadecimal (`hexl-mode` via `$ hex`).
    - [x] Gerenciador dual-pane com edição em lote de diretórios (`dired` + `wdired` via `C-x C-q` / `r`).
- [x] **Ciclo Unificado de Piscar de Cursor (1200ms):**
    - [x] Sincronização estrita de 1200ms (`600ms` aceso, `600ms` apagado) no GNU Emacs (`blink-cursor-interval 0.6`, `blink-cursor-delay 0.6`, `blink-cursor-blinks 0`), NeoVim e Vim (`blinkwait600-blinkoff600-blinkon600`), GTK3 e GTK4 (`gtk-cursor-blink-time=1200`) e XTerm (`*cursorBlink: always`).
- [x] **Fluidez de Redimensionamento no GNU Emacs:**
    - [x] Configuração de `(setq frame-resize-pixelwise t)` eliminando loops de repintura sob KWin/Plasma.
- [x] **Comandos Interativos de Lançamento de Apps Gráficos no Emacs:**
    - [x] Adicionados `M-x firefox`, `M-x chrome`, `M-x chromium`, `M-x kate`, `M-x gimp`, `M-x wireshark`, `M-x kdeconnect` e `M-x thunderbird`.
- [x] **Suíte Completa LibreOffice e Padronização de Editores:**
    - [x] Receita modular `Setup/common/office/office.sh` para os 6 componentes do LibreOffice com tema escuro GTK3 injetado.
    - [x] Receita modular `Setup/common/editors/editors.sh` consolidando o ícone único `emacs.desktop` e ocultando entradas auxiliares.
- [x] **Ergonomia e Keymaps em Console Puro (Raw TTY):**
    - [x] Suporte a sequências xterm para `Ctrl+Left` e `Ctrl+Right` via keymaps do sistema.

---

### 🐚 4. Repositório `Shell` & `Profile` — Userland, Hypervisors & Aliases

- [x] **Comutação de Userland (`userland`):**
    - [x] Subcomandos `gnu`, `bsd`, `default` e `status` para alternância dinâmica de ferramentas e toolchains.
- [x] **Suporte a Hipervisores e VM NetBSD (`nb`):**
    - [x] Comando universal `nb` para controle da VM NetBSD sob Bhyve ou KVM.
- [x] **Matriz de Aliases Renovada:**
    - [x] Aliases concisos para players multimídia, suítes de escritório, navegadores e ferramentas de diagnóstico.

---

## 💡 Insights & Notas Arquiteturais

> [!NOTE]
> Registro técnico das decisões de engenharia homologadas no ecossistema:

- **Alocação Proporcional 16 Partes:** A partição fixa de memória (1/16 VM, 4/16 ARC, 11/16 Host) garante estabilidade operacional contínua, prevenindo disputas de alocação física entre o ZFS ARC e o alocador contíguo de páginas do driver DRM `i915kms`.
- **Injeção de Tema nos Lançadores Desktop:** A injeção direta de `SAL_USE_VCLPLUGIN=gtk3 GTK_THEME=adw-gtk3-dark GTK_APPLICATION_PREFER_DARK_THEME=1` nas entradas `.desktop` locais garante que aplicações complexas como LibreOffice e Emacs herdem o tema escuro independentemente do compositor ativo (KDE, GNOME, Sway ou Openbox).
- **Isolamento de Quiosques Declarativos:** A transição de scripts de polling contínuo (`xdotool`) para diretivas declarativas nativas no Openbox e no Sway eliminou integralmente condições de corrida de redimensionamento e travamentos de sessão gráfica.

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
