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

## 5. Governança de Roadmap & Os 4 Grandes Épicos (Opção C)

O ecossistema adota a estratégia híbrida de governança:

- **`README.md`:** Badges vetoriais `[![Roadmap](https://img.shields.io/badge/🗺️_Roadmap-TODO.md-teal)](TODO.md)` e links elegantes de status macro.
- **`TODO.md`:** Matriz detalhada de status/cobertura de componentes e backlog estruturado de tarefas atômicas.

### Os 4 Grandes Épicos Estratégicos:

1. **🏛️ Refatoração do Setup:** Desconstrução de rusticidade, modularização em receitas idempotentes, conformidade POSIX `/bin/sh` sem bashismos e UI semântica `_ui_*`.
2. **📝 Arquitetura Modular do GNU Emacs:** Detecção dinâmica sensorial de display (Wayland/PGTK, X11, DirectWrite), Tree-sitter ABI ≥ 14, compilação nativa AOT/JIT (`libgccjit`) e tipografia adaptativa.
3. **🎨 Lapidação do Universal Profile:** Padronização dos terminais Windows (PowerShell, NuShell, CMD/Clink) com `_ui_*` e família `up*`, resiliência de symlinks e governança XDG.
4. **🛡️ Invariante de Clonagem "Out-of-the-Box":** O ecossistema deve ser 100% executável logo após o `git clone`. Modos octais canônicos no Git Index (`0755`/`0644`/`0700`/`0600`), zero intervenção manual pós-clone e auto-cura em tempo de execução.

---

## 6. Padronização Semântica de UI (`_ui_*`)

Qualquer rotina interativa ou de status no Shell (UNIX) ou nos perfis de terminal do Profile (Windows: PowerShell, NuShell, CMD/Clink) deve usar a biblioteca semântica:

- `_ui_step`: `==> <msg>` (Ciano) - Início de etapa primária.
- `_ui_sub`: `  ↳ <msg>` (Azul) - Subtarefa ou item inspecionado.
- `_ui_ok`: `  ✅ <msg>` (Verde) - Conclusão com sucesso.
- `_ui_warn`: `  ⚠️  <msg>` (Amarelo) - Alerta preventivo.
- `_ui_err`: `  ❌ <msg>` (Vermelho em `stderr`) - Erro crítico.
- `_ui_info`: `  ℹ️  <msg>` (Magenta) - Informação contextual.
- `_ui_banner`: Régua de 64 `=` em Ciano.

---

## 7. Checklist de Validação

```sh
git diff --check

git status

make status

make test

make audit

make lint-md

make ci
```
