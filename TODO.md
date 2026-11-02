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

## 📌 Backlog & Próximos Passos

## Xorg/X11 no FreeBSD/Linux e no OpenBSD

Em varios sistemas tipo no Emacs o pipeline de fallback depende do Sistema Operacional...
E fiquei pensando. No caso do X Window Manager (xwm e o xgui) não seria a mesma logica tipo
No FreeBSD/Linux já está definido... Mas no OpenBSD ele vem com 3 eu acho baixado por padrão...
Não é dhr tipo no FreeBSD/Linux termos um pipeline e no OpenBSD termos outro? Tipo o do OpenBSD ser um pipeline mais rico pela naturesa do X11 (Xenocara) nele e no FreeBSD e Linux ser +/- o que temos agora menos o cwm... (ao menos que de para baixar cwm no Linux/FreeBSD... Mas acho que voce entendeu a ideia...)
A ideia seria semelhante ao pipeline dos browsers no Emacs... Que muda entre Linux, FreeBSD, MacOS, Windows e deveria ter o OpenBSD eu acho... Ou é o mesmo que o FreeBSD nn lembro kkk.

## Menu no Xorg/X11

Nos submenus com bordar arredondadas fica nessas bordar tipo um resto de retangulo preto... Em todas e quaisquer bordas arredondadas... É como se fosse um fundo retangular preto que fica atras desses submenus que só ficou vizivel porque a borda das quinas são arredondadas (se fossem retangulares retas ficaria escondido)... Tipo os menus dos emacs, do wireshark e etc...

Gostaria que isso acontecesse

```
Com o mouse (Menu da área de trabalho): Clique com o botão do meio do mouse em qualquer área livre do fundo da tela (desktop). Isso abrirá um menu suspenso listando todas as janelas abertas. As janelas minimizadas aparecem com o nome entre parênteses (Nome da Janela). Basta clicar nelas para restaurá-las.
```

E por fim gostaria que se eu pegar no title bar e arrastar que a janela desmaximize e se mova... Um comportamento meio comum...

E olha o que apareceu no meu "Antigravity"

```
You're running in a GNOME environment but the OS keyring is not available for encryption. Ensure you have gnome-keyring or another libsecret compatible implementation installed and running.
```

Tipo o meu fedora realmente é com GNOME, mas eu não loguei eu entrei no tty e abri o xwm...
Mas interessante isso... O que podemos fazer para funcionar melhor ainda? Reparei que sempre tenho que relogar nas coisas porque não fica salvo quando estou fora do GNOME e eu reinicio o computador (e eu acredito que isso só acontece no X11 mas tudo bem)

## Icones no Xorg/X11

Em geral eles estavam perfeitos 1 para 1 com o Waylando (onlyoffice, libreoffice e etc tudo correto) MAS no antigravity e agora no libreoffice e nos dialogs os icones não estão pareados... Tem que arrumar esse comportamento divergente do xgui e xwm e xewn... O erro era nos arquivos de configuração do gtk3 e gtk4... Tem quYou're running in a GNOME environment but the OS keyring is not available for encryption. Ensure you have gnome-keyring or another libsecret compatible implementation installed and running.e arrumar eles se não me engano...

## Tearing / VSync no Xorg/X11 (Openbox e cwm)

- [ ] Resolver a dessincronização (tearing) ao mover janelas no Xorg/X11, tanto no Openbox (`xwm`) quanto no cwm. Sem compositor as janelas vão direto pro framebuffer sem sincronizar com o retrace vertical.
- [ ] Openbox: baixar testar `picom --backend glx --vsync` (o backend `xrender` ainda pode dar tearing). Ver também a opção `TearFree` no driver (`amdgpu`/`intel`/`radeon`), que não precisa de compositor. O `modesetting` não tem essa opção.
- [ ] cwm (Xenocara/OpenBSD): instalar um compositor pelos pacotes (`pkg_add picom` ou `xcompmgr`) e testar o vsync com `glx`. Depende do suporte do Mesa a swap control no hardware, então pode variar. Conferir em `/var/log/Xorg.0.log` e no `man` do driver se `TearFree` existe.
- [ ] Se funcionar, avaliar iniciar o compositor automaticamente junto com o `xwm`/cwm no `Shell`.

## (X/W)GUI e (X/W)WM

Gostaria de deixar claro que no geral o sway e o openbox estão muito bons... Mas tem outros compositores no pipeline e eu gostaria de deixar absolutamente todos com um comportamento semelhante satfatorio (claro que cada um com a sua peculiariedade mas seguindo a mesma linha de recursos, tabs, abas, temas, menus e etc...)

## Emacs no Wayland

Em todo "botão/link" que muda de cor quando o mouse passa por cima (tipo no Dashboard, mas não só no dashboard) ele está meio travado e coicidentemente ele trava no ritimo da piscada do cursor kkk. Eu não quero mudar o comportamento do cursor e do mouse... Só quero fazer ficar "liso" que nem o emacs no xorg/x11 está... Esse travamento só acontece no wayland... E eu, repedindo de novo, não quero alterar o comportamento do mouse nem nada... Só quero que esse travamento não aconteça mais.

## Emacs

```el
⛔ Error (use-package): evil/:catch: Symbol’s value as variable is void: doc-view-mode-map
```

- [ ] Eu acho que temos que melhorar a integração de copiar e colar e de atalhos entre o emacs e o (x/w)ewm... Tipo meio qu fizemos isso mas aparentemente funciona só pela metade kkk, no colar funciona maravilhosamente bem mas no copiar... Ai ai ai, o atalho control-c buga muito... Não só esse atalho mas esse é o mais cotidiano que quebra... Esse tipo de erro acontece mais no exwm do que no ewm... Na verdade o ewm simplesmente está funcionando 100%... O exwm que tem um pouco desse problema
- [ ] Por fim acho que seria interessante colocar o comando no emacs de agy... Tipo abri o agy num vterm ou term (eu realmente não sei qual dos 2 é melhor...) e usar... Seria incrivel... Levando em conta que o agy muda no FreeBSD e no Linux (olhar o Shell) e etc...
- [ ] E por fim seria possivel melhorar o aweshell ao ponto de conseguir rodar o agy e aplicações TUI dentro do aweshell sem bugar completamente? Seria o meu sonho fazer isso

## Setup

- [ ] Além disso temos que baixar o libtool no FreeBSD / Fedora e etc... para poder compilar o vterm
- [ ] Baixar isso no MSYS2, FreeBSD e Linux "pacman -S --needed mingw-w64-ucrt-x86_64-texlive-plain-generic"

## Shell (MSYS2/Windows/uped)

- [ ] Ele não atualiza o emacs que fica na pasta ~/.emacs.d e nem o vim que fica ~/vimfiles... (tem que adicionar esses caminhos na lista dos caminhos validos)
- [ ] Ele falhou na atualização do nvim... Tipo só falhou... Eu fui no diretorio e dei um git pull e foi kkkk... Lembrando que essas ferramentas as configurações estão fora do MSYS2...
- [ ] No Windows o nvim muda o formato do cursor corretamente mas o vim não... E o emacs-no-windows (en / enw) simplesmente abrem o emacs client (com window) kkkk

## Shell & Aweshell

- [ ] Tem varias coisas que foram adicionadas para o Shell que não foram espelhadas para o Aweshell, Powershell, Nushell, CMD/Clink...

## Make

Fazer com que o make fique "posix" de verade... Apesar do bmake e gmake funcionarem muito bem mesmo no posix mode, o busybox ele não funciona o -C quando está no posix...

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
