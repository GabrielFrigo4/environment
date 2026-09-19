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
| **Profile**              | Dotfiles & skills de IA     | 🟡 Em Refinamento | Terminais Windows padronizados; polimento geral de dotfiles |
| **Emacs**                | Editor Elisp extensível     |  🟡 Em Evolução   | Modularização e auto-detecção de hardware/runtime           |
| **Helix / NeoVim / Vim** | Suíte de Editores modais    |    🟢 Estável     | Runtimes soberanos e fallbacks sem dependências externas    |

---

## 🎯 Grandes Épicos do Ecossistema

### 1. 🏛️ Refatoração e Elevação do Setup

- [ ] **Desconstrução da rusticidade:** Modularizar os scripts de provisionamento em receitas atômicas e idempotentes.
- [ ] **Conformidade POSIX `/bin/sh` estrita:** Eliminar bashismos em instaladores e scripts de bootstrap.
- [ ] **Paridade multiplataforma:** Garantir consistência entre distribuições Linux (Arch, Debian/Ubuntu, Fedora, Void, Alpine), FreeBSD, illumos e Windows.
- [ ] **Padronização visual TUI:** Adotar a biblioteca semântica `_ui_*` em 100% das saídas interativas do Setup.

### 2. 📝 GNU Emacs: Arquitetura Modular e Auto-Detecção Sensorial

- [ ] **Detecção dinâmica de hardware e runtime:** Identificar automaticamente Wayland (PGTK), X11, libgccjit (native-comp AOT/JIT) e Tree-sitter nativo (ABI ≥ 14).
- [ ] **Tipografia adaptativa:** Auto-configuração de DirectWrite no Windows e HarfBuzz/Fontconfig no Linux/BSD.
- [ ] **Modularidade avançada:** Desacoplar `early-init.el` e organizar camadas Elisp autônomas com carregamento assíncrono via Elpaca.
- [ ] **Robustez de inicialização:** Garantir testes de boot em modo batch e headless sem falhas silenciosas (< 1s).

### 3. 🎨 Universal Profile: Lapidação e Organização

- [ ] **Curadoria e expurgo:** Eliminar dotfiles redundantes, configurações obsoletas e alinhar convenções de nomes.
- [ ] **Governança XDG e FHS:** Auditar todos os destinos de symlinks em Linux, FreeBSD, macOS e Windows.
- [ ] **Auto-cura de links e permissões:** Reforçar validação defensiva em `profile.sh` e `install.ps1`.
- [ ] **Catálogo de AI skills:** Manter sincronização e documentação canônica das habilidades portáteis de IA.

### 4. 🛡️ Invariante de Clonagem "Out-of-the-Box" (Zero-Tweaks Git Invariant)

- [ ] **Executabilidade imediata:** Garantir que após um simples `git clone`, 100% do repositório funcione sem comandos manuais (nem `chmod`, nem criação de diretórios órfãos).
- [ ] **Permissões canônicas no Git Index:** Garantir modos octais canônicos no controle de versão (`0755` para scripts/hooks executáveis, `0644` para configurações e documentação).
- [ ] **Self-Healing em tempo de execução:** Scripts devem auto-detectar e auto-corrigir permissões se clonados em sistemas de arquivos incompatíveis (ex: NTFS / FAT32 / WSL mounts).
- [ ] **Quality Gates nos Hooks:** Validar via pre-commit local para impedir commits com modos de arquivo incorretos.

### 5. 🧠 Estudo, Lapidação e Otimização do Ecossistema de AI Skills

- [ ] **Compreensão holística do ecossistema:** Estudar na totalidade a arquitetura de Portable AI Skills, precedência de resolução Unix (Local > Global > Built-in) e dinâmica da janela de contexto.
- [ ] **Auditoria e refinamento do catálogo:** Avaliar e polir as habilidades do `Profile/skills/`, elevando a densidade informacional, eliminando redundâncias e assegurando o orçamento canônico ($\le 256$ linhas).
- [ ] **Alavancagem prática do ambiente:** Mapear e aplicar os runbooks cognitivos diretamente na operação, automação e elevação do fluxo diário em Linux, FreeBSD e Windows.
- [ ] **Perenidade e antifragilidade:** Consolidar todas as skills como modelos mentais atemporais e estruturais, expurgando débitos efêmeros e fortalecendo a auto-cura contínua do ecossistema.

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
