# 🏛️ Universal Environment: Briefing Mestre de Contexto Global (All Agents)

> **Documento Canônico de Alinhamento Cognitivo e Arquitetural Multi-Agente**
> Destinado a todos os agentes autônomos que operam no ecossistema Universal Environment.
> Qualquer agente iniciado DEVE internalizar este documento antes de qualquer alteração de código.

---

## 🧭 1. Identidade e Topologia do Ecossistema

O **Universal Environment** é o hub central de engenharia e orquestração de um ecossistema federado composto por 10 repositórios independentes, projetados para provisionar, operar e manter estações de trabalho de alta performance em **FreeBSD**, **Linux** e **Windows**:

```text
                                  ┌───────────────────────────────┐
                                  │      Environment (Hub)        │
                                  │   Makefile Global • Docs      │
                                  └───────────────┬───────────────┘
                     ┌────────────────────────────┼────────────────────────────┐
                     ▼                            ▼                            ▼
      ┌─────────────────────────────┐ ┌─────────────────────────┐ ┌─────────────────────────┐
      │  Quarteto de Infraestrutura │ │    Suíte de Editores    │ │    Arquétipos Base      │
      │  Setup • Shell • Vault •    │ │  Emacs • Helix •        │ │  Template               │
      │  Profile                    │ │  NeoVim • Vim           │ │                         │
      └─────────────────────────────┘ └─────────────────────────┘ └─────────────────────────┘
```

### O Quarteto de Infraestrutura (Core):

1. **`Setup/` (Público):** Provisionamento declarativo de pacotes, firmwares, drivers e serviços de SO com privilégios elevados (`sudo`/`doas`/`runas`).
2. **`Shell/` (Público):** Motor interativo de terminal com prompts de altíssima velocidade (< 16ms boot, ~4.1ms prompt), 4 shells nativos (Zsh, Bash, FreeBSD sh, OpenBSD ksh) em 7 sistemas operacionais.
3. **`Vault/` (Privado - `.gitignored`):** Cofre criptográfico de segredos, chaves SSH e arquivos `.env` com permissões canônicas estritas (`0700`/`0600`).
4. **`Profile/` (Público):** Dotfiles declarativos, linters, temas visuais e catálogo de 28 Portable AI Skills com linter contínuo.

### A Suíte de Editores (Tools):

- **`Editor/Emacs/`:** GNU Emacs 30.1+ com Tree-sitter nativo, compilação `libgccjit` e gerenciamento assíncrono Elpaca.
- **`Editor/Helix/`:** Editor modal pós-moderno em Rust com LSP nativo e sintaxe TOML.
- **`Editor/NeoVim/`:** Editor modal em Lua seguindo arquitetura FHS (`lib/`, `etc/`, `opt/`), Lazy.nvim e Mason LSP.
- **`Editor/Vim/`:** Editor clássico UNIX, fail-safe para consoles puros e servidores remotos mínimos.

---

## 🌐 2. Topologia Híbrida: FreeBSD Bare-Metal + Bhyve Debian Runtime

### A Tese Arquitetural Soberana:

O desenvolvedor utiliza **FreeBSD 15.1-CURRENT bare-metal** como estação desktop primária (usufruindo de OpenZFS nativo, firewall Packet Filter [PF], drivers de áudio OSS de baixa latência e ambiente gráfico KDE Plasma 6).

Entretanto, ferramentas modernas do ecossistema de desenvolvimento (como o **Google Antigravity CLI [`agy`]**, contêineres Docker/OCI, extensões Python compiladas para Linux e toolchains IoT) exigem chamadas de sistema e bibliotecas glibc nativas do kernel Linux.

### A Razão da Transição (Colapso no Linuxulator vs. Vitória no Bhyve):

Inicialmente, tentou-se rodar o binário Linux do `agy` sob a camada de compatibilidade **Linuxulator** (`/compat/linux`) do FreeBSD. A investigação forense revelou um colapso estrutural causado por incompatibilidades com o runtime da linguagem Go:

