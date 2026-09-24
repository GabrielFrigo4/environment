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
6. **Bancada de Desenvolvimento vs. Runtimes de Produção:** O repositório **Environment** (`~/Documents/Environment`) é **exclusivamente uma bancada de desenvolvimento e orquestração**. Absolutamente **NADA** residente no diretório do Environment deve ser usado diretamente pelo sistema operacional hospedeiro. Em produção, cada ferramenta opera soberanamente em sua localização canônica (`Shell` em `/usr/local/share/shell` ou `~/.local/share/shell`, `Profile` em `~/.config/profile`, `Vault` em `~/.local/share/vault` (ou `~/.vault`), `Emacs` em `~/.emacs.d`, `NeoVim` em `~/.config/nvim`, etc.). É expressamente proibido criar symlinks de dotfiles ou configurações de shell que apontem para o clone do Environment. A instalação e provisionamento no SO devem ser executados via `make install` (que clona cada repositório em seu destino nativo).
7. **Invariante de Clonagem "Out-of-the-Box" (Zero-Tweaks Git Invariant):** O ecossistema deve funcionar 100% imediatamente após um simples `git clone`. É proibido que qualquer repositório necessite de comandos manuais pós-clone (como `chmod +x`, criação manual de diretórios órfãos ou edição de caminhos). Permissões canônicas octais DEVEM estar registradas no Git Index (`0755` para executáveis/scripts/hooks, `0644` para arquivos de configuração e documentação, `0700`/`0600` no Vault). Scripts devem implementar rotinas defensivas de self-healing para re-aplicar permissões se clonados sob sistemas de arquivos que não preservam bits POSIX (NTFS/FAT32/WSL).
8. **Padrão Universal de Emissão de UI (`_ui_*`):** Toda saída interativa de status, progresso ou etapas no Shell (UNIX) e nos perfis de terminal do Profile (Windows: PowerShell, NuShell, CMD/Clink) DEVE utilizar a biblioteca semântica `_ui_*` (`_ui_step`, `_ui_sub`, `_ui_ok`, `_ui_warn`, `_ui_err`, `_ui_info`, `_ui_banner`). É expressamente proibido o uso de `echo` ad-hoc com emojis ou saídas soltas sem prefixo semântico padronizado.
9. **Governança de Roadmap & Status (Opção C):** Todo repositório do ecossistema mantém seu [TODO.md](TODO.md) canônico com a Matriz Detalhada de Status & Cobertura e o Backlog de Grandes Épicos, referenciado pelo badge `[![Roadmap](https://img.shields.io/badge/🗺️_Roadmap-TODO.md-teal)](TODO.md)` no `README.md`.
10. **A Regra Áurea da Fonte Canônica para Edição (Bancada vs. Clones de Runtime):** Toda e qualquer alteração de engenharia em qualquer componente do ecossistema (`Setup`, `Shell`, `Profile`, `Vault`, `Emacs`, `Helix`, `NeoVim`, `Vim`) DEVE ser realizada prioritariamente na bancada de desenvolvimento do **Environment** (geralmente em `~/Documents/Environment` ou `~/Documentos/Environment`).
    **Condição Estrita para Editar em Clones de Runtime:** Apenas se o repositório canônico no Environment **NÃO existir** E o agente **NÃO estiver nele** (ambas as condições estritamente negadas simultaneamente) é que se admite editar diretamente nos clones de runtime (`~/.local/share/profile`, `~/.emacs.d`, `~/.config/nvim`, etc.). Isso previne sujar árvores de trabalho de runtime (`unstaged changes`), preserva o fluxo de atualização automática (`uped`, `uprc`, `git pull --ff-only`) e garante que os commits sejam integrados na fonte da verdade.

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
    - **Sequências ANSI:** Substituir octais crípticos (`\033`) e `printf` desnecessário por `[ -t 1 ] && echo -n $'\e...'`.
    - **Redirecionamento Seguro:** Envolver destinos em aspas duplas (ex: `> "/dev/null" 2>&1`).
    - **Makefiles:** Assegurar cabeçalho `.POSIX: .SILENT:`, `MAKEFLAGS += --no-print-directory -s`, alinhamento estético de variáveis e zero `@` redundante.
    - **Permissões Canônicas:** Aplicar 4 dígitos octais (`chmod 0755`, `chmod 0644`, `chmod 0700`, `chmod 0600`).
    - **Invariante Out-of-the-Box:** Garantir modos octais corretos no Git Index e auto-cura em tempo de execução sem requerer intervenção manual pós-clone.
    - **Emissão Semântica de UI:** Substituir imediatamente `echo` avulsos com emojis ou texto ad-hoc pelas rotinas canônicas `_ui_*`.
    - **Antifragilidade & Resiliência:** Garantir resolução ativa de caminhos em cascata, auto-cura de permissões (0600 em chaves/segredos) e zero suposições cegas de arquivos estáticos.
    - **Curadoria Cognitiva:** Capturar decisões estruturais e regras tácitas em skills locais compactas (`.agents/skills/`), mantendo-as atualizadas e expurgando runbooks obsoletos para evitar débito cognitivo, preservando sempre o hermetismo de produção (`rm -rf .agents`).

## 📖 Referências Obrigatórias

Antes de qualquer modificação neste ecossistema, consulte:

- **[ENVIRONMENT.md](ENVIRONMENT.md)**: Arquitetura federada, matriz de responsabilidades e ciclo de boot
- **[PRINCIPLES.md](PRINCIPLES.md)**: Os 22 Princípios de Engenharia UNIX + Clean Code
- **[TODO.md](TODO.md)**: Planejamento estratégico e matriz de status operacional
- **[.agents/rules/principles.md](.agents/rules/principles.md)**: Regras específicas do Environment
- **[.agents/skills/](.agents/skills/)**: Runbooks operacionais para o hub
