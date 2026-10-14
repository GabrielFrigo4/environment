# 🤖 Agent 3: Shells Alternativos — Migração e Desacoplamento Profile ➔ Shell

> **Plano Operacional Especializado — Épico 10 do Ecossistema**
> 🔒 **Trava de Modelo:** Exclusivo **Gemini Pro 4** (demanda reestruturação de fronteiras arquiteturais entre repositórios, sincronização multiplataforma e preservação da latência de inicialização no Windows).
> **Referência Obrigatória Prévia:** Leia atentamente o [`all_agents.md`](all_agents.md).

---

## 🎯 1. Objetivo Central da Missão

Reestruturar a divisão de responsabilidades entre o **Universal Shell** e o **Universal Profile**, transferindo todos os runtimes e prompts interativos de shells alternativos (**PowerShell**, **NuShell**, **Fish** e **CMD com Clink**) que atualmente residem em `Profile/terminals/` para o repositório canônico `Shell/`. O `Profile` passará a gerenciar exclusivamente emuladores gráficos de janela (Windows Terminal, Konsole, Alacritty).

---

## 🗺️ 2. Topografia de Arquivos a Explorar

1. **Repositório de Origem (`Profile/`):**
    - [`Profile/terminals/powershell/`](file:///home/gabrielf/Documents/Environment/Profile/terminals/powershell): Perfis `Microsoft.PowerShell_profile.ps1`, funções `up*`, biblioteca `_ui_*`.
    - [`Profile/terminals/nushell/`](file:///home/gabrielf/Documents/Environment/Profile/terminals/nushell): `config.nu`, `env.nu`, temas.
    - [`Profile/terminals/cmd/`](file:///home/gabrielf/Documents/Environment/Profile/terminals/cmd): Scripts Lua e perfis para Clink.
    - [`Profile/core/sync.sh`](file:///home/gabrielf/Documents/Environment/Profile/core/sync.sh): Sincronizador de dotfiles (atualmente em 244 linhas, limite 256).
2. **Repositório de Destino (`Shell/`):**
    - [`Shell/target/`](file:///home/gabrielf/Documents/Environment/Shell/target/): Estrutura de shells por sistema operacional.
    - [`Shell/install.sh`](file:///home/gabrielf/Documents/Environment/Shell/install.sh): Orquestrador de deploy e geração de links para shells.
    - [`Shell/context/`](file:///home/gabrielf/Documents/Environment/Shell/context/): Contextos Desktop, Server e Container.
3. **Provisionador (`Setup/`):**
    - Receitas de instalação de binários de shells (`Setup/common/cli/`, `Setup/windows/native/`).

---

## 📋 3. Roteiro Metódico de Execução (Passo a Passo)

### Fase 1: Arquitetura de Acolhimento no Shell (`Shell/target/windows/`)

- [x] Criar a estrutura receptora no `Shell`:
    - `Shell/target/windows/powershell/`: Perfil corporativo PowerShell 7+.
    - `Shell/target/windows/nushell/`: Configuração nativa NuShell.
    - `Shell/target/windows/cmd/`: Scripts Clink em Lua e inicialização `autorun.cmd`.
    - `Shell/target/common/fish/`: Suporte a Fish Shell com funções `up*` e biblioteca `_ui_*`.
- [x] Adaptar caminhos relativos e resolução de variáveis de ambiente para a raiz do Shell (`$SHELL_REPO_DIR`).

### Fase 2: Atualização do Motor de Deploy (`Shell/install.sh`)

- [x] Incorporar no script de deploy do Shell a capacidade de linkar declarativamente os perfis de shells Windows e Fish para seus caminhos padrão XDG/Windows (`$PROFILE` do PowerShell, `$nu.config-path`, `~/.config/fish`).
- [x] Assegurar idempotência completa e auto-cura de permissões.

### Fase 3: Expurgo Limpo no Profile (Clean-Break Invariant)

- [x] Remover definitivamente os diretórios `Profile/terminals/powershell/`, `Profile/terminals/nushell/` e `Profile/terminals/cmd/`.
- [x] Atualizar `Profile/core/sync.sh`:
    - Remover blocos de sincronização dos shells migrados.
    - Assegurar que o arquivo permaneça estritamente abaixo de 256 linhas.
    - Manter apenas o gerenciamento de emuladores gráficos de terminal (`windows-terminal/`, `konsole/`).
- [x] Atualizar o README de `Profile/terminals/` documentando a nova fronteira limpa.

### Fase 4: Harmonização com o Universal Setup

- [x] Auditar receitas no `Setup` para garantir que ele apenas instale os binários de pacotes (ex: `pwsh`, `nu`, `fish`), sem gravar dotfiles nos diretórios de usuário.
- [x] Delegar 100% da identidade e dotfiles ao motor do Shell.

### Fase 5: Validação e Testes Multi-Shell

- [x] Executar `python3 Profile/.scripts/audit/all.py` para garantir conformidade estrita após a remoção.
- [x] Executar `make -C Shell test` e `make -C Shell bench` para validar que a latência permanece abaixo de 16ms.
- [x] Executar `make audit` na raiz do Environment.

---

## ⚠️ 4. Invariantes Críticas & Gotchas

1. **Clean-Break Obrigatório:** Proibido deixar links simbólicos ou arquivos shims vazios em `Profile/` apontando para `Shell/`. A quebra é limpa e imediata.
2. **Latência de Inicialização:** No PowerShell e NuShell, evite chamadas de executáveis externos durante o carregamento de funções para manter a inicialização interativa ágil no Windows.
3. **Limite de 256 Linhas:** Nunca permita que arquivos em `Profile/core/` ou `Shell/` excedam 256 linhas durante a refatoração.
