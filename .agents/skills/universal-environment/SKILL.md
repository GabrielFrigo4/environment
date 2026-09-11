---
name: universal-environment
description: >-
    Comprehensive guide and operational runbook for the Universal Environment hub repository.
    Use when managing submodules, orchestrating cross-repo operations via Makefile,
    updating canonical documentation (ENVIRONMENT.md, PRINCIPLES.md), and coordinating
    changes across the Quarteto de Produtividade ecosystem.
---

# Universal Environment — Hub Orchestration Runbook

Este guia detalha o fluxo operacional para gerenciar, estender e auditar o repositório **Universal Environment** (hub orquestrador), garantindo aderência rigorosa aos 18 Princípios de Engenharia e coordenação entre os 4 componentes do Quarteto.

---

## 1. Mapeamento de Responsabilidades (O que pertence ao Environment)

Antes de criar qualquer arquivo, verifique se ele pertence ao Environment ou a um sub-repo:

| Conteúdo                       | Pertence ao            | Justificativa                    |
| :----------------------------- | :--------------------- | :------------------------------- |
| Makefile global                | Environment            | Orquestra operações nos 4 repos  |
| ENVIRONMENT.md / PRINCIPLES.md | Environment (canônico) | Fonte da verdade do ecossistema  |
| README.md do hub               | Environment            | Portal de entrada do ecossistema |
| AGENTS.md do hub               | Environment            | Briefing para IAs sobre o hub    |
| Receitas de provisionamento    | Setup                  | Código executável de SO          |
| Scripts de shell/prompts       | Shell                  | Motor interativo de terminal     |
| Segredos e chaves              | Vault                  | Cofre privado criptografado      |
| Dotfiles e skills de IA        | Profile                | Identidade do desenvolvedor      |

---

## 2. Operações de Submódulos

### Atualizar submódulos para o commit mais recente do upstream:

```sh
git submodule update --remote --merge
git add Setup Shell Profile
git commit -m "⬆️ Update submodules to latest"
```

### Inicializar em nova máquina:

```sh
git clone --recurse-submodules "https://github.com/GabrielFrigo4/environment"
make clone
```

### Clonar o Vault manualmente (se autorizado):

```sh
git clone "git@github.com:GabrielFrigo4/vault.git" Vault
```

---

## 3. Propagação de Documentação Canônica

Ao atualizar `ENVIRONMENT.md` ou `PRINCIPLES.md` no Environment:

1. Edite a versão canônica na raiz do Environment.
2. Copie para os 4 sub-repos (`Setup`, `Shell`, `Vault`, `Profile`).
3. Commite em cada sub-repo separadamente.

---

## 4. Checklist de Validação

```sh
git diff --check

git status

make status
```
