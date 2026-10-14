# 🤖 Agent 5: Otimização & Alinhamento da Suíte de Editores Modais (NeoVim, Helix, Vim)

> **Plano Operacional Especializado — Editores Modais & Performance**
> ⚡ **Execução:** Autônomo (**Gemini Flash 3.x** / Pro)
> **Referência Obrigatória Prévia:** Leia atentamente o [`all_agents.md`](all_agents.md).

---

## 🎯 1. Objetivo Central da Missão

Otimizar a performance de inicialização, refinar a cobertura de language servers e aprimorar a ergonomia dos três editores modais do ecossistema: **NeoVim** (Lua FHS com Lazy e Mason), **Helix** (Rust modal pós-moderno) e **Vim Clássico** (UNIX puro e resiliente).

---

## 🗺️ 2. Topografia de Arquivos a Explorar

1. **Universal NeoVim (`Editor/NeoVim/`):**
    - [`Editor/NeoVim/init.lua`](file:///home/gabrielf/Documents/Environment/Editor/NeoVim/init.lua): Entrypoint modular FHS.
    - `Editor/NeoVim/lua/lib/`: Módulos de infraestrutura e utilitários protegidos por `pcall`.
    - `Editor/NeoVim/lua/etc/`: Configurações de opções, keymaps e autocommands.
    - `Editor/NeoVim/lua/opt/`: Plugins gerenciados via Lazy.nvim (`lazy.lua`, `mason.lua`, `treesitter.lua`, `kanagawa.lua`).
2. **Universal Helix (`Editor/Helix/`):**
    - [`Editor/Helix/config.toml`](file:///home/gabrielf/Documents/Environment/Editor/Helix/config.toml): Configuração de ergonomia modal, tema e cursores.
    - [`Editor/Helix/languages.toml`](file:///home/gabrielf/Documents/Environment/Editor/Helix/languages.toml): Language servers, formatadores e diagnósticos.
3. **Universal Vim (`Editor/Vim/`):**
    - [`Editor/Vim/vimrc`](file:///home/gabrielf/Documents/Environment/Editor/Vim/vimrc): Configuração clássica resiliente e plugins Vim-Plug.

---

## 📋 3. Roteiro Metódico de Execução (Passo a Passo)

### Fase 1: Universal NeoVim — Startup < 25ms & Mason

- [x] Implementar medição contínua de inicialização:
    ```sh
    nvim --headless --startuptime /tmp/nvim-bench.log +qa
    ```
- [x] Otimizar o lazy-loading de plugins em `lua/opt/`: Carregar sintaxe e realce de Treesitter apenas em eventos `BufReadPost` ou `BufNewFile`.
- [x] Expandir receitas do Mason LSP em `lua/opt/mason.lua`:
    - C23: `clangd`
    - Rust: `rust-analyzer`
    - Go: `gopls`
    - Lua: `lua-language-server`
    - Shell POSIX: `shellcheck` e `shfmt`
- [x] Garantir que em consoles TTY puros o tema Kanagawa faça fallback elegante sem artefatos visuais.

### Fase 2: Universal Helix — Keymaps & Language Servers

- [x] Refinar atalhos em `config.toml` para troca rápida de buffers (`gn`, `gp`) e navegação ágil entre splits de janela.
- [x] Expandir configurações em `languages.toml`:
    - Adicionar suporte e formatação automática para C23 via `clangd`.
    - Adicionar suporte a Typst (`tinymist`), Nix (`nil`) e Shell POSIX (`shfmt`).
- [x] Validar integridade sintática dos arquivos TOML via linters no `make test`.

### Fase 3: Universal Vim — Resiliência TTY & FZF

- [x] Otimizar `vimrc` para conexões remotas via SSH e consoles físicos: suprimir carregamento pesado de plugins visuais quando detectado console puro.
- [x] Refinar integração do FZF para navegação rápida de arquivos em repositórios com muitos submódulos.

### Fase 4: Validação Headless em CI

- [x] Executar validações individuais:
    - `make -C Editor/NeoVim test`
    - `make -C Editor/Helix test`
    - `make -C Editor/Vim test`
- [x] Garantir 100% de sucesso sem warnings residuais.

---

## ⚠️ 4. Invariantes Críticas & Gotchas

1. **Fail-Safe Startup:** O NeoVim e o Vim devem inicializar limpos e sem erro mesmo que a internet esteja offline ou os plugins ainda não tenham sido clonados.
2. **Arquitetura FHS no NeoVim:** Proibido espalhar scripts fora da hierarquia modular `lua/lib/`, `lua/etc/` e `lua/opt/`.
3. **Pureza de TOML no Helix:** Não inclua chaves não suportadas pela versão estável do Helix.
