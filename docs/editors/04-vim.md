# 🏛️ Vim Clássico: O Baluarte UNIX Soberano

> Documentação canônica do Vim Clássico no Universal Environment: Vimscript puro, resiliência em consoles virtuais TTY, tema CodeDark e zero dependências externas.

---

## 🧭 O Papel do Vim Clássico no Ecossistema

Enquanto Emacs e NeoVim oferecem ricas experiências integradas com extensões complexas, o **Vim Clássico** (`Editor/Vim`) ocupa o papel mais crítico da hierarquia de confiabilidade: ele é o **baluarte de recuperação e soberania UNIX**.

Quando um sistema operacional está em modo monousuário (_single-user recovery mode_), quando o servidor gráfico Wayland falha, ou quando estamos conectados via console serial de emergência sem runtime Lua ou Rust instalados:

1. **Zero Dependências:** O Vim opera sobre qualquer binário padrão de sistema (`/usr/bin/vim` ou `/usr/local/bin/vim`), sem exigir LuaJIT, NodeJS ou Python.
2. **Resiliência em TTYs:** O arquivo `.vimrc` degrada graciosamente em terminais com apenas 16 ou 256 cores, mantendo legibilidade e contraste perfeito.
3. **Boot Instantâneo:** Carrega em menos de 15 milissegundos.

---

## ⚙️ Estrutura do `.vimrc` Canônico

O arquivo de configuração do Vim no repositório `Editor/Vim` é autocontido e resiliente:

```vim
" ================================================================
" Vim Clássico: Configuração Canônica Soberana
" ================================================================
set nocompatible
filetype plugin indent on
syntax on

" 1. Desempenho e Latência de Teclas
set ttimeoutlen=50
set timeoutlen=500
set updatetime=300

" 2. Indentação e Edição Limpa
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" 3. Comportamento Visual e Numeração
set number
set relativenumber
set cursorline
set scrolloff=5
set laststatus=2
set showcmd
set wildmenu

" 4. Busca Antifrágil
set ignorecase
set smartcase
set incsearch
set hlsearch
```

---

## 🎨 Tema CodeDark & Degradação TUI

O tema **CodeDark** provê uma paleta de cores balanceada inspirada no VS Code Dark, com suporte nativo a cores verdadeiras (_True Color_) quando suportado pelo terminal, e degradação perfeita para paletas ANSI de 256 cores em consoles de texto puro:

```vim
" Ativação segura de True Color em terminais compatíveis
if (has("termguicolors"))
    set termguicolors
endif

" Fallback seguro de tema
silent! colorscheme codedark
```

---

## 🧪 Testes de Integridade (`make test`)

O repositório `Editor/Vim` valida o carregamento de configurações sem interatividade do usuário:

```sh
# Executar verificação batch do Vim
make -C Editor/Vim test
```

Esse comando inicia o Vim com as flags `-Nu .vimrc -c "q"`, assegurando que não existam erros de sintaxe ou comandos obsoletos no `.vimrc`.
