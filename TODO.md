# 🗺️ Roadmap & Backlog do Ecossistema

> Planejamento estratégico, status operacional e visão de futuro para a evolução do **Universal Environment**.

---

## 📊 Status Geral do Ecossistema

| Repositório              | Papel                       | Maturidade | Cobertura / Estado                                             |
| :----------------------- | :-------------------------- | :--------: | :------------------------------------------------------------- |
| **Environment**          | Hub central & Makefile      | 🟢 Estável | Orquestração global, documentação canônica e submódulos Git    |
| **Shell**                | Motor de terminal & prompts |  🟢 100%   | Latência < 16ms, shells nativos e alternativos, TUI `_ui_*`    |
| **Setup**                | Provisionador de sistema    | 🟢 Estável | Arquitetura modular `core/`, receitas idempotentes e paridade  |
| **Vault**                | Cofre privado de segredos   | 🟢 Estável | Chaves SSH, auditoria canônica `age`, backups e `.env` seguros |
| **Profile**              | Dotfiles & skills de IA     | 🟢 Estável | Paridade multiplataforma, foco em emuladores gráficos e skills |
| **Emacs**                | Editor Elisp extensível     | 🟢 Estável | Arquitetura sensorial, tipografia adaptativa e IA `gemma4`     |
| **Helix / NeoVim / Vim** | Suíte de Editores modais    | 🟢 Estável | Runtimes soberanos, Mason LSP, FZF recursivo e fallbacks TTY   |

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
- [x] **Auto-cura de links e permissões:** Reforçar validação defensiva em `profile.sh` com biblioteca semântica `_ui_*`, idempotência ativa, detecção de divergência e cascata resiliente de links.
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
- [x] **Auditor automatizado contínuo (`skills.py`):** Implementação do 7º quality gate estático em `Profile/.scripts/audit/skills.py` integrado ao `all.py` e pre-commit (orçamento 17-128-256, YAML frontmatter e integridade).
- [x] **Elevação de `agentic-governance-standards`:** Consolidação das regras canônicas de governança agentic (Constituição `AGENTS.md`, Regras Canônicas `.agents/rules/` e Arquitetura em 2 Tiers Lean vs Extended).
- [x] **Alinhamento constitucional (`AGENTS.md` e 22 Princípios):** Auditoria e harmonização de 100% dos `AGENTS.md`, `.agents/rules/` e documentações canônicas nos 8 repositórios do ecossistema sob o orçamento de $\le 128$ linhas e os 22 Princípios de Engenharia.

### 4. 🪟 Paridade e Resiliência no Windows: Profile, Shell e Vault

> ⚡ **Execução:** Concluído com **Gemini Flash 3.x**

- [x] **Universalização do `vault-perms`:** Suporte multiplataforma e endurecimento de permissões do Vault com `_ui_*` nativo no **Bash/POSIX**, **PowerShell**, **Nushell**, **CMD com Clink** e **Lua**, aplicando `icacls` restritivo e registrando hooks locais.
- [x] **Estratégia de deploy soberana (Hierarquia Tripartite Ouro / Prata / Bronze):** Consolidar a arquitetura tripartite: UNIX nativo como **Classe 1 (Ouro)**, MSYS2 como Centro de Comando soberano no Windows como **Classe 2 (Prata)**, e terminais nativos (PowerShell, NuShell, CMD) como consumidores rápidos de **Classe 3 (Bronze)**. Unificação completa do motor de sincronização em `profile.sh` POSIX com suporte a NTFS symlinks nativos via `MSYS=winsymlinks:nativestrict` (quando Modo Desenvolvedor ativo) e fallback gracioso para cópia física com alertas semânticos (`_ui_warn`). Implementada resolução defensiva de binários que filtra e exclui stubs do WSL (`System32\bash.exe`). Expurgado definitivamente o script duplicado `install.ps1` (Clean-Break).
- [x] **Reconciliação e sincronismo bidirecional de dotfiles:** Implementadas opções `--status` (`-s`) para auditar drift/divergências e `--pull` para propagar alterações locais feitas no Windows de volta ao repositório Git de forma idempotente e segura.
- [x] **Harmonização de runtime nos shells Windows:** Padronização completa da família `up*`, `sync-profile`, `vault-perms` e biblioteca semântica `_ui_*` entre **PowerShell**, **Nushell**, **CMD/Clink** e **MSYS2**, atuando como consumidores rápidos (Classe 3 / Bronze) que delegam a manutenção estrutural ao motor unificado POSIX da Classe 2 (Prata).

### 5. Arrumar os <projetos>.sh

> ⚡ **Execução:** Concluído com **Gemini Flash 3.x**

