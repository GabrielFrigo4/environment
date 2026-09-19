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

## 5. Governança de Roadmap & Ciclo de Evolução (Opção C)

O ecossistema adota uma separação rigorosa entre documentação institucional, especificações de engenharia e estado dinâmico:

- **`README.md` (Vitrine & Entrada):** Portal de boas-vindas, arquitetura de alto nível, plataformas suportadas e badge `[![Roadmap](https://img.shields.io/badge/🗺️_Roadmap-TODO.md-teal)](TODO.md)` direcionando para o status detalhado.
- **`TODO.md` (Estado Dinâmico & Backlog):** Única fonte dinâmica da verdade para a matriz de maturidade/cobertura operacional e para os épicos e tarefas em andamento.
- **Skills & `AGENTS.md` (Invariantes de Engenharia):** Diretrizes cognitivas perenes, contratos arquiteturais e runbooks operacionais. Não devem conter listas voláteis de tarefas de sprint.

### Os 4 Vetores Invariantes de Qualidade & Arquitetura:

Ao auditar ou conceber novas evoluções no ecossistema (seja ao refinar o `TODO.md` ou durante a codificação), o agente deve assegurar aderência a quatro vetores perpétuos:

1. **Modularização Atômica & Idempotência (Infraestrutura):** Todo script ou receita de provisionamento (`Setup`) deve ser estritamente atômico, isolado por ferramenta ou serviço, reexecutável sem efeitos colaterais e escrito em POSIX `/bin/sh` estrito.
2. **Detecção Sensorial Dinâmica de Display & Runtime (Editores):** As ferramentas e editores (`Emacs`, `Helix`, `NeoVim`, `Vim`) devem descobrir ativamente as capacidades do host (Wayland, X11, DirectWrite, compilação nativa, aceleradores de renderização) em tempo de voo, garantindo degradação graciosa e inicialização limpa.
3. **Paridade Multiplataforma & Governança Declarativa (Dotfiles & Terminais):** As configurações de usuário (`Profile`) mantêm paridade funcional, ergonômica e visual entre ambientes UNIX (Linux, BSDs, macOS) e Windows (PowerShell, NuShell, CMD/Clink), padronizando comandos de atualização e emissão de terminal (`_ui_*`).
4. **Invariante de Clonagem "Out-of-the-Box" (Zero-Tweaks Git Invariant):** Zero intervenção manual pós-clone (`chmod`, criação de diretórios órfãos, ajustes manuais de PATH). Modos octais canônicos mantidos no Git Index e rotinas defensivas de auto-cura para assegurar operabilidade imediata sob qualquer filesystem.

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