1. **Syscalls HTTP/2:** Chamadas `setsockopt` não implementadas no Linuxulator inundavam o `dmesg` com erros de socket.
2. **Spin-Loop no `fsnotify` (`projects.go`):** O Linuxulator mapeia chamadas `inotify` e `epoll` para `kqueue`. Em descritores não-bloqueantes (`IN_NONBLOCK`), leituras subsequentes retornavam `EAGAIN`. Na falta de backoff defensivo, o runtime Go entrava em um ciclo fechado a ~300.000 iterações por segundo.
3. **Esgotamento do GC e Vazamento:** O loop alocava centenas de milhares de instâncias de `os.SyscallError` no heap, sufocando o Garbage Collector do Go e provocando vazamentos de ~500 MB/min, competindo diretamente pela memória física cabeada (_wired memory_) do ZFS ARC.
4. **Saturação de I/O de Disco (ZFS TXG Throttle):** A gravação descontrolada de logs de diagnóstico travava as esteiras de transações do ZFS, congelando a interface gráfica.
5. **Rajadas de `SIGURG`:** Sinais de preempção assíncrona geravam contenção catastrófica em mutexes de kernel.

### A Solução Canônica:

Substituição da emulação por uma **máquina virtual minimalista headless Debian 13 (Trixie)** rodando sobre o hipervisor **Bhyve** (`192.168.8.2`):

