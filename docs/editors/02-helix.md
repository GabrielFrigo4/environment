# 🧬 Helix Editor: Arquitetura em Rust, LSP Nativo & Ergonomia Modal

> Documentação canônica do Helix Editor no Universal Environment: configuração TOML, LSP nativo com zero plugins externos e o paradigma seleção $\rightarrow$ ação.

---

## 🧭 Visão Geral & Filosofia do Helix

O **Helix** é um editor de texto modal moderno de alta performance escrito integralmente em **Rust**. Ele foi concebido para resolver a principal fraqueza do ecossistema Vim/NeoVim: a dependência de dezenas de plugins de terceiros, gerenciadores de pacotes externos e ambientes NodeJS apenas para obter suporte a LSP e syntax highlighting.

No Universal Environment, o Helix destaca-se por:

1. **Zero Plugins Necessários:** O Helix incorpora nativamente um cliente LSP completo, analisador sintático Tree-sitter e seletor fuzzy (_picker_).
2. **Desempenho Instantâneo:** Tempo de inicialização inferior a 10 milissegundos com consumo de memória de apenas alguns megabytes.
3. **Paradigma Seleção $\rightarrow$ Ação:** Ao contrário do Vim (onde o usuário digita a ação antes do movimento, ex: `dw` para deletar palavra sem ver o que está selecionado), o Helix adota a abordagem do Kakoune: o usuário seleciona o texto visualmente primeiro (`w`), e em seguida aplica a transformação (`d`). Isso reduz drasticamente erros de edição às cegas.

---

## ⚙️ Configuração Declarativa: `config.toml`

A configuração do Helix reside em `~/.config/helix/config.toml`:

```toml
# ================================================================
# Helix Editor: Configuração Canônica
# ================================================================
theme = "kanagawa"

[editor]
line-number = "relative"
cursorline = true
scrolloff = 5
color-modes = true
bufferline = "multiple"

[editor.cursor-shape]
insert = "bar"
normal = "block"
select = "underline"

[editor.file-picker]
hidden = false
git-ignore = true

[editor.lsp]
display-messages = true
display-inlay-hints = true
```

---

## 🌐 Configuração de Linguagens: `languages.toml`

O mapeamento de Language Servers e formatters é definido em `~/.config/helix/languages.toml`:

```toml
# Exemplo: Suporte a Rust via rust-analyzer
[[language]]
name = "rust"
auto-format = true

# Exemplo: Suporte a POSIX Shell via bash-language-server e shfmt
[[language]]
name = "bash"
auto-format = true
formatter = { command = "shfmt", args = ["-i", "4", "-ci"] }
```

---

## 🧪 Diagnóstico de Saúde & Testes

Para validar se os Language Servers e gramáticas Tree-sitter estão instalados e operacionais:

```sh
# Inspecionar saúde geral de todas as linguagens suportadas
hx --health

# Checar saúde de uma linguagem específica
hx --health rust

# Executar suíte de testes do repositório
make -C Editor/Helix test
```
