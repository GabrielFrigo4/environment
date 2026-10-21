# 🗺️ Roadmap & Status — Universal Environment

> **Status:** 🟢 **100% Operacional & Estável — Zero Pendências Ativas**
> O orquestrador central do Quarteto de Produtividade atingiu maturidade arquitetural plena. Todos os 10 grandes épicos do ecossistema foram integralmente entregues, testados e auditados em Linux, FreeBSD e Windows.

---

## 📊 Matriz de Maturidade do Ecossistema

| Repositório              | Papel                       | Maturidade | Cobertura / Estado                                                       |
| :----------------------- | :-------------------------- | :--------: | :----------------------------------------------------------------------- |
| **Environment**          | Hub central & Makefile      | 🟢 Estável | Orquestração global, documentação canônica e submódulos Git              |
| **Shell**                | Motor de terminal & prompts |  🟢 100%   | Latência < 16ms, consoles TTY/PTY, prompts pill/micro, TUI `_ui_*`       |
| **Setup**                | Provisionador de sistema    | 🟢 Estável | Arquitetura modular `core/`, receitas idempotentes e paridade            |
| **Vault**                | Cofre privado de segredos   | 🟢 Estável | Chaves SSH, auditoria canônica `age`, backups e `.env` seguros           |
| **Profile**              | Dotfiles & skills de IA     | 🟢 Estável | Paridade multiplataforma, foco em emuladores gráficos e skills           |
| **Emacs**                | Editor Elisp extensível     | 🟢 Estável | Arquitetura sensorial, tipografia adaptativa, console TTY e IA `gemma4`  |
| **Helix / NeoVim / Vim** | Suíte de Editores modais    | 🟢 Estável | Runtimes soberanos, Mason LSP, fallbacks TTY 16 cores e mouse gpm/moused |
| **Template**             | Arquétipo de novos projetos | 🟢 Estável | Scaffolding `init.sh`, suíte de auditoria e TUI semântica                |

---

## 🛡️ Atributos e Conquistas Centrais

- **Zero Pendências:** 100% dos épicos (Otimização do Shell, Lapidação do Profile, Invariante Out-of-the-Box, AI Skills, Paridade Windows Tripartite, Modularização de Scripts, Virtualização Híbrida Bhyve, Portal Canônico de Docs, Refatoração do Setup e GNU Emacs Sensorial) foram integralmente concluídos e verificados.
- **Suíte Tripartite Windows Hardened:** Resolução da inconsistência dual `Path`/`PATH` no NuShell, eliminação de recursão de aliases circulares no PowerShell (`Clean-System`) e paridade total de atalhos do Antigravity CLI (`agy`).
- **Paridade Universal em Loaders do Vault:** Garantia de que todos os carregadores (`vault.sh`, `vault.ps1`, `vault.nu`, etc.) excluam uniformemente arquivos de template e exemplo, blindando o ecossistema contra vazamento de tokens fictícios.
- **Auto-Cura Reentrante Multi-Shell:** Propagação cruzada automática de perfis físicos em disco (`Documents\PowerShell`, `%APPDATA%\nushell`, `%LOCALAPPDATA%\clink`) via `upsh` e `resh` sem qualquer intervenção manual de cópia.
- **Higienização Pré-Pull na Suíte de Editores:** Limpeza defensiva de stubs locais (`usr/local/`) em `Update-Editors` prevenindo abortos de `git pull --ff-only`.
- **Paridade UTF-8 no Git:** Configuração universal `core.quotepath = false` garantindo legibilidade de caminhos acentuados em todas as plataformas.
- **Hermetismo e Soberania:** O ecossistema é 100% autônomo e opera sem qualquer dependência externa ou intervenção manual pós-clone.
- **Engenharia Antifrágil:** Conformidade estrita com os 22 Princípios UNIX, réguas de 32/64 colunas, biblioteca semântica `_ui_*` e quality gates automatizados.

---

## 📌 Backlog & Próximos Passos

> **Zero Pendências:** Nenhum item ativo no backlog central. Melhorias contínuas e refinamentos operacionais são despachados de forma contínua e atômica.

