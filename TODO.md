# 🗺️ Roadmap & Backlog do Ecossistema

> Planejamento estratégico, status operacional e visão de futuro para a evolução do **Universal Environment**.

---

## 📊 Status Geral do Ecossistema

| Repositório              | Papel                       |    Maturidade     | Cobertura / Estado                                          |
| :----------------------- | :-------------------------- | :---------------: | :---------------------------------------------------------- |
| **Environment**          | Hub central & Makefile      |    🟢 Estável     | Orquestração global, documentação canônica e submódulos Git |
| **Shell**                | Motor de terminal & prompts |      🟢 100%      | Latência < 16ms, 4 shells em 7 SOs, TUI `_ui_*` unificada   |
| **Setup**                | Provisionador de sistema    | 🟡 Em Refatoração | Funcional, mas rústico; necessita de modularização profunda |
| **Vault**                | Cofre privado de segredos   |    🟢 Estável     | Chaves SSH, arquivos .env e resolução resiliente            |
| **Profile**              | Dotfiles & skills de IA     |    🟢 Estável     | Paridade multiplataforma, auto-cura de links e 28 skills    |
| **Emacs**                | Editor Elisp extensível     |  🟡 Em Evolução   | Modularização e auto-detecção de hardware/runtime           |
| **Helix / NeoVim / Vim** | Suíte de Editores modais    |    🟢 Estável     | Runtimes soberanos e fallbacks sem dependências externas    |

---

## 🎯 Grandes Épicos do Ecossistema

### 0. ⚡ Otimização do Shell & Expansão do Benchmark

> ⚡ **Execução:** Concluído com **Gemini Flash 3.x**

- [x] **Otimização do `cd` no Zsh:** Desacoplamento do hook síncrono do `zoxide` em `chpwd_functions` para `--hook prompt` com guarda de `$PWD`, restaurando a performance nativa de builtin (~0.008ms/cd).
- [x] **Correção do indicador `*` (Git Dirty):** Normalização de caminhos relativos em arquivos `.git` de submódulos (`../../.git/...`) para caminhos absolutos e validação de `HEAD` antes de `git diff-index`, prevenindo falsos positivos em repositórios vazios (`git init`).
- [x] **Harmonização visual dos temas PTY:** Unificação da cor amarela (`${_theme_color_yellow}*`) para o indicador de status sujo em `multi.sh`, `pill.sh` e `micro.sh`.
- [x] **Expansão do `benchmark.sh`:** Inclusão de testes automatizados para Latência de Navegação Interativa (`cd`) e Latência de Renderização de Prompt (`_update_prompt`), eliminando pontos cegos na suíte de performance.
- [x] **Erradicação de falsos positivos de Stat-Cache (`git diff-index` ➔ Porcelain):** Substituição definitiva da ferramenta de baixo nível (`git diff-index`) por `git status --porcelain=v1 -uno --ignore-submodules=dirty` com `GIT_OPTIONAL_LOCKS=0` no Universal Shell (`git.sh`) e perfis Windows (PowerShell, NuShell, Clink), eliminando asteriscos espúrios (`*`) decorrentes de divergências de timestamp (`mtime`/`ctime` / _stat-dirty_) e reduzindo a latência de renderização do prompt de ~7.4ms para ~4.1ms.

### 1. 🎨 Universal Profile: Lapidação e Organização

> ⚡ **Execução:** Concluído com **Gemini Flash 3.x**

- [x] **Curadoria e expurgo:** Eliminar dotfiles redundantes (expurgo de `nushell.nu`), configurações obsoletas e alinhar convenções de nomes (alinhamento de `tools/`, VSCodium e Mermaid CLI).
- [x] **Governança XDG e FHS:** Auditar todos os destinos de symlinks em Linux, FreeBSD, macOS e Windows com resolução defensiva (`$XDG_CONFIG_HOME`, `$XDG_DATA_HOME`).
- [x] **Auto-cura de links e permissões:** Reforçar validação defensiva em `profile.sh` e `install.ps1` com biblioteca semântica `_ui_*`, idempotência ativa e cascata resiliente de links.
- [x] **Catálogo de AI skills:** Manter sincronização e documentação canônica das 28 habilidades portáteis de IA em Unix e Windows.

### 2. 🛡️ Invariante de Clonagem "Out-of-the-Box" (Zero-Tweaks Git Invariant)

> ⚡ **Execução:** Concluído com **Gemini Flash 3.x**

- [x] **Executabilidade imediata:** Garantir que após um simples `git clone`, 100% do repositório funcione sem comandos manuais (nem `chmod`, nem criação de diretórios órfãos), com documentação canônica de onboarding (`CONTRIBUTING.md`) e guias nos READMEs.
- [x] **Permissões canônicas no Git Index:** Garantir modos octais canônicos no controle de versão (`0755` para scripts/hooks executáveis, `0644` para configurações e documentação) em todos os 9 repositórios do ecossistema.
- [x] **Self-Healing em tempo de execução:** Scripts de entrypoint e Makefiles auto-detectam e auto-corrigem permissões (`_self_heal_perms` e `make hooks`) se clonados em sistemas de arquivos incompatíveis (NTFS / FAT32 / WSL).
- [x] **Quality Gates nos Hooks:** Validar via pre-commit local em todos os repositórios para impedir commits com modos de arquivo incorretos, complementado por auditorias Python (`syntax.py`) e CI/CD.