- [x] **Modularização dos monólitos em `core/`:** Interfaces principais de `Profile/profile.sh` (reduzido de 371 para 105 linhas) e `Vault/vault.sh` (reduzido de 134 para 42 linhas) modularizadas com sucesso na subpasta canônica `core/` (`perms.sh`, `sync.sh`, `ui.sh`, `env.sh`), respeitando os limites estritos de linhas e integridade dos hooks locais.
- [x] **Universal Git Traversal (Top-Down `plgit`/`update-git` e Bottom-Up `psgit`/`push-git`):** Implementada ordenação estrita por profundidade (`depth`) no Shell, Nushell, PowerShell e CMD/Clink para atualização segura de cima para baixo e propagação de push de baixo para cima das folhas para a raiz.
- [x] **Blindagem de pipelines POSIX:** Normalizados wrappers de `grep`, `ls`, `cat` para desacoplamento de aliases interativos durante o tráfego em pipes (`vulkaninfo | grep -E ...`).
- [x] **Cascata universal de cursor Wayland:** Implementada resolução resiliente em 5 camadas (Variáveis existentes -> `index.theme` -> KDE `kcminputrc` -> GTK `settings.ini` -> GSettings -> Fallback semântico) garantindo paridade entre Linux e FreeBSD.
- [x] **Unificação de submódulos do GNU Emacs:** Submódulos Git em `usr/local/` (`aweshell`, `aweww`, `emacs-lisp-ts-mode`) convertidos em árvores rastreadas nativas, eliminando dependências externas e mantendo testes em batch mode 100% limpos.
- [x] **Ativação de Menu Bar e Tool Bar no GNU Emacs:** Ativação dinâmica de `menu-bar-mode` e `tool-bar-mode` em ambientes POSIX com guarda para desativação em `windows-nt`, saneamento de `custom.el` contra desativações assíncronas do Elpaca e estilização GTK 3 via CSS/Breeze-Dark.
- [x] **Despachantes universais multi-SO no Setup:** Criação dos despachantes universais `Setup/common/ai/ollama.sh` (multi-gerenciador `pkg`, `dnf`, `apt`, `pacman`, `winget`), unificação de `Setup/common/security/wireshark.sh`, adição de `plasma6-breeze-gtk` para paridade de temas GTK no FreeBSD KDE e formalização da matriz multi-SO de shells canônicos (`chsh`).
- [x] **Adoção canônica de `.scripts/`:** Transição completa das antigas pastas `scripts/` na raiz para `.scripts/` por princípio de pureza e limpeza do diretório raiz em todo o ecossistema.
- [x] **Lapidação e sincronização das diretrizes Markdown, Mermaid e SVG:** Consolidada a Hierarquia Universal de 3 Camadas (Mermaid > SVG > ASCII), as diretrizes de proporção harmônica e pós-processamento antifrágil de SVG, e a blindagem contra o bug de listas ordenadas (`htmlLabels: false` / descarte para `<text></text>` vazio) em `Profile/agents/skills/technical-writing-standards` e `Foundation/Raw Text/AGENTS.md`.

### 6. 🚀 Bhyve Linux Runtime & Paradigma de Virtualização Híbrida

> ⚡ **Execução:** Concluído com **Gemini Flash 3.x**

- [x] **Saneamento e curadoria da série de runbooks:** Saneamento técnico integral dos 6 documentos operacionais e organização canônica na pasta `docs/virtualization/bhyve/` com índice `README.md`.
- [x] **Integração no Universal Shell (`linux-host`, `agy-lx`, `agy-compat`):** Implementação modular em `Shell/target/freebsd/bhyve.sh` e `Shell/target/freebsd/compat.sh` com aliases (`linux`, `lx`, `debian`, `deb`, `agy`, `agy-cp`), conformidade estrita POSIX `/bin/sh` (zero arrays bash) e blindagem da latência de prompt (< 5ms).
- [x] **Paridade e antifragilidade de diretórios:** Lógica de espelhamento que navega automaticamente para o subdiretório correspondente em `/home/gabrielf` no guest, com fallback silencioso para a raiz da home se disparado fora dela ou em pasta inexistente.
- [x] **Rotina unificada de atualização (`update-linux`):** Implementada a função `update-linux` com atalhos `uplx` e `updeb`, integrada automaticamente ao comando orquestrador `update-all` (`upall`) no host FreeBSD.
- [x] **Receitas de provisionamento no Setup:** Adicionadas as receitas `Setup/freebsd/container/bhyve.sh` (host, switch, PF NAT, NFSv3 e template) e `Setup/linux/desktop/debian/bhyve-guest.sh` (guest, UID/GID 1001, cliente NFS, doas/sudo e git-crypt).
- [x] **Registro topológico no Vault:** Configuração do nó local `192.168.8.2 debian` em `Vault/servers/hosts.env`.
- [x] **Governança Constitucional (`AGENTS.md` e Skills):** Formalização da Regra 13/14 nos repositórios sobre o ambiente híbrido e expansão das skills `universal-environment` e `antifragile-engineering`.