- **Kernel Linux 6.12/GNU nativo:** Zero spin-loops, zero vazamento de memória e **0.0% de uso de CPU em repouso**.
- **Paridade de Identidade (UID/GID 1001):** Usuário `gabrielf` (host FreeBSD) e `gabriel` (guest Debian) compartilham rigorosamente o UID/GID 1001, eliminando conflitos de permissões.
- **Espelhamento via NFSv3:** O host exporta `/home/gabrielf` com a opção `-mapall=gabrielf 192.168.8.2`. O guest monta em `/home/gabrielf`. Qualquer mutação em arquivos grava instantaneamente no ZFS do host.
- **Despacho Transparente no Shell:** Funções `linux-host` (`lx`) e `agy-lx` (`agy`) em [`Shell/target/freebsd/bhyve.sh`](file:///home/gabrielf/Documents/Environment/Shell/target/freebsd/bhyve.sh) disparam comandos via SSH na VM, preservando o diretório de trabalho atual (`$PWD`) com fallback gracioso.
- **Sensibilidade Sensorial de Terminal (PTY vs Raw TTY):** Se o comando é disparado de um emulador gráfico, aloca pseudoterminal (`ssh -t`). Se disparado de um console físico puro (`ttyv*`), propaga `RAW_TTY=1` e `LC_RAW_TTY=1`, ativando prompts ASCII limpos sem mojibake ou fontes corrompidas.

---

## 🛡️ 3. Regras Constitucionais Invioláveis (Obrigações de Todo Agente)

### Regra 1: Bancada de Desenvolvimento vs. Runtimes de Produção

O diretório `~/Documents/Environment` é **exclusivamente a bancada de desenvolvimento e orquestração**. Nenhum artefato desta bancada deve ser consumido diretamente pelo sistema operacional hospedeiro. Em produção:

- `Shell` reside em `/usr/local/share/shell` (ou `~/.local/share/shell`).
- `Profile` reside em `~/.config/profile` (ou `~/.local/share/profile`).
- `Vault` reside em `~/.local/share/vault`.
- Editores residem em `~/.emacs.d`, `~/.config/nvim`, etc.

**Fluxo Canônico de Propagação:**

1. Alterações são codificadas e testadas na bancada (`~/Documents/Environment/<Componente>`).
2. Commits e pushes são realizados na bancada (`git push origin main`).
3. O ambiente de produção recebe atualizações exclusivamente via `git pull` (ou comandos oficiais `upsh`, `upall`, `sync-profile`).
4. **NUNCA** use `cp` avulso para arquivos de produção de forma a deixar working trees sujas.

### Regra 2: Refatoração Sem Legado (Clean-Break / Zero-Cruft Invariant)

O ecossistema é monousuário soberano governado por Gabriel Frigo. **NUNCA mantenha shims de retrocompatibilidade, wrappers obsoletos, arquivos `.bak` ou aliases legados.** Toda refatoração deve ser direta, atômica, limpa e definitiva.

### Regra 3: Invariante de Clonagem "Out-of-the-Box" (Zero-Tweaks Git Invariant)

O repositório deve funcionar imediatamente após um simples `git clone`, sem etapas manuais pós-clone (como `chmod +x` manual). Modos octais canônicos DEVEM estar registrados no Git Index:

- `0755` para scripts executáveis e hooks.
- `0644` para arquivos de configuração e documentação.
- `0700` e `0600` para diretórios e segredos do Vault.
  Scripts devem implementar auto-cura de permissões caso clonados sob filesystems não-POSIX (NTFS/FAT).

### Regra 4: Padrão Universal de Emissão de UI (`_ui_*`)

Saídas interativas de status no terminal DEVEM utilizar a biblioteca semântica canônica `_ui_*`:

- `_ui_step "Mensagem"`: Início de etapa (`==>`)
- `_ui_sub "Mensagem"`: Subtarefa (`↳`)
- `_ui_ok "Mensagem"`: Sucesso (`✅` / `[OK]`)
- `_ui_warn "Mensagem"`: Alerta (`⚠️ ` / `[AVISO]`)
- `_ui_err "Mensagem"`: Erro (`❌` / `[ERRO]`)
- `_ui_info "Mensagem"`: Informação neutra (`ℹ️ ` / `[INFO]`)
  **Proibido:** `echo` ad-hoc com emojis aleatórios sem tratamento semântico.

### Regra 5: Elevação Antifrágil e Shift Seguro

1. **Elevação:** Proibido o uso de ternários com subshell sob `set -e` (ex: `[ "$(id -u)" -eq 0 ] && ELEVATE="" || ELEVATE="sudo"` quebra sob root). Use sempre o bloco explícito:
    ```sh
    ELEVATE=""
    if [ "$(id -u)" -ne 0 ]; then
        if command -v sudo > "/dev/null" 2>&1; then
            ELEVATE="sudo"
        elif command -v doas > "/dev/null" 2>&1; then
            ELEVATE="doas"
        fi
    fi
    ```
2. **Shift Seguro:** Todo comando `shift` deve ser protegido por validação prévia de parâmetros:
    ```sh
    [ "$#" -ge 1 ] && shift
    ```

### Regra 6: Limite Estrito de Monólitos (≤ 256 Linhas)

Nenhum arquivo de código executável no ecossistema pode ultrapassar 256 linhas. Módulos volumosos devem ser decompostos em subarquivos em pastas dedicadas (ex: `core/`, `library/`, `modules/`).

### Regra 7: Geometria Canônica de Banners

- Réguas de cabeçalho superior: exatamente 64 hífens (`# ----------------------------------------------------------------`).
- Réguas de seção no corpo do script: `### ` seguido por exatamente 32 caracteres (`### ================================`).

---

## 🗂️ 4. Mapa das Tarefas Especializadas para Subagentes

Os agentes especializados possuem escopos isolados definidos nos seguintes arquivos operacionais em `.agents/tasks/`:

| Arquivo de Tarefa                            | Agente      | Escopo Principal                                                    | Modelo Recomendado / Alocação |
| :------------------------------------------- | :---------- | :------------------------------------------------------------------ | :---------------------------- |
| **[`agent1_setup.md`](agent1_setup.md)**     | **Agent 1** | Refatoração e Elevação Modular do Setup (Épico 8)                   | **Flash / Inherit**           |
| **[`agent2_emacs.md`](agent2_emacs.md)**     | **Agent 2** | Arquitetura Modular & Auto-Detecção Sensorial do Emacs (Épico 9)    | **Flash / Inherit**           |
| **[`agent3_shells.md`](agent3_shells.md)**   | **Agent 3** | Migração de Shells Alternativos: Profile ➔ Shell (Épico 10)         | **Flash / Inherit**           |
| **[`agent4_vault.md`](agent4_vault.md)**     | **Agent 4** | Blindagem e Ferramentas do Vault (`audit-vault.sh`, `age`, backups) | **Flash / Inherit**           |
| **[`agent5_editors.md`](agent5_editors.md)** | **Agent 5** | Otimização da Suíte de Editores Modais (NeoVim, Helix, Vim)         | **Flash / Inherit**           |

---

## 🧪 5. Quality Gates e Comandos de Validação Canônicos

Ao concluir qualquer alteração em qualquer repositório, o agente DEVE rodar a suíte de validação:

```sh
# Na raiz do Environment:
make audit              # Executa auditoria estática completa em todos os repositórios
make test               # Valida sintaxe POSIX e consistência dos módulos
git status              # Assegura árvore de trabalho limpa
```

Em submódulos individuais:

- **`Setup/`:** `python3 .scripts/audit/all.py`
- **`Profile/`:** `python3 .scripts/audit/all.py`
- **`Shell/`:** `make test` && `make bench`
- **`Vault/`:** `sh -n vault.sh`
- **`Helix/`:** `make test`
- **`NeoVim/`:** `make test`
- **`Emacs/`:** `make test`
