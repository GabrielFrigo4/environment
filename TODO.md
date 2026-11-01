# 🗺️ Roadmap & Status — Universal Environment

> **Status:** 🟢 **100% Operacional & Estável — Zero Pendências Ativas**
> O orquestrador central do Quarteto de Produtividade atingiu maturidade arquitetural plena. Todos os 10 grandes épicos do ecossistema e as rodadas finais de polimento gráfico, suítes modulares de escritório e dimensionamento dinâmico de memória foram integralmente entregues, testados e auditados em Linux, FreeBSD e Windows.

---

## 📊 Matriz de Maturidade do Ecossistema

| Repositório              | Papel                       | Maturidade | Cobertura / Estado                                                                                                                                                                                              |
| :----------------------- | :-------------------------- | :--------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Environment**          | Hub central & Makefile      |  🟢 100%   | Orquestração global, quality gates unificados (`make ci`), documentos canônicos, suíte de editores e compositores                                                                                               |
| **Shell**                | Motor de terminal & prompts |  🟢 100%   | Latência < 16ms (ULTRA), `wwm-bar` GTK3 (`:hover` e fallback swaybar), `xwm` resize 8 direções/Alt+RightClick, `xgui-tabbar` GTK3 dock (`>= 2` janelas), pipeline 11-DE/10-compositor, `userland` e `nb`        |
| **Setup**                | Provisionador de sistema    |  🟢 100%   | Arquitetura modular `core/`, suíte LibreOffice (`Writer`, `Calc`, `Impress`, `Draw`, `Math`, `Base`) com tema escuro GTK3, `emacs.desktop` unificado, cálculo 16 partes ARC/VM e dicionários Hunspell bilíngues |
| **Vault**                | Cofre privado de segredos   |  🟢 100%   | Chaves SSH, auditoria canônica `age`, backups e `.env` seguros                                                                                                                                                  |
| **Profile**              | Dotfiles & skills de IA     |  🟢 100%   | Paridade multiplataforma, temas escuros Adwaita/Breeze Dark (`#1e1e22`, `#2b2b30`, `#3584e4`, `#e01b24`), tipografia determinística e skills de IA                                                              |
| **Emacs**                | Editor Elisp extensível     |  🟢 100%   | Arquitetura sensorial, aweww Dual-Engine, reprodução `mpv` IPC, frame gráfico `ewm` sem tool-bar, `exwm` com simulação contextual de teclas e ergonomia TTY                                                     |
| **Helix / NeoVim / Vim** | Suíte de Editores modais    |  🟢 100%   | Runtimes soberanos, Mason LSP, mouse SGR 1006 no FreeBSD `vt(4)`, cursores em bloco coloridos por modo no TTY e `:terminal` 16 cores                                                                            |
| **Template**             | Arquétipo de novos projetos |  🟢 100%   | Scaffolding `init.sh`, suíte de auditoria e TUI semântica                                                                                                                                                       |

---

## 🛡️ Atributos e Conquistas Centrais

