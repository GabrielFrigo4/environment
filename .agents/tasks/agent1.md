# 🤖 Agent 1: Refatoração, Modularização & Elevação do Universal Setup

> **Plano Operacional Especializado — Épico 8 do Ecossistema**
> 🔒 **Trava de Modelo:** Exclusivo **Gemini Pro 4** (demanda raciocínio aprofundado para arquitetura modular de receitas multi-SO, portabilidade POSIX estrita e testes de estresse em matrizes de sistemas operacionais).
> **Referência Obrigatória Prévia:** Leia atentamente o [`all_agents.md`](all_agents.md).

---

## 🎯 1. Objetivo Central da Missão

Transformar o repositório **Universal Setup** (`~/Documents/Environment/Setup`), atualmente funcional porém com dívidas de rusticidade arquitetural, em uma plataforma modular, desacoplada, atômica, idempotente e estritamente aderente aos 22 Princípios UNIX e ao padrão visual `_ui_*`.

---

## 🗺️ 2. Topografia de Arquivos a Explorar

O agente deve mapear e inspecionar os seguintes componentes:

1. **Orquestrador Central:**
    - [`Setup/setup.sh`](file:///home/gabrielf/Documents/Environment/Setup/setup.sh): Entrypoint que atualmente agrega de forma rústica a chamada de sub-receitas.
2. **Receitas Compartilhadas Multi-SO:**
    - `Setup/common/cli/`: Multiplexadores (`tmux.sh`, `zellij.sh`), editores, shells, git.
    - `Setup/common/ai/`: Instaladores do Ollama e coding agents.
    - `Setup/common/security/`: Wireshark, ferramentas de auditoria.
3. **Provisionamento por Plataforma:**
    - `Setup/freebsd/`: Scripts em `desktop/`, `server/`, `container/` (Bhyve, Jails, áudio OSS, pacotes pkg).
    - `Setup/linux/`: Scripts em `desktop/`, `server/` e por distribuição (`debian/`, `arch/`, `fedora/`, `void/`, `alpine/`).
    - `Setup/windows/`: Scripts em `native/`, `powershell/`, `batch/` (Winget, Chocolatey, MSYS2).
4. **Suíte de Auditoria Contínua:**
    - [`Setup/.scripts/audit/all.py`](file:///home/gabrielf/Documents/Environment/Setup/.scripts/audit/all.py): Contém os 6 quality gates estáticos (`monoliths.py`, `nanos.py`, `syntax.py`, `banners.py`, `links.py`, `formats.py`).

---

## 📋 3. Roteiro Metódico de Execução (Passo a Passo)

### Fase 1: Fundação & Modularização de Core (`Setup/core/`)

- [x] Criar a pasta canônica `Setup/core/` (espelhando a arquitetura limpa de `Profile/core/` e `Vault/core/`).
- [x] Implementar `Setup/core/ui.sh`: Biblioteca semântica `_ui_*` com suporte a cores ANSI seguras e degradação em TTYs puros.
- [x] Implementar `Setup/core/elevate.sh`: Resolução antifrágil de privilégios (`if [ "$(id -u)" -ne 0 ]`) com detecção de `sudo`, `doas` ou execução root.
- [x] Implementar `Setup/core/detect.sh`: Detecção robusta de sistema operacional (`FreeBSD`, `Debian`, `Arch`, `Fedora`, `Void`, `Alpine`, `Windows/MSYS2`) e gerenciador de pacotes ativo (`pkg`, `apt`, `pacman`, `dnf`, `xbps`, `apk`, `winget`).
- [x] Refatorar `Setup/setup.sh` para atuar puramente como despachante de linha de comando com menos de 128 linhas, delegando lógica pesada para `core/`.

### Fase 2: Refatoração das Receitas Multi-SO (`Setup/common/`)

- [x] Migrar cada script em `Setup/common/` para importar `core/ui.sh` e `core/elevate.sh`.
- [x] Substituir todo `echo "==> ..."` avulso por `_ui_step`, `_ui_sub`, `_ui_ok`, `_ui_warn` e `_ui_err`.
- [x] Implementar **idempotência ativa**: Antes de disparar comandos de download ou gerenciadores de pacotes, verificar se o binário já existe no `PATH` (`command -v nome_do_binario`). Se já existir, emitir `_ui_ok "Binário já instalado"` e pular com segurança.

### Fase 3: Paridade e Modernização de Distribuições Linux

- [x] Padronizar os scripts sob `Setup/linux/` para que cada distribuição suporte as mesmas classes de ferramentas básicas.
- [x] Eliminar bashismos em instaladores de shell (`[[ ]]` ➔ `[ ]`, `&>` ➔ `> ... 2>&1`, `source` ➔ `.`).
- [x] Assegurar shebang universal `#!/usr/bin/env sh` em todos os scripts POSIX.

### Fase 4: Refinamento das Receitas do FreeBSD

- [x] Alinhar receitas de áudio (`sndiod` / OSS) e aceleração gráfica DRM/KMS.
- [x] Validar a receita de container Bhyve (`Setup/freebsd/container/bhyve.sh`) garantindo persistência sem duplicar linhas no `/etc/rc.conf` (utilizar `sysrc`).

### Fase 5: Auditoria Estática & Quality Gates

- [x] Executar `python3 .scripts/audit/all.py` e garantir 100% de aprovação em todos os 6 testes.
- [x] Garantir que nenhum arquivo exceda 256 linhas (`monoliths.py`).
- [x] Garantir que nenhum script executável tenha menos de 8 linhas (`nanos.py`).
- [x] Validar geometria de réguas (64 hífens no topo, 32 caracteres com `### ` no corpo).

---

## ⚠️ 4. Invariantes Críticas & Gotchas

1. **Nunca quebre a instalação existente:** Teste alterações com flags `--dry-run` ou simulações defensivas quando possível.
2. **Elevação Segura:** NUNCA reintroduza ternários em subshell para resolução de privilégios. Use o bloco explícito do Pilar 6.
3. **Shift Seguro:** Todo `shift` deve ser protegido com `[ "$#" -ge N ] && shift N`.
4. **Permissões no Git Index:** Qualquer script executável novo deve ser comitado com permissão `0755` (`git update-index --chmod=+x caminho/script.sh`).
5. **Zero Cruft:** Não deixe arquivos de backup como `setup.sh.bak` ou `antigo_script.sh`. Se for refatorado, substitua no local.
