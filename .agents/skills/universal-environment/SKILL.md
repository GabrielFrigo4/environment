---
name: universal-environment
description: >-
    Comprehensive guide and operational runbook for the Universal Environment hub repository.
    Use when managing submodules, orchestrating cross-repo operations via Makefile,
    updating canonical documentation (ENVIRONMENT.md, PRINCIPLES.md), and coordinating
    changes across the Quarteto de Produtividade ecosystem.
---

# Universal Environment — Hub Orchestration Runbook

Este guia detalha o fluxo operacional para gerenciar, estender e auditar o repositório **Universal Environment** (hub orquestrador), garantindo aderência rigorosa aos 21 Princípios de Engenharia e coordenação entre os 4 componentes do Quarteto e a Suíte de Editores.

---

## 1. Mapeamento de Responsabilidades (O que pertence ao Environment)

Antes de criar qualquer arquivo, verifique se ele pertence ao Environment ou a um sub-repo:

| Conteúdo                       | Pertence ao            | Justificativa                         |
| :----------------------------- | :--------------------- | :------------------------------------ |
| Makefile global                | Environment            | Orquestra operações nos 8 repos       |
| ENVIRONMENT.md / PRINCIPLES.md | Environment (canônico) | Fonte da verdade do ecossistema       |
| README.md do hub               | Environment            | Portal de entrada do ecossistema      |
| AGENTS.md do hub               | Environment            | Briefing para IAs sobre o hub         |
| Receitas de provisionamento    | Setup                  | Código executável de SO               |
| Scripts de shell/prompts       | Shell                  | Motor interativo de terminal          |
| Segredos e chaves              | Vault                  | Cofre privado criptografado           |
| Dotfiles e skills de IA        | Profile                | Identidade do desenvolvedor           |
| Configurações de Editores      | Editor/*               | Runtimes de Emacs, Helix, Neovim, Vim |

---

## 2. Bancada de Desenvolvimento vs. Runtimes de Produção

O repositório **Environment** (`~/Documents/Environment`) é **exclusivamente uma bancada de desenvolvimento e orquestração** (Princípio 21 & Regra 6 do AGENTS.md):

1. **Isolamento Total:** Absolutamente **NADA** residente no diretório do Environment deve ser usado diretamente pelo SO hospedeiro.
2. **Sem Symlinks para o Hub:** É expressamente proibido criar symlinks de dotfiles ou configurações de shell que apontem para o clone do Environment.
3. **Provisionamento Soberano (`make install`):** A instalação no SO hospedeiro é executada via `make install` (ou `./environment.sh install`), que clona e provisiona cada repositório em sua localização canônica (`/usr/local/share/shell` ou `~/.local/share/shell`, `~/.config/profile`, `~/.vault`, `~/.emacs.d`, `~/.config/nvim`, `~/.config/helix`, `~/.vim`).
4. **Desacoplamento de `make sync`:** `make sync` não pertence ao Environment; dotfiles são geridos diretamente pelo clone soberano do Profile via `~/.config/profile/profile.sh sync`.

---

## 3. Operações de Submódulos

### Atualizar submódulos para o commit mais recente do upstream:

```sh
git submodule update --remote --merge
git add Setup Shell Profile Editor/Emacs Editor/Helix Editor/NeoVim Editor/Vim
git commit -m "⬆️ Update submodules to latest"
```

### Inicializar bancada de desenvolvimento em nova máquina:

```sh
git clone --recurse-submodules "https://github.com/GabrielFrigo4/environment" "${HOME}/Documents/Environment"
cd "${HOME}/Documents/Environment"
make clone
make install
```

### Clonar o Vault manualmente (se autorizado):

```sh
git clone "git@github.com:GabrielFrigo4/vault.git" Vault
```

---

## 4. Propagação de Documentação Canônica

Ao atualizar `ENVIRONMENT.md` ou `PRINCIPLES.md` no Environment:

1. Edite a versão canônica na raiz do Environment.
2. Execute `make sync-docs` para propagar automaticamente para todos os submódulos (`Setup`, `Shell`, `Vault`, `Profile`, `Editor/*`).
3. Commite e dê push em cada repositório separadamente.

---

## 5. Checklist de Validação

```sh
git diff --check

git status

make status

make audit
```
