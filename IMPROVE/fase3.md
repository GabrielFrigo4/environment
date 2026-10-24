# ----------------------------------------------------------------

# Plano de Execução: Fase 3 — Editores Modais (FreeBSD TTY & Ergonomia)

# ----------------------------------------------------------------

### ================================

### 1. OBJETIVO DA FASE

### ================================

Corrigir o comportamento de mouse no console TTY do FreeBSD para Vim e NeoVim
através do protocolo SGR (1006), implementar a alteração de cor do cursor em
bloco por modo no TTY (replicando o comportamento estético do Helix) e sincronizar
a paleta de 16 cores e mapeamentos dos terminais embutidos (`:terminal`).

### ================================

### 2. ARQUIVOS ALVO

### ================================

| Arquivo                              | Componente | Ação                                                                                                        |
| :----------------------------------- | :--------- | :---------------------------------------------------------------------------------------------------------- |
| `Editor/Vim/vimrc`                   | Vim        | Forçar mouse SGR no console FreeBSD, cursor colorido no TTY e configurar `g:terminal_ansi_colors`           |
| `Editor/NeoVim/lua/etc/options.lua`  | NeoVim     | Definir array de 16 cores `terminal_color_*` sincronizado com foot/TTY                                      |
| `Editor/NeoVim/lua/etc/autocmds.lua` | NeoVim     | Emissão forçada de sequências SGR (`\e[?1000h\e[?1006h`) e cursor em bloco colorido por modo no FreeBSD TTY |
| `Editor/NeoVim/lua/etc/keymaps.lua`  | NeoVim     | Mapeamento `Esc` / `C-\ C-n` no modo terminal e ocultação de `number`/`signcolumn` em buffers `term://`     |

### ================================

### 3. CONTRATOS TÉCNICOS

### ================================

- **Mouse no FreeBSD Raw TTY:**
    - O console do FreeBSD com `moused` ativado aceita eventos SGR, mas NeoVim e Vim só escutam se ativados explicitamente via sequências de controle na inicialização (`VimEnter`).
    - No Vim: `if has('mouse_sgr') | set ttymouse=sgr | endif` associado ao envio explícito de `&t_TI` / `&t_TE`.
- **Cursor em Bloco Colorido no TTY:**
    - Como o console `vt(4)` do FreeBSD não suporta variação de forma física do cursor (`DECSCUSR`), os editores devem alterar a cor do caractere/bloco sob o cursor ou a cor do texto conforme o modo (Normal = Branco/Azul, Insert = Verde, Visual = Amarelo/Laranja).
- **Sincronia ANSI 16 Cores:**
    - `g:terminal_ansi_colors` (Vim) e `terminal_color_0..15` (NeoVim) devem espelhar rigorosamente as 16 cores canônicas do tema do terminal.

### ================================

### 4. CRITÉRIOS DE ACEITE

### ================================

- [x] Inicialização limpa headless de Vim (`vim -es -u vimrc -c 'q'`) e NeoVim (`nvim --headless +q`).
- [x] Testes de conformidade e sintaxe Lua/Vimscript aprovados em `Editor/Vim` e `Editor/NeoVim`.
- [x] Commits semânticos atômicos em `Editor/Vim` (`451af0e`) e `Editor/NeoVim` (`2e9dedc`).
