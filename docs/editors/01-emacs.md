# 🦣 GNU Emacs: Arquitetura Elisp & Carregamento Assíncrono Elpaca

> Governança do GNU Emacs no ecossistema: otimização pré-frame no `early-init.el`, gerenciamento de pacotes assíncrono com Elpaca e testes de integridade headless.

---

## 🧭 Visão Geral & Filosofia do Emacs

O **GNU Emacs** é mais do que um editor de texto: é um interpretador interativo de Lisp completo e um ambiente computacional soberano. No Universal Environment, o Emacs é configurado para oferecer inicialização sub-segundo, tipografia adaptativa e gestão avançada de notas através do **Org-mode**.

Para garantir confiabilidade industrial, a configuração rejeita gerenciadores síncronos legados (`package.el`) em favor do **Elpaca**, um gestor moderno e assíncrono que compila e instala pacotes em threads separadas sem travar a interface do usuário.

---

## ⚡ Otimização Pré-Frame: `early-init.el`

O arquivo `early-init.el` é executado antes da criação da primeira janela gráfica do Emacs. É o local canônico para desativar ruídos visuais e otimizar o coletor de lixo (Garbage Collector):

```elisp
;; ================================================================
;; early-init.el: Otimizações Críticas Pré-Inicialização
;; ================================================================

;; 1. Elevar o limiar do Garbage Collector durante o boot (128 MB)
(setq gc-cons-threshold (* 128 1024 1024)
      gc-cons-percentage 0.6)

;; 2. Restaurar limiar sustentável após o boot
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))

;; 3. Desativar package.el legado para priorizar o Elpaca
(setq package-enable-at-startup nil)

;; 4. Suprimir elementos visuais antes da renderização do frame
(push '(menu-bar-lines . 1) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
```

---

## 📦 Gerenciamento Assíncrono com Elpaca & `use-package`

No `init.el`, o bootstrapping do Elpaca garante que dependências sejam resolvidas via Git de forma determinística:

```elisp
;; Instalação declarativa via Elpaca + use-package
(elpaca elpaca-use-package
  (elpaca-use-package-mode)
  (setq elpaca-use-package-by-default t))

;; Exemplo: Configuração do Org-mode
(use-package org
  :ensure nil ; Pacote embutido no Emacs
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-startup-indented t))
```

---

## 🧪 Testes Automatizados Headless (`make test`)

Todo commit no repositório `Editor/Emacs` é submetido ao teste de inicialização não-interativo via Makefile:

```sh
# Executar teste de sanidade batch
emacs --batch -l tests/test-startup.el
```

Esse quality gate impede que erros de sintaxe em Elisp ou pacotes quebrados entrem na branch principal do ecossistema.
