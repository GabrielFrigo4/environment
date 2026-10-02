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
5. **Hermetismo de Produção & Invariante `rm -rf .agents`:** O ecossistema é 100% soberano e independente de ferramentas de IA. Código de produção (scripts, Makefiles, hooks, dotfiles, loaders) não deve depender de arquivos em `.agents/` ou `skills/`. Se o diretório `.agents/` for deletado (`rm -rf .agents`), o repositório continua operando com 100% de integridade.
6. **Bancada de Desenvolvimento vs. Runtimes de Produção:** O repositório **Environment** (`~/Documents/Environment`) é **exclusivamente uma bancada de desenvolvimento e orquestração**. Nenhum artefato no diretório do Environment deve ser consumido diretamente pelo sistema operacional hospedeiro. Em produção, cada ferramenta opera soberanamente em sua localização canônica (`Shell` em `/usr/local/share/shell` ou `~/.local/share/shell`, `Profile` em `~/.config/profile`, `Vault` em `~/.local/share/vault`, `Emacs` em `~/.emacs.d`, `NeoVim` em `~/.config/nvim`, etc.). Não crie symlinks de dotfiles que apontem para o Environment. A instalação deve ser feita via `make install`.
7. **Invariante de Clonagem "Out-of-the-Box" (Zero-Tweaks Git Invariant):** O ecossistema deve funcionar imediatamente após `git clone`, sem etapas manuais pós-clone (como `chmod +x` manual). Permissões octais canônicas devem estar registradas no Git Index (`0755` para executáveis/scripts/hooks, `0644` para arquivos de configuração e documentação, `0700`/`0600` no Vault). Scripts devem aplicar self-healing de permissões se clonados sob filesystems que não preservam bits POSIX.
8. **Padrão Universal de Emissão de UI (`_ui_*`):** Saídas interativas de status ou etapas no Shell (UNIX) e perfis de terminal do Profile (Windows) devem utilizar a biblioteca semântica `_ui_*` (`_ui_step`, `_ui_sub`, `_ui_ok`, `_ui_warn`, `_ui_err`, `_ui_info`, `_ui_banner`). Não use `echo` ad-hoc com emojis sem formatação padronizada.
9. **Governança de Roadmap & Status:** Cada repositório mantém seu [TODO.md](TODO.md) canônico com matriz de cobertura e backlog.
10. **Matriz de Shells Suportada:** A automação e scripts visam a matriz: `zsh`, `bash`, FreeBSD `sh` e OpenBSD `ksh`. Interpretadores restritos de recuperação (Debian `dash`, NetBSD `sh`) estão fora de escopo.
11. **Ciclo de Propagação (Bancada -> Git Push -> Git Pull em Produção):**
    - Edição na bancada: alterações são implementadas e testadas sob `~/Documents/Environment/<Componente>`.
    - Envio: commits e pushes ocorrem na bancada.
    - Atualização em produção: os clones de produção recebem atualizações via `git pull`. Não utilize `cp` avulso que deixe working trees sujas em produção.
    - Edição em runtime: somente é admitida se o componente não existir no Environment e você não estiver nele.
12. **Refatoração Sem Legado (Clean-Break / Zero-Cruft Invariant):** O ecossistema é monousuário soberano. Não mantenha shims temporários, wrappers obsoletos ou aliases de transição ao renomear variáveis, comandos ou caminhos. Toda refatoração deve ser direta, atômica e limpa (_clean break_).

---

## 🛡️ Regra da Proatividade e Correção Contínua (Boy Scout Rule)

O agente de IA atua de forma proativa na manutenção e aplicação dos padrões canônicos deste repositório.

Ao identificar linhas ou artefatos fora dos padrões estabelecidos:

1. **Notificar concisamente** o usuário sobre o ajuste realizado.
2. **Corrigir a inconformidade**, aplicando o padrão correspondente:
    - **Comentários Narrativos:** Eliminar comentários óbvios que apenas narram código executável.
    - **Banners Estruturais:** Ajustar réguas para exatamente 64 hífens no topo ou 32 caracteres com `### ` no corpo.
    - **Portabilidade POSIX:** Substituir bashismos (`[[ ]]`, `&>`, arrays, `source`) por sintaxe estrita POSIX `/bin/sh`.
    - **Shebang Universal:** Garantir sempre `#!/usr/bin/env sh` ou `#!/usr/bin/env python3`.
    - **Sequências ANSI & Escapes:** Não use octais (`\033`, `\001`) para caracteres ou escapes. Use `[ -t 1 ] && echo -n $'\e...'` ou notação hexadecimal (`\x01`, `\x1b`). Octal é exclusivo para permissões POSIX (`chmod 0755`, `chmod 0644`, `umask`).
    - **Redirecionamento Seguro:** Envolver destinos em aspas duplas (ex: `> "/dev/null" 2>&1`).
    - **Makefiles:** Assegurar cabeçalho `.POSIX: .SILENT:`, `MAKEFLAGS += --no-print-directory -s`, alinhamento estético de variáveis e zero `@` redundante.
    - **Permissões Canônicas:** Aplicar 4 dígitos octais (`chmod 0755`, `chmod 0644`, `chmod 0700`, `chmod 0600`).
    - **Invariante Out-of-the-Box:** Garantir modos octais corretos no Git Index e auto-cura em tempo de execução sem requerer intervenção manual pós-clone.
    - **Emissão Semântica de UI:** Substituir `echo` avulsos com emojis pelas rotinas canônicas `_ui_*`.
    - **Antifragilidade & Resiliência:** Resolução ativa de caminhos em cascata, auto-cura de permissões (0600 em chaves/segredos) e validação defensiva de pré-requisitos.
    - **Curadoria Cognitiva:** Capturar decisões estruturais e regras tácitas em skills locais compactas (`.agents/skills/`), mantendo-as atualizadas e expurgando ruído obsoleto.
    - **Refatoração Sem Legado:** Expurgar aliases obsoletos, variáveis mortas e shims de compatibilidade em renomeações.

## 📖 Referências Obrigatórias

Antes de qualquer modificação neste ecossistema, consulte:

- **[ENVIRONMENT.md](ENVIRONMENT.md)**: Arquitetura federada, matriz de responsabilidades e ciclo de boot
- **[PRINCIPLES.md](PRINCIPLES.md)**: Os 22 Princípios de Engenharia UNIX + Clean Code
- **[TODO.md](TODO.md)**: Planejamento estratégico e matriz de status operacional
- **[.agents/rules/principles.md](.agents/rules/principles.md)**: Regras específicas do Environment
- **[.agents/skills/](.agents/skills/)**: Runbooks operacionais para o hub