### Setup Operate Sistem (e Shell tambem)

- [ ] Baixar seatd, cage, foot e wlr-randr para Linux e FreeBSD
- [ ] Habilitar o moused e o keyrate="fast" no TTY do FreeBSD
- [ ] Baixar e Habilitar o gpm no Linux
- [ ] Baixar terminus-fonts-console no Linux
- [ ] Baixar terminus-fonts no Linux e FreeBSD
- [ ] Baixar terminus-ttf no Linux e FreeBSD
- [ ] Configurar o moused no FreeBSD

```
#!/usr/bin/env bash
set -euo pipefail

doas sysrc -x moused_port 2>/dev/null || true
doas sysrc -x moused_type 2>/dev/null || true
doas sysrc moused_enable="NO"
doas sysrc keyrate="fast"

cat << 'EOF' | doas tee /usr/local/sbin/moused-auto > /dev/null
#!/bin/sh
killall -9 moused 2>/dev/null
sleep 0.5
libinput list-devices 2>/dev/null | awk '
    /^Device:/ { dev=$0 }
    /^Kernel:/ {
        node=$2
        if (dev ~ /(Mouse|TouchPad)/ && dev !~ /System mouse/) {
            print node
        }
    }
' | sort -u | while read -r devnode; do
    if [ -c "$devnode" ]; then
        /usr/sbin/moused -p "$devnode" -t evdev
    fi
done
EOF

doas chmod +x /usr/local/sbin/moused-auto

cat << 'EOF' | doas tee /etc/devd/moused_hotplug.conf > /dev/null
notify 100 {
    match "system" "DEVFS";
    match "subsystem" "CDEV";
    match "type" "CREATE";
    match "cdev" "input/event[0-9]+";
    action "/usr/local/sbin/moused-auto";
};
EOF

cat << 'EOF' | doas tee /etc/rc.local > /dev/null
#!/bin/sh
/usr/local/sbin/moused-auto
EOF

doas chmod +x /etc/rc.local

doas service devd restart
doas /usr/local/sbin/moused-auto

pgrep -lf moused
```

- [ ] Corrigir o cage para funcionar com a aparencia do sistema correta (isso é um script mas eu vou converter para uma função chamada gui pro Shell, esse codigo ai é um rascunho apenas...)

```
#!/usr/bin/env sh
set -e

export XDG_RUNTIME_DIR="/tmp/runtime-$(id -u)"
if [ ! -d "$XDG_RUNTIME_DIR" ]; then
    mkdir -p -m 0700 "$XDG_RUNTIME_DIR"
fi

export XKB_DEFAULT_LAYOUT="br"
export XKB_DEFAULT_MODEL="abnt2"
export WLR_KEYBOARD_REPEAT_DELAY=200
export WLR_KEYBOARD_REPEAT_RATE=50

export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=kde
export QT_STYLE_OVERRIDE=Breeze
export XCURSOR_THEME=breeze_cursors
export XCURSOR_SIZE=36
export QT_SCALE_FACTOR=1.25

exec cage -- "${@:-foot}"
```

### Emacs No Window

- [ ] Habilitar o uso do Mouse no Emacs No Window (xterm-mouse-mode)
- [ ] Habilitar o uso de Respostas curstas no Emacs (use-short-answers t)
- [ ] Desativar som irritando do Emacs (ring-bell-function #'ignore)

### Emacs Geral

- [ ] Corrigir mensagens de erro obsolete para Pacotes Externos

```
Wrote /home/gabrielf/cage.sh
.emacs.d/var/lib/elpaca/builds/apheleia/apheleia-formatters.el: Warning: ‘when-let’ is an obsolete macro (as of 31.1); use ‘when-let*’ or ‘and-let*’ instead. [5 times]
.emacs.d/var/lib/elpaca/builds/apheleia/apheleia-rcs.el: Warning: ‘when-let’ is an obsolete macro (as of 31.1); use ‘when-let*’ or ‘and-let*’ instead.
Mark set
```

---

> [!TIP]
> Para detalhes sobre a arquitetura e convenções de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
