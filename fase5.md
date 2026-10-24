# ----------------------------------------------------------------

# Plano de Execução: Fase 5 — Quality Gates & Governança Hub

# ----------------------------------------------------------------

### ================================

### 1. OBJETIVO DA FASE

### ================================

Executar a suíte completa de quality gates em todo o ecossistema federado,
auditar linters, testes de inicialização e réguas de código, atualizar as
tabelas de status nos arquivos `TODO.md` e propagar a documentação canônica
a partir da raiz do `Environment`.

### ================================

### 2. ARQUIVOS ALVO

### ================================

| Arquivo                                        | Componente  | Ação                                                                           |
| :--------------------------------------------- | :---------- | :----------------------------------------------------------------------------- |
| `TODO.md`                                      | Environment | Marcar como concluídos os 4 épicos do backlog e atualizar matriz de maturidade |
| `Setup/TODO.md`                                | Setup       | Atualizar backlog com receitas de compositores, mídia e EWM                    |
| `Shell/TODO.md`                                | Shell       | Atualizar backlog com lançador `gui` e comando `ewm`                           |
| `Editor/Emacs/TODO.md`                         | Emacs       | Atualizar backlog com aweww CDP e configurações TTY                            |
| `Editor/Vim/TODO.md` & `Editor/NeoVim/TODO.md` | Editores    | Atualizar backlog com mouse FreeBSD TTY e cursor por modo                      |
| `ENVIRONMENT.md` & `PRINCIPLES.md`             | Environment | Verificar consistência dos princípios e sincronizar com sub-repositórios       |

### ================================

### 3. CONTRATOS TÉCNICOS

### ================================

- Execução estrita a partir da raiz do Environment:
    - `make test`: Validação de sintaxe Zsh, Bash e POSIX em todos os repositórios.
    - `make audit`: Execução de linters de monólitos, nanos, formatos e réguas.
    - `make bench`: Medição de latência dos shells (< 16ms / 64ms).
    - `make sync-docs`: Propagação canônica de `ENVIRONMENT.md` e `PRINCIPLES.md` para todos os submódulos.
- O repositório `Vault` privado não deve sofrer alterações indevidas ou commits públicos.
- Árvores de trabalho (`git status -s`) 100% limpas em todos os submódulos.

### ================================

### 4. CRITÉRIOS DE ACEITE

### ================================

- [x] `make ci` aprovado com 100% de sucesso na raiz do Environment.
- [x] `make status` reportando todas as branches em `main` e árvores de trabalho limpas.
- [x] Atualização atômica do commit de ponteiros de submódulos na raiz do Environment: `chore(ecosystem): bump submodules to latest stable milestone`.
