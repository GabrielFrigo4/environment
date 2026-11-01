# 🦣 GNU Emacs: Arquitetura Elisp & Carregamento Assíncrono Elpaca

> Governança do GNU Emacs no ecossistema: otimização pré-frame no `early-init.el`, gerenciamento de pacotes assíncrono com Elpaca, motor de terminal Aweshell e gestão de janelas Dual-Realm.

---

## 🧭 Visão Geral & Filosofia do Emacs

O **GNU Emacs** é mais do que um editor de texto: é um interpretador interativo de Lisp completo e um ambiente computacional soberano. No Universal Environment, o Emacs é configurado para oferecer inicialização sub-segundo, tipografia adaptativa e gestão avançada de notas através do **Org-mode**.

Para garantir confiabilidade industrial, a configuração rejeita gerenciadores síncronos legados (`package.el`) em favor do **Elpaca**, um gestor moderno e assíncrono que compila e instala pacotes em threads separadas sem travar a interface do usuário.

---

## ⚡ Otimização Pré-Frame: `early-init.el`

O arquivo `early-init.el` é executado antes da criação da primeira janela gráfica do Emacs. É o local canônico para desativar ruídos visuais e otimizar o coletor de lixo (Garbage Collector):

```elisp
(setq gc-cons-threshold (* 128 1024 1024)
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))

(setq package-enable-at-startup nil)

(push '(menu-bar-lines . 1) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
```

---

## 📦 Gerenciamento Assíncrono com Elpaca & `use-package`

No `init.el`, o bootstrapping do Elpaca garante que dependências sejam resolvidas via Git de forma determinística:

```elisp
(elpaca elpaca-use-package
  (elpaca-use-package-mode)
  (setq elpaca-use-package-by-default t))

(use-package org
  :ensure nil
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-startup-indented t))
```

---

## 🖥️ Arquitetura de Interface & Renderização PGTK Cairo

A arquitetura visual implementa proteções para consistência de frames e responsividade da interface:

- **Supressão Incondicional da Tool-Bar:** A rotina `interface/apply-tool-bar` força `tool-bar-lines 0` e `tool-bar-mode -1` em todos os contextos de inicialização — interfaces gráficas (GUI), gerenciador de janelas Emacs (EWM) e consoles TTY. A barra de menu (`menu-bar`) é preservada exclusivamente em ambientes gráficos (`menu-bar-mode 1`) e suprimida em consoles de texto puro.
- **Flush Imediato de Hover Cairo em Wayland PGTK:** Sob o backend PGTK nativo, o Emacs ativa `track-mouse t` e intercepta eventos `[mouse-movement]` via `interface/pgtk-flush-mouse-hover`. Ao detectar sobreposição do ponteiro sobre elementos com propriedade `mouse-face` ou `button` (como botões do Dashboard), o handler dispara `redisplay t` imediato na superfície Cairo, eliminando a latência de 500ms atrelada ao ciclo de piscar do cursor.

---

## 🔤 Correção Ortográfica Bilíngue Sem Bloqueio (`/usr/bin/look`)

O subsistema de texto e escrita do Emacs descarta rotinas síncronas legadas em favor de verificação de dicionário de alta performance:

- **Eliminação de Subprocessos `/usr/bin/look`:** As variáveis `text-mode-ispell-word-completion` e `ispell-look-p` são desativadas (`nil`), impedindo chamadas síncronas ao binário de sistema que congelavam a interface durante buscas e completações em buffers de texto.
- **Dicionário Bilíngue Simultâneo (`hunspell`):** Integração automática com o motor Hunspell configurando caminhos canônicos (`DICPATH`) e carregamento simultâneo dos dicionários de inglês e português (`en_US,pt_BR`) via `ispell-hunspell-add-multi-dic`.

---

## 🐚 Aweshell: Terminal Soberano, Ghost Completion & Biblioteca Semântica UI

O **Aweshell** (`usr/local/aweshell`) é a extensão de terminal integrado desenvolvida para oferecer paridade 1:1 com a experiência interativa do Universal Shell:

- **Biblioteca Semântica Nativa `_ui_*`:** Funções integradas do Eshell (`_ui_banner`, `_ui_step`, `_ui_sub`, `_ui_ok`, `_ui_warn`, `_ui_err`, `_ui_info`) garantem total paridade visual com `Shell/library/ui.sh`, com cores ricas em GUI/PTY e representação ASCII limpa em terminais básicos.
- **Isolamento de Completação do `eshell-mode`:** O modo global `completion-preview-mode` é desativado dentro do Aweshell (`(completion-preview-mode -1)`), evitando conflitos entre o completador de Lisp e os comandos do shell. Nos buffers convencionais de código e texto, o `completion-preview-mode` atua com delay de `0.2s` (`completion-preview-idle-delay 0.2`) e comprimento mínimo de símbolo de `2` caracteres (`completion-preview-minimum-symbol-length 2`).
- **Ghost Completion Preditivo:** Motor de predição inline baseado na ordem histórica mais recente, com parada estrita em correspondência exata.
- **Navegação Híbrida Unificada:** Tecla `<right>` aceita instantaneamente o texto fantasma previsto; tecla `TAB` abre e cicla pelo popup de completação do `company-mode`.
- **Sincronização de Sessão:** Histórico de comandos persistente e unificado entre sessões de terminal externo e buffers internos do editor.

---

## 🪟 Gestão de Janelas: Filosofia Dual-Realm no EXWM & EWM

O Emacs atua como gerenciador de janelas soberano no X11 (**EXWM**) e no Wayland (**EWM**), implementando a arquitetura **Dual-Realm**:

- **Detecção Contextual Inteligente:** O gerenciador identifica ativamente se o buffer em foco é um emulador de terminal (`aweshell`, `vterm`) ou uma aplicação gráfica externa (X11 / Wayland).
- **Preservação de Atalhos em Terminal:** Em buffers de terminal, sequências de controle nativas (`Ctrl+C`, `Ctrl+Z`, `Ctrl+R`) são repassadas diretamente ao shell subjacente sem interceptação indesejada pelo window manager.
- **Ergonomia Global em Apps Gráficos:** Em aplicativos gráficos externos, as teclas de comando global do Emacs assumem controle para manipulação de janelas, splits e chaveamento de workspaces.
- **Sincronização Bidirecional de Clipboard:** Integração fluida entre o Clipboard X11/Wayland e a Seleção Primária (Primary Selection), garantindo cópia e colagem sem descompasso entre aplicações nativas e o Emacs Kill-Ring.
- **Isolamento D-Bus Multi-TTY:** Cada instância do EXWM/EWM opera com barramento D-Bus independente atrelado ao terminal virtual correspondente, sem conflitos entre diferentes sessões gráficas simultâneas.

---

## 🧪 Testes Automatizados Headless (`make test`)

Todo commit no repositório `Editor/Emacs` é submetido ao teste de inicialização não-interativo via Makefile:

```sh
emacs --batch -l tests/test-startup.el
```

Esse quality gate assegura a integridade estrutural e impede regressões sintáticas no ecossistema.