### 3. 🧠 Estudo, Lapidação e Otimização do Ecossistema de AI Skills

> ⚡ **Execução:** Concluído com **Gemini Flash 3.x**

- [x] **Compreensão holística do ecossistema:** Estudar na totalidade a arquitetura de Portable AI Skills, precedência de resolução Unix (Local > Global > Built-in) e dinâmica da janela de contexto.
- [x] **Auditoria e refinamento do catálogo:** Avaliar e polir as habilidades do `Profile/skills/`, elevando a densidade informacional, eliminando redundâncias e assegurando o orçamento canônico ($\le 256$ linhas).
- [x] **Alavancagem prática do ambiente:** Mapear e aplicar os runbooks cognitivos diretamente na operação, automação e elevação do fluxo diário em Linux, FreeBSD e Windows.
- [x] **Perenidade e antifragilidade:** Consolidar todas as skills como modelos mentais atemporais e estruturais, expurgando débitos efêmeros e fortalecendo a auto-cura contínua do ecossistema.
- [x] **Auditor automatizado contínuo (`skills.py`):** Implementação do 7º quality gate estático em `Profile/audit/skills.py` integrado ao `all.py` e pre-commit (orçamento 17-128-256, YAML frontmatter e integridade).
- [x] **Elevação de `skill-authoring-standards`:** Consolidação das regras canônicas de trigger engineering, escopo atômico e orçamento unificado de linhas para skills e `AGENTS.md`.
- [x] **Alinhamento constitucional (`AGENTS.md` e 22 Princípios):** Auditoria e harmonização de 100% dos `AGENTS.md`, `.agents/rules/` e documentações canônicas nos 8 repositórios do ecossistema sob o orçamento de $\le 128$ linhas e os 22 Princípios de Engenharia.

### 4. 🪟 Paridade e Resiliência no Windows: Profile, Shell e Vault

> ⚡ **Execução:** Permitido com **Gemini Flash 3.x**

- [ ] **Universalização do `vault-perms`:** Estender a validação e endurecimento de permissões do Vault (atualmente restrito a MSYS2 e PowerShell) para suportar nativamente o **Nushell** e o **CMD com Clink**.
- [ ] **Estratégia de deploy de dotfiles (Symlinks vs. Cópia):** Preservar symlinks estritos no Unix e MSYS2; no Windows nativo, desenhar arquitetura de instalação resiliente (avaliar trade-offs de symlinks via _Developer Mode_ vs. fallback gracioso para cópia/sincronização direta sem exigência de elevação UAC).
- [ ] **Reconciliação e sincronismo de dotfiles:** Caso adotada a estratégia de cópia no Windows, criar rotina idempotente de sincronização para propagar alterações locais de volta ao repositório sem atrito.
- [ ] **Harmonização de runtime nos shells Windows:** Padronizar inicialização, aliases e chamadas TUI (`_ui_*`) entre PowerShell, Nushell, CMD/Clink e MSYS2, eliminando divergências de comportamento e caminhos de execução.

### 5. 🏛️ Refatoração e Elevação do Setup

> 🔒 **Trava de Modelo:** Bloqueado — Executar exclusivamente com **Gemini Pro 4** (demanda raciocínio aprofundado para arquitetura de receitas modais, portabilidade POSIX estrita e testes de estresse multiplataforma).

- [ ] **Desconstrução da rusticidade:** Modularizar os scripts de provisionamento em receitas atômicas e idempotentes.
- [ ] **Conformidade POSIX `/bin/sh` estrita:** Eliminar bashismos em instaladores e scripts de bootstrap.
- [ ] **Paridade multiplataforma:** Garantir consistência entre distribuições Linux (Arch, Debian/Ubuntu, Fedora, Void, Alpine), FreeBSD, illumos e Windows.
- [ ] **Padronização visual TUI:** Adotar a biblioteca semântica `_ui_*` em 100% das saídas interativas do Setup.

### 6. 📝 GNU Emacs: Arquitetura Modular e Auto-Detecção Sensorial

> 🔒 **Trava de Modelo:** Bloqueado — Executar exclusivamente com **Gemini Pro 4** (demanda orquestração Elisp avançada, bootstrapping assíncrono via Elpaca e depuração de compilação nativa/C-level).

- [ ] **Detecção dinâmica de hardware e runtime:** Identificar automaticamente Wayland (PGTK), X11, libgccjit (native-comp AOT/JIT) e Tree-sitter nativo (ABI ≥ 14).
- [ ] **Tipografia adaptativa:** Auto-configuração de DirectWrite no Windows e HarfBuzz/Fontconfig no Linux/BSD.
- [ ] **Modularidade avançada:** Desacoplar `early-init.el` e organizar camadas Elisp autônomas com carregamento assíncrono via Elpaca.
- [ ] **Robustez de inicialização:** Garantir testes de boot em modo batch e headless sem falhas silenciosas (< 1s).

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