- **Zero Pendências:** 100% dos épicos (Otimização do Shell, Lapidação do Profile, Invariante Out-of-the-Box, AI Skills, Paridade Windows Tripartite, Modularização de Scripts, Virtualização Híbrida Bhyve, Portal Canônico de Docs, Refatoração do Setup e GNU Emacs Sensorial) foram integralmente concluídos e verificados.
- **Suíte LibreOffice Completa e Tema Escuro GTK3 (`office.sh`):** Provisão declarativa de todos os 6 aplicativos oficiais (`Writer`, `Calc`, `Impress`, `Draw`, `Math`, `Base`) juntamente com `libreoffice-gtk3` e `libreoffice-gtk4`. Injeção de variáveis de tema escuro nos `.desktop` locais (`SAL_USE_VCLPLUGIN=gtk3`, `GTK_THEME=adw-gtk3-dark`, `GTK_APPLICATION_PREFER_DARK_THEME=1`), persistência via `environment.d` e overrides para Flatpak.
- **Padronização de Editores e Lançador Único do Emacs (`editors.sh`):** Consolidação do lançador `emacs.desktop` apontando para `emacsclient --create-frame --alternate-editor="" %F` com tema escuro GTK3 forçado, ocultando lançadores secundários redundantes (`emacsclient.desktop`, `emacs-mail.desktop`, `emacsclient-mail.desktop`) via `NoDisplay=true`.
- **Dimensionamento Dinâmico de Memória Proporcional 16 Partes:** Cálculo automático baseado na memória física real (`hw.realmem || hw.physmem`) em `zfs-arc.sh` e `bhyve.sh`: alocação de `1/16` para máquinas virtuais (mínimo 1 GB, teto 2 GB), `4/16` para o ZFS ARC (mínimo 1 GB, teto 4 GB) e preservação de `11/16` para o host gráfico e subsistema DRM.
- **Dicionários Bilíngues e Fontes de Alta Densidade no FreeBSD:** Instalação oficial dos dicionários Hunspell em inglês e português do Brasil (`hunspell`, `en-hunspell`, `pt_BR-hunspell`) e tipografia de alta densidade (`jetbrains-mono`, `nerd-fonts`).
- **Despachante Universal de Display Server (`_dispatch_display_server`):** Arquitetura desacoplada onde comandos universais (`window-manager`, `graphical-launcher`, `emacs-window-manager`) despacham transparentemente para variantes `-wayland` ou `-x11`, com autocompletion semântico unificado e aliases ergonômicos (`wm`, `win`, `wwm`, `way`, `xwm`, `xorg`, `x11`, `gui`, `wgui`, `xgui`, `ewm`, `wewm`, `xewm`).
- **Gerenciadores de Janela Puros (`wwm` e `xwm`):** `wwm` opera sobre compositores Wayland com barra superior interativa GTK3 (`wwm-bar`) com transições `:hover` e fallback para `swaybar` JSON. `xwm` opera sobre Openbox com suporte completo a redimensionamento em 8 direções (bordas, cantos, grips) e `Alt+RightClick` para janelas SSD (Terminal, Emacs, etc.), além de menu de contexto categorizado dinamicamente em 5 grupos (`Development`, `Internet`, `Office`, `Media & Graphics`, `System & Tools`) a partir dos arquivos `.desktop`.
- **Quiosques Efêmeros com Abas Dinâmicas (`wgui` e `xgui`):** `wgui` integra o daemon reativo `wgui-tabwatch` para auto-ocultar abas em tela cheia com 1 janela e comutar para abas no topo quando há $\ge 2$ janelas. `xgui` opera sobre Openbox com barra dinâmica de abas superior em Python 3 + GTK3 + X11 (`xgui-tabbar`) que surge como dock de 28px apenas sob $\ge 2$ janelas normais, com feedback visual em `:hover`.
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
    - [x] `wwm` com barra interativa GTK3 (`wwm-bar`) com transições CSS `:hover` em workspaces (`1..5`) e ações (`[ Web Browser ]`, `[ Terminal ]`, `[ Files ]`, `[ Emacs ]`, `[ Menu ]`, `[ Close ]`, `[ Exit ]`), e fallback automático para `swaybar` JSON.
    - [x] `xwm` com Openbox, suporte completo a redimensionamento em 8 direções e `Alt+RightClick` para janelas SSD (Terminal, Emacs, etc.), e menu dinâmico de 5 categorias indexadas via arquivos `.desktop`.
- [x] **Quiosques Efêmeros com Abas Dinâmicas (`wgui` e `xgui`):**
    - [x] `wgui` com daemon reativo auto-ocultando abas com 1 janela e ativando modo tabbed com $\ge 2$ janelas.
    - [x] `xgui` com barra superior dinâmica em Python 3 + GTK3 + X11 (`xgui-tabbar`) efêmera (`_NET_WM_WINDOW_TYPE_DOCK` de 28px) ativada apenas sob $\ge 2$ janelas normais, com feedback visual `:hover`.
- [x] **Pipeline Universal de 11 DEs & 10 Compositores (`Shell`):**
    - [x] Detecção em cascata (`KDE > GNOME > MATE > Cinnamon > XFCE > LXQt > LXDE > Budgie > Pantheon > Deepin > COSMIC`) e compositores independentes.
    - [x] Unificação estética automática de GTK, Qt, fontes e temas de cursor (`XCURSOR_THEME`, `XCURSOR_SIZE=24`).

---

### 🐃 3. GNU Emacs, Editores Modais e Ergonomia em Raw TTY

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
