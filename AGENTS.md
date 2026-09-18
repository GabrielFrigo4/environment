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

## 📦 Os Repositórios Federados

### 🏛️ O Quarteto de Infraestrutura (Core)

| Repo                    | Visibilidade | Papel                                                 | Mecanismo no Environment      |
| :---------------------- | :----------- | :---------------------------------------------------- | :---------------------------- |
| **[Setup](Setup/)**     | Público      | Provisionamento de SO com privilégios (`sudo`/`doas`) | Git Submodule                 |
| **[Shell](Shell/)**     | Público      | Motor interativo de terminal, prompts < 64ms          | Git Submodule                 |
| **[Vault](Vault/)**     | **Privado**  | Cofre criptográfico de segredos e chaves SSH          | Clone privado (`.gitignored`) |
| **[Profile](Profile/)** | Público      | Dotfiles declarativos, editores, skills de IA         | Git Submodule                 |

### 📝 A Suíte de Editores (Tools)

| Repo                         | Visibilidade | Papel                                                    | Mecanismo no Environment |
| :--------------------------- | :----------- | :------------------------------------------------------- | :----------------------- |
| **[Emacs](Editor/Emacs/)**   | Público      | Ambiente extensível Elisp, Org-mode, EAF e IA            | Git Submodule            |
| **[Helix](Editor/Helix/)**   | Público      | Editor modal pós-moderno em Rust com LSP nativo          | Git Submodule            |
| **[NeoVim](Editor/NeoVim/)** | Público      | Editor modal em Lua, FHS, Lazy.nvim, Mason LSP, Kanagawa | Git Submodule            |
| **[Vim](Editor/Vim/)**       | Público      | Editor clássico UNIX, Vim-Plug e tema CodeDark           | Git Submodule            |

---

## ⚠️ Regras Críticas para Agentes de IA

1. **Cada repo é independente:** Ao editar código de um sub-repo (Setup, Shell, Vault, Profile), você está operando dentro daquele repositório Git. Commits e branches são do sub-repo, não do Environment.
2. **Documentação canônica aqui:** O `ENVIRONMENT.md` e `PRINCIPLES.md` **nesta raiz** são as versões autoritativas. Os sub-repos contêm cópias que referenciam estas.
3. **Vault é privado:** NUNCA mencione conteúdos específicos do Vault em commits públicos do Environment.
4. **Makefile é o orquestrador:** Operações globais (`make pull`, `make status`, `make audit`, `make install`) devem ser executadas a partir da raiz do Environment.
5. **Hermetismo de Produção & Invariante `rm -rf .agents`:** O ecossistema é 100% soberano e independente de ferramentas de IA. É estritamente proibido criar dependências em código de produção (scripts executáveis, Makefiles, hooks, dotfiles, loaders, aliases) para arquivos em `.agents/` ou `skills/`. Se o diretório `.agents/` for sumariamente deletado (`rm -rf .agents`), 100% do repositório deve continuar funcionando com perfeição.
6. **Bancada de Desenvolvimento vs. Runtimes de Produção:** O repositório **Environment** (`~/Documents/Environment`) é **exclusivamente uma bancada de desenvolvimento e orquestração**. Absolutamente **NADA** residente no diretório do Environment deve ser usado diretamente pelo sistema operacional hospedeiro. Em produção, cada ferramenta opera soberanamente em sua localização canônica (`Shell` em `/usr/local/share/shell` ou `~/.local/share/shell`, `Profile` em `~/.config/profile`, `Vault` em `~/.vault`, `Emacs` em `~/.emacs.d`, `NeoVim` em `~/.config/nvim`, etc.). É expressamente proibido criar symlinks de dotfiles ou configurações de shell que apontem para o clone do Environment. A instalação e provisionamento no SO devem ser executados via `make install` (que clona cada repositório em seu destino nativo).

---

## 🛡️ Regra da Proatividade e Correção Contínua (Boy Scout Rule)

O agente de IA **DEVE SER ATIVAMENTE PROATIVO** na manutenção e aplicação dos padrões canônicos deste repositório.

Se durante a execução de qualquer tarefa (seja criação de novas features, correções pontuais, refatorações ou investigação) o agente identificar qualquer linha de código, script, Makefile ou documentação fora dos padrões estabelecidos, **NÃO DEVE HESITAR NEM IGNORAR**:

1. **Notificar concisamente** o usuário sobre a divergência encontrada.
2. **Corrigir imediatamente a inconformidade**, aplicando o padrão canônico correspondente:
    - **Comentários Narrativos:** Eliminar imediatamente comentários óbvios que apenas narram código executável.
    - **Banners Estruturais:** Ajustar réguas para exatamente 64 hífens no topo ou 32 caracteres com `### ` no corpo.
    - **Portabilidade POSIX:** Substituir bashismos (`[[ ]]`, `&>`, arrays, `source`) por sintaxe estrita POSIX `/bin/sh`.
    - **Shebang Universal:** Garantir sempre `#!/usr/bin/env sh` ou `#!/usr/bin/env python3`.
    - **Sequências ANSI:** Substituir octais crípticos (` `) e `printf` desnecessário por `[ -t 1 ] && echo -n $'\e...'`.
    - **Redirecionamento Seguro:** Envolver destinos em aspas duplas (ex: `> "/dev/null" 2>&1`).
    - **Makefiles:** Assegurar cabeçalho `.POSIX: .SILENT:`, `MAKEFLAGS += --no-print-directory -s`, alinhamento estético de variáveis e zero `@` redundante.
    - **Permissões Canônicas:** Aplicar 4 dígitos octais (`chmod 0755`, `chmod 0644`, `chmod 0700`, `chmod 0600`).
    - **Curadoria Cognitiva:** Capturar decisões estruturais e regras tácitas em skills locais compactas (`.agents/skills/`), mantendo-as atualizadas e expurgando runbooks obsoletos para evitar débito cognitivo, preservando sempre o hermetismo de produção (`rm -rf .agents`).

## 📖 Referências Obrigatórias

Antes de qualquer modificação neste ecossistema, consulte:

- **[ENVIRONMENT.md](ENVIRONMENT.md)**: Arquitetura federada, matriz de responsabilidades e ciclo de boot
- **[PRINCIPLES.md](PRINCIPLES.md)**: Os 21 Princípios de Engenharia UNIX + Clean Code
- **[.agents/rules/principles.md](.agents/rules/principles.md)**: Regras específicas do Environment
- **[.agents/skills/](.agents/skills/)**: Runbooks operacionais para o hub
