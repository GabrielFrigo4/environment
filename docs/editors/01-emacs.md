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

## 🐚 Aweshell: Terminal Soberano & Ghost Completion Estilo Zsh

O **Aweshell** (`usr/local/aweshell`) é a extensão de terminal integrado desenvolvida para oferecer paridade 1:1 com a experiência interativa do Universal Shell:

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
