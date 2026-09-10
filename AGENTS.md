# 🏛️ Universal Environment — AI Agent Briefing

> Este é o **repositório hub** do **Quarteto de Produtividade** de Gabriel Frigo. Ele orquestra 4 repositórios independentes que, juntos, provisionam, personalizam e operam estações de trabalho em Linux, FreeBSD e Windows.

---

## 🧭 Identidade e Papel

O **Environment** é o **orquestrador e ponto de entrada** do ecossistema. Ele **NÃO** contém código executável de produção — esse papel pertence aos 4 sub-repositórios. O Environment contém:

- **Makefile global** para operações simultâneas nos 4 repos
- **Documentação canônica** (`ENVIRONMENT.md`, `PRINCIPLES.md`) — fonte da verdade do ecossistema
- **Submódulos Git** para os 3 repos públicos (`Setup`, `Shell`, `Profile`)
- **Clone privado** do `Vault` (ignorado pelo `.gitignore`)

---

## 📦 Os 4 Repositórios Federados

| Repo | Visibilidade | Papel | Mecanismo no Environment |
|:--|:--|:--|:--|
| **[Setup](Setup/)** | Público | Provisionamento de SO com privilégios (`sudo`/`doas`) | Git Submodule |
| **[Shell](Shell/)** | Público | Motor interativo de terminal, prompts < 50ms | Git Submodule |
| **[Vault](Vault/)** | **Privado** | Cofre criptográfico de segredos e chaves SSH | Clone privado (`.gitignored`) |
| **[Profile](Profile/)** | Público | Dotfiles declarativos, editores, skills de IA | Git Submodule |

---

## ⚠️ Regras Críticas para Agentes de IA

1. **Cada repo é independente:** Ao editar código de um sub-repo (Setup, Shell, Vault, Profile), você está operando dentro daquele repositório Git. Commits e branches são do sub-repo, não do Environment.
2. **Documentação canônica aqui:** O `ENVIRONMENT.md` e `PRINCIPLES.md` **nesta raiz** são as versões autoritativas. Os sub-repos contêm cópias que referenciam estas.
3. **Vault é privado:** NUNCA mencione conteúdos específicos do Vault em commits públicos do Environment.
4. **Makefile é o orquestrador:** Operações globais (`make pull`, `make status`, `make audit`) devem ser executadas a partir da raiz do Environment.

---

## 📖 Referências Obrigatórias

Antes de qualquer modificação neste ecossistema, consulte:

- **[ENVIRONMENT.md](ENVIRONMENT.md)**: Arquitetura federada, matriz de responsabilidades e ciclo de boot
- **[PRINCIPLES.md](PRINCIPLES.md)**: Os 18 Princípios de Engenharia UNIX + Clean Code
- **[.agents/rules/principles.md](.agents/rules/principles.md)**: Regras específicas do Environment
- **[.agents/skills/](.agents/skills/)**: Runbooks operacionais para o hub
