# 🚀 {{PROJECT_NAME}}

> {{PROJECT_DESCRIPTION}}

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](#)
[![POSIX Compatible](https://img.shields.io/badge/POSIX-Compatible-success.svg)](#)
[![Status: Development](https://img.shields.io/badge/Status-Development-orange.svg)](#)

---

## 📖 Visão Geral

O **{{PROJECT_NAME}}** é projetado sob os 22 princípios soberanos de engenharia, priorizando modularidade, clareza, ausência de complexidade acidental e independência de infraestruturas proprietárias.

### 🌟 Destaques de Arquitetura

- **Simplicidade Inerente:** Zero dependências desnecessárias; foco em código autoexplicativo e manutenível.
- **Autonomia & Soberania:** O repositório é completamente autocontido e desacoplado.
- **Quality Gates Nativos:** Ganchos de pré-commit e validação semântica em POSIX `/bin/sh` puro.
- **Orquestração Padronizada:** Interface unificada e previsível através de `Makefile` POSIX silencioso.

---

## ⚡ Início Rápido

### Pré-requisitos

- Compilador ou runtime compatível com a stack do projeto.
- Shell compatível com POSIX (`/bin/sh`, `dash`, `bash`, `zsh`).
- Git (versão $\ge 2.20$).
- [Prettier](https://prettier.io/) (opcional, para formatação de Markdown e configs).

### Primeiros Passos

```sh
# 1. Instalar os ganchos locais do Git
make hooks

# 2. Consultar o catálogo interativo de comandos
make help

# 3. Compilar o projeto
make build

# 4. Executar os testes
make test

# 5. Executar a suíte completa de validação local
make ci
```

---

## 🛠️ Catálogo de Comandos do Makefile

O projeto adota a interface de comando padronizada do ecossistema:

```text
    make help                   Exibe o catálogo de comandos disponíveis
    make build                  Compila os artefatos em bin/ ou dist/
    make dev                    Executa a aplicação em modo interativo
    make check                  Valida sintaxe e tipos estaticamente
    make test                   Executa a suíte de testes automatizados
    make format                 Formata o código e documentação
    make prettier               Formata documentações Markdown com Prettier
    make lint                   Valida padrões de código sem alterar arquivos
    make hooks                  Configura e aplica permissões em .githooks/
    make ci                     Executa pipeline completa de validação local
    make clean                  Remove artefatos de build e arquivos temporários
```

---

## 🗂️ Estrutura do Repositório

```text
.
├── .agents/                    # Governança local e regras de agentes de IA
│   └── rules/                  # Regras canônicas (clean-code, principles)
├── .githooks/                  # Ganchos Git locais (pre-commit, commit-msg)
├── .github/                    # Automações e workflows remotos do GitHub Actions
├── docs/                       # Documentação técnica detalhada
├── src/                        # Código-fonte principal da aplicação
├── AGENTS.md                   # Constituição e instruções para agentes de IA
├── CONTRIBUTING.md             # Guia de desenvolvimento e convenções locais
├── Makefile                    # Orquestrador POSIX silencioso e catálogo de tarefas
├── PRINCIPLES.md               # Os 22 Princípios de Engenharia Soberanos
├── README.md                   # Este portal de introdução e guia rápido
├── TODO.md                     # Roadmap de tarefas e itens em aberto
└── VERSION                     # Versão semântica canônica do projeto
```

---

## 📜 Governança & Licença

Este projeto segue as convenções e princípios definidos em [PRINCIPLES.md](PRINCIPLES.md) e [AGENTS.md](AGENTS.md).

Distribuído sob licença aberta [MIT](LICENSE).
