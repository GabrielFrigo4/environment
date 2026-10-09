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
- [ ] Quando for executar essa tarefa avise do plano de "remoção das pastas scripts na raiz de qualquer projeto por principio e por limpesa"
- [ ] Melhorar as skills sobre markdown, mermaid e svg.
      Regras Mermaid e SVG, em versão genérica
      Escolha e estrutura

Diagrama declarativo primeiro. Texto que vira vetor vem antes de ilustração vetorial, que vem antes de ASCII. A ASCII é só para grades densas de bits ou para quando o alinhamento monoespaçado é insubstituível.
A escolha de formato é por clareza e geometria. Nunca por tema.
Proporção harmônica (~16:9, 4:3 ou 2:1). Evite cadeias com mais de 3–4 nós na horizontal ou 4–5 na vertical. Prefira fluxo vertical macro com subgrupos horizontais.
Aresta nunca encosta no título de um grupo. Ligue contêiner a contêiner, ou modele os estágios como nós independentes.
Setas e rótulos 5. Com legenda, operador de comprimento 3. Sem legenda, comprimento 2. O elo mais longo reserva espaço para a legenda. 6. Nada de HTML em rótulos. Quebra de linha e ênfase usam a sintaxe nativa de strings Markdown da ferramenta. 7. Sem Unicode decorativo (setas, símbolos matemáticos) em rótulos. Use a sintaxe de seta nativa. 8. Legendas de aresta ficam sobre fundo sólido e opaco, para a linha não atravessar o texto.

Vetor e render 9. Rótulos como texto vetorial nativo (sem HTML embutido), com entidades sanitizadas. Assim o texto fica selecionável e nítido em qualquer renderizador. 10. Espaçamentos e margens internas calibrados para o papel. Padding de grupo maior que o padrão evita setas cortando bordas de clusters aninhados. Espaço entre nós e entre camadas deixa a legenda respirar. A margem do título do grupo vem calculada para ele não colidir com o primeiro filho. 11. Estilo em duas camadas. Variáveis de tema para o cálculo de geometria, e CSS com prioridade máxima para sobrepor o estilo injetado pela ferramenta. 12. Ilustrações geométricas são arquivos locais embutidos no documento final. O resultado fica portátil e sem dependência externa.

Pós-processamento do SVG (antifrágil) 13. Extraia atributos pelo nome, nunca pela posição. O parsing não pode depender da ordem de serialização. 14. Falha graciosa. Se um atributo falta ou o formato muda, devolva o bloco original intacto. O pior caso é "sem ajuste fino", nunca "documento quebrado". 15. Ajustes finos ficam isolados e nomeados. Cada correção cobre um defeito específico: centralização ótica, deslocamento em cilindros, snap em bordas de cluster, padding de badge.

Governança 16. Regra mecânica vira gate automático (pre-commit), não só documentação. 17. Ferramentas pesadas usam cache fora da árvore do repositório. 18. Diagrama com sintaxe duvidosa é validado em navegador headless antes do push.

"""O bug ocorre porque, com `"htmlLabels": false`, o Mermaid processa strings delimitadas por crase (`["`...`"]`) através de um parser de Markdown, o qual interpreta qualquer linha iniciada por número seguido de ponto e espaço (`1. `, `2. `) como um **item de lista ordenada**. Como o gerador de SVG nativo do Mermaid suporta apenas estilos inline básicos e não implementa listas, ele descarta esses tokens silenciosamente e cospe uma tag `<text>` vazia no diagrama final.""" => Um bug que temos que salvar no skill e agents no Raw Text E fazer algo a respeito na skill global do markdown... Porque tem haver

**Como evitar:**

- **Escapar o ponto (recomendado):** Adicione uma barra invertida antes do ponto (ex: `["`1\. Input Assembler`"]`), forçando o parser a tratá-lo como texto comum.
- **Mudar o separador numérico:** Substitua o padrão número + ponto por outro caractere (ex: `["`[1] Input Assembler`"]` ou `["`1 - Input Assembler`"]`).

### 6. 🏛️ Refatoração e Elevação do Setup

> 🔒 **Trava de Modelo:** Bloqueado — Executar exclusivamente com **Gemini Pro 4** (demanda raciocínio aprofundado para arquitetura de receitas modais, portabilidade POSIX estrita e testes de estresse multiplataforma).

- [ ] **Desconstrução da rusticidade:** Modularizar os scripts de provisionamento em receitas atômicas e idempotentes.
- [ ] **Conformidade POSIX `/bin/sh` estrita:** Eliminar bashismos em instaladores e scripts de bootstrap.
- [ ] **Paridade multiplataforma:** Garantir consistência entre distribuições Linux (Arch, Debian/Ubuntu, Fedora, Void, Alpine), FreeBSD, illumos e Windows.
- [ ] **Padronização visual TUI:** Adotar a biblioteca semântica `_ui_*` em 100% das saídas interativas do Setup.

### 7. 📝 GNU Emacs: Arquitetura Modular e Auto-Detecção Sensorial

> 🔒 **Trava de Modelo:** Bloqueado — Executar exclusivamente com **Gemini Pro 4** (demanda orquestração Elisp avançada, bootstrapping assíncrono via Elpaca e depuração de compilação nativa/C-level).

- [ ] **Detecção dinâmica de hardware e runtime:** Identificar automaticamente Wayland (PGTK), X11, libgccjit (native-comp AOT/JIT) e Tree-sitter nativo (ABI ≥ 14).
- [ ] **Tipografia adaptativa:** Auto-configuração de DirectWrite no Windows e HarfBuzz/Fontconfig no Linux/BSD.
- [ ] **Modularidade avançada:** Desacoplar `early-init.el` e organizar camadas Elisp autônomas com carregamento assíncrono via Elpaca.
- [ ] **Robustez de inicialização:** Garantir testes de boot em modo batch e headless sem falhas silenciosas (< 1s).

### 8. 🚀 Shells Alternativos: Modularização no Shell e Desacoplamento do Profile

> 🔒 **Trava de Modelo:** Bloqueado — Executar exclusivamente com **Gemini Pro 4** (demanda orquestração Elisp avançada, bootstrapping assíncrono via Elpaca e depuração de compilação nativa/C-level).

- [ ] **Migração de módulos para o Shell:** Mover dotfiles e runtimes de **PowerShell**, **Nushell**, **Fish** e **CMD/Clink** para dentro do repositório `Shell`.
- [ ] **Deploy e bootstrapping via `install.sh`:** Incorporar rotinas de instalação e symlinks declarativos desses shells no motor do `Shell`.
- [ ] **Expurgo no Profile (Clean-Break):** Remover `terminals/powershell`, `nushell` e `cmd` do `Profile`, restringindo-o a emuladores gráficos (Windows Terminal, Konsole).
- [ ] **Harmonização com o Setup:** Garantir que o `Setup` apenas provisione os binários/pacotes, delegando dotfiles e runtimes 100% ao `Shell`.

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