### 7. 📚 Biblioteca Canônica de Documentação ("Docs Digno do Environment")

> ⚡ **Execução:** Concluído com **Gemini Flash 3.x**

- [x] **Arquitetura Hub & Spoke e Portal Mestre (`docs/README.md`):** Estruturação taxonômica completa com mapa de navegação Mermaid e 8 domínios de conhecimento especializados.
- [x] **Host FreeBSD Bare-Metal (`docs/freebsd/`):** 7 runbooks cobrindo bootloader/kernel, tuning OpenZFS ARC (4/8), rede/PF NAT, gráficos Intel Alder Lake (PSR/FBC), terminais `/etc/ttys` com Ly TUI e áudio USB/devfs.
- [x] **Tríade de Virtualização & Isolamento (`docs/virtualization/`):** Comparativo arquitetural e runbooks aprofundados para Bhyve (`bhyve/`), Jails VNET nativas (`jails/`) e orquestração declarativa BastilleBSD (`bastille/`).
- [x] **Runtimes Linux & Windows (`docs/linux/` e `docs/windows/`):** Paridade POSIX/GNU, UID/GID 1001, Podman Rootless OCI, Arquitetura Tripartite no Windows, perfis PowerShell/Nushell com `_ui_*` e gestão Pageant/icacls.
- [x] **A Suíte de 4 Editores Autônomos (`docs/editors/`):** Guias de referência para GNU Emacs (Elpaca assíncrono), Helix (Rust & Tree-sitter), NeoVim (Lua, Lazy & Mason) e Vim Clássico (TTYs e soberania UNIX).
- [x] **O Quarteto de Infraestrutura (`docs/quarteto/`):** Contratos arquiteturais detalhados de Setup, Shell, Vault e Profile.
- [x] **Metodologia & Engenharia Antifrágil (`docs/engineering/`):** Análise comentada dos 22 Princípios UNIX, os 7 Pilares de Antifragilidade, a política Clean-Break e o ciclo Bancada vs. Produção.

### 8. 🏛️ Refatoração e Elevação do Setup

- [x] **Desconstrução da rusticidade:** Modularizar os scripts de provisionamento em receitas atômicas e idempotentes (`Setup/core/` e `common/`).
- [x] **Conformidade POSIX `/bin/sh` estrita:** Eliminar bashismos em instaladores e scripts de bootstrap (`Setup/core/elevate.sh`, `core/ui.sh`).
- [x] **Paridade multiplataforma:** Garantir consistência entre distribuições Linux (Arch, Debian, Fedora), FreeBSD e Windows.
- [x] **Padronização visual TUI:** Adotar a biblioteca semântica `_ui_*` em 100% das saídas interativas do Setup.

### 9. 📝 GNU Emacs: Arquitetura Modular e Auto-Detecção Sensorial

- [x] **Detecção dinâmica de hardware e runtime:** Identificar automaticamente Wayland (PGTK), X11, DirectWrite, libgccjit e Tree-sitter nativo.
- [x] **Tipografia adaptativa:** Auto-configuração de DirectWrite no Windows e HarfBuzz/Fontconfig no Linux/BSD com ligaduras e fallbacks.
- [x] **Modularidade avançada:** Desacoplar módulos locais e encapsular carregamento em `condition-case` resiliente.
- [x] **Robustez de inicialização & IA:** Testes de boot batch em 0.41ms e integração local exclusiva com `gemma4:e2b` e `gemma4:e4b`.

### 10. 🚀 Shells Alternativos: Modularização no Shell e Desacoplamento do Profile

- [x] **Migração de módulos para o Shell:** Runtimes de **PowerShell**, **Nushell**, **Fish** e **CMD/Clink** migrados para `Shell/target/`.
- [x] **Deploy e bootstrapping via `install.sh`:** Incorporação de linking simbólico declarativo e idempotente em `Shell/library/deploy.sh`.
- [x] **Expurgo no Profile (Clean-Break):** Remoção de `terminals/powershell`, `nushell` e `cmd` do `Profile`, restringindo-o a emuladores de janela.
- [x] **Harmonização com o Setup:** Setup focado em provisionar pacotes binários, delegando dotfiles e runtimes ao motor do `Shell`.

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
