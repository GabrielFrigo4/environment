# 🏛️ Universal Environment

> Hub orquestrador do **Quarteto de Produtividade** — ponto de entrada unificado para provisionamento, personalização e operação de estações de trabalho em Linux, FreeBSD e Windows.

---

### 🏛️ O Quarteto de Produtividade

[![Setup](https://img.shields.io/badge/📦_Setup-Sistema_%26_Cookbook-blue)](https://github.com/GabrielFrigo4/setup)
[![Shell](https://img.shields.io/badge/🐚_Shell-Terminal_Runtime-purple)](https://github.com/GabrielFrigo4/shell)
[![Vault](https://img.shields.io/badge/🔐_Vault-Cofre_Privado-red)](https://github.com/GabrielFrigo4/vault)
[![Profile](https://img.shields.io/badge/🎨_Profile-Dotfiles_%26_IA-green)](https://github.com/GabrielFrigo4/profile)

> 📖 **Arquitetura Unificada do Ecossistema:** Conheça a matriz completa de responsabilidades, ciclo de boot e segregação de privilégios em [ENVIRONMENT.md](ENVIRONMENT.md).
> 📜 **Princípios de Engenharia:** Conheça os 18 princípios UNIX e boas práticas Clean Code em [PRINCIPLES.md](PRINCIPLES.md).

---

## 🧠 O que é o Environment?

O **Environment** é o **repositório raiz** que centraliza e orquestra os 4 componentes do Quarteto de Produtividade. Ele não é um monorepo — cada componente mantém seu próprio repositório Git independente. O Environment funciona como:

1. **Ponto de Entrada Único:** Clone este repositório e tenha acesso imediato a todo o ecossistema via `make clone`.
2. **Orquestrador de Operações:** Comandos globais (`make status`, `make pull`, `make audit`, `make ci`) operam simultaneamente nos 4 repos.
3. **Fonte Canônica de Documentação:** O [ENVIRONMENT.md](ENVIRONMENT.md) e [PRINCIPLES.md](PRINCIPLES.md) nesta raiz são as versões autoritativas do ecossistema.

```mermaid
flowchart TD
    subgraph ENV ["🏛️ Environment (Hub Orquestrador)"]
        MK["⚙️ Makefile Global"]
        DOC["📖 ENVIRONMENT.md & PRINCIPLES.md"]
    end

    subgraph REPOS ["📦 Repositórios Federados"]
        SETUP["📦 Setup (Submodule Público)"]
        SHELL["🐚 Shell (Submodule Público)"]
        VAULT["🔐 Vault (Clone Privado)"]
        PROFILE["🎨 Profile (Submodule Público)"]
    end

    ENV --> SETUP
    ENV --> SHELL
    ENV --> VAULT
    ENV --> PROFILE
    MK -->|"make clone / pull / status"| REPOS
```

---

## 📋 Arquitetura Híbrida (Submodules + Clone Privado)

| Repositório | Tipo | Visibilidade | Mecanismo |
|:--|:--|:--|:--|
| **[Setup](https://github.com/GabrielFrigo4/setup)** | Git Submodule | 🟢 Público | `git submodule update --init` |
| **[Shell](https://github.com/GabrielFrigo4/shell)** | Git Submodule | 🟢 Público | `git submodule update --init` |
| **[Profile](https://github.com/GabrielFrigo4/profile)** | Git Submodule | 🟢 Público | `git submodule update --init` |
| **[Vault](https://github.com/GabrielFrigo4/vault)** | Clone Privado | 🔴 Privado | `git clone` via SSH (requer chave autorizada) |

> 💡 **Setup**, **Shell** e **Profile** são submódulos públicos acessíveis a qualquer visitante. O **Vault** é um repositório privado clonado separadamente — visitantes sem acesso receberão um aviso amigável sem interromper a operação.

---

## 🚀 Instalação Rápida

### 📥 Clone Completo (com Submódulos)

```sh
git clone --recurse-submodules "https://github.com/GabrielFrigo4/environment"
cd environment
make clone
```

O `git clone --recurse-submodules` traz automaticamente os 3 repos públicos. O `make clone` tenta clonar o Vault via SSH (falha silenciosamente se não autorizado).

### 🔄 Atualizar Tudo

```sh
make pull
```

---

## ⚙️ Comandos do Makefile

| Comando | Ação |
|:--|:--|
| `make clone` | Inicializa submódulos públicos e clona o Vault (defensivo) |
| `make hooks` | Configura `.githooks` executáveis em todos os repos |
| `make status` | Exibe status Git resumido dos 4 repositórios |
| `make pull` | Atualiza submódulos e puxa todos os repos |
| `make audit` | Executa suites de auditoria estática e validação |
| `make format` | Formata todos os arquivos Markdown com Prettier |
| `make lint-md` | Valida formatação de Markdown com Prettier |
| `make sync` | Sincroniza dotfiles e skills de IA no sistema |
| `make bench` | Mede latência de inicialização de shells e módulos |
| `make test` | Valida sintaxe POSIX e Zsh em todos os scripts |
| `make ci` | Executa auditoria completa e quality gates locais |
| `make doctor` | Executa diagnóstico pós-boot do sistema |

---

## 📂 Estrutura do Repositório

```text
Environment/
├── Setup/          ← Submodule público (provisionamento de SO)
├── Shell/          ← Submodule público (motor de terminal)
├── Profile/        ← Submodule público (dotfiles & IA)
├── Vault/          ← Clone privado (segredos, .gitignored)
├── Makefile        ← Orquestrador global de operações
├── ENVIRONMENT.md  ← Manifesto canônico de arquitetura
├── PRINCIPLES.md   ← 18 Princípios de Engenharia
├── AGENTS.md       ← Briefing para agentes de IA
├── LICENSE         ← MIT License
└── .agents/        ← Skills e regras para IAs
```

---

## 🔗 Documentação Canônica

- 🏛️ **[ENVIRONMENT.md](ENVIRONMENT.md)**: Arquitetura federada, matriz de responsabilidades e ciclo de boot.
- 📜 **[PRINCIPLES.md](PRINCIPLES.md)**: Os 18 Princípios de Engenharia e Clean Code do ecossistema.
- 🤖 **[AGENTS.md](AGENTS.md)**: Guia de contexto para agentes de IA (Antigravity, Claude, GPT).
