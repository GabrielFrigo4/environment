# 🚀 Execução do Shell e Antigravity CLI: Bhyve Runtime vs. Linuxulator

Estratégia de integração no terminal FreeBSD para despacho transparente de comandos Linux, execução do **Google Antigravity CLI (`agy`)** e preservação da receita de contenção no Linuxulator.

---

## 1. Funções de Integração para o Shell (`~/.zshrc` e `/bin/sh`)

```sh
# ================================================================
# 1. Rotina de Inicialização Sob Demanda da VM
# ================================================================
_ensure_debian_running() {
    if ! vm list 2> "/dev/null" | grep -q "debian.*Running"; then
        echo "==> Iniciando máquina virtual Debian no Bhyve..."
        sudo vm start debian
        sleep 2
    fi
}

# ================================================================
# 2. linux-host: Shell Interativo e Runner com Paridade de Pastas
# Aliases: linux, lx, debian, deb
# ================================================================
linux-host() {
    _ensure_debian_running

    # Antifragilidade de diretórios:
    # Se o usuário estiver dentro de /home/gabrielf, preserva o caminho relativo;
    # se estiver fora (ex: /usr/ports, /tmp) ou a pasta não existir no guest,
    # faz fallback automático para /home/gabrielf.
    _target_dir="/home/gabrielf"
    case "${PWD}" in
        /home/gabrielf|/home/gabrielf/*)
            _target_dir="${PWD}"
            ;;
    esac

    # Conformidade POSIX: sem arrays Bash
    _tty=""
    [ -t 0 ] && [ -t 1 ] && _tty="-t"

    if [ $# -gt 0 ]; then
        ssh ${_tty} gabriel@192.168.8.2 \
            "cd \"${_target_dir}\" 2> /dev/null || cd /home/gabrielf; env HOME=/home/gabrielf $*"
    else
        ssh -t gabriel@192.168.8.2 \
            "cd \"${_target_dir}\" 2> /dev/null || cd /home/gabrielf; env HOME=/home/gabrielf exec \${SHELL:-/bin/bash} -l"
    fi
}

alias linux="linux-host"
alias lx="linux-host"
alias debian="linux-host"
alias deb="linux-host"

# ================================================================
# 3. agy-lx: Antigravity CLI no Linux-Host via Bhyve (Padrão)
# Alias: agy
# ================================================================
agy-lx() {
    _ensure_debian_running

    _target_dir="/home/gabrielf"
    case "${PWD}" in
        /home/gabrielf|/home/gabrielf/*)
            _target_dir="${PWD}"
            ;;
    esac

    _tty=""
    [ -t 0 ] && [ -t 1 ] && _tty="-t"

    ssh ${_tty} gabriel@192.168.8.2 \
        "cd \"${_target_dir}\" 2> /dev/null || cd /home/gabrielf; env HOME=/home/gabrielf agy $*"
}

alias agy="agy-lx"

# ================================================================
# 4. agy-compat: Execução Local no FreeBSD Compat (Contenção)
# Arquivo: Shell/target/freebsd/compat.sh
# Modo efêmero ("one-shot"). Vaza ~14 MB/min se deixado aberto.
# Preserva o estudo minucioso de tuning do kernel e runtime Go.
# ================================================================
export COMPAT_GODEBUG="netdns=go,http2client=0,asyncpreemptoff=1"
export COMPAT_GOMAXPROCS=2
export COMPAT_GOGC=8
export COMPAT_GOMEMLIMIT="1GiB"

agy-compat() {
    _ncpu="$(sysctl -n hw.ncpu 2> "/dev/null" || echo 4)"
    _running_count="$(pgrep -x agy 2> "/dev/null" | wc -l | tr -d ' ')"
    [ -z "${_running_count}" ] && _running_count=0
    _c1=$(( (_running_count * 2) % _ncpu ))
    _c2=$(( (_running_count * 2 + 1) % _ncpu ))

    _has_log=0
    for _arg in "$@"; do
        case "${_arg}" in
            *--log-file*) _has_log=1; break ;;
        esac
    done

    if [ "${_has_log}" -eq 1 ]; then
        limits -v 8g \
            env GODEBUG="${COMPAT_GODEBUG}" \
                GOMAXPROCS="${COMPAT_GOMAXPROCS}" \
                GOGC="${COMPAT_GOGC}" \
                GOMEMLIMIT="${COMPAT_GOMEMLIMIT}" \
            cpuset -l "${_c1},${_c2}" nice -n 16 \
            /usr/local/bin/agy "$@"
    else
        limits -v 8g \
            env GODEBUG="${COMPAT_GODEBUG}" \
                GOMAXPROCS="${COMPAT_GOMAXPROCS}" \
                GOGC="${COMPAT_GOGC}" \
                GOMEMLIMIT="${COMPAT_GOMEMLIMIT}" \
            cpuset -l "${_c1},${_c2}" nice -n 16 \
            /usr/local/bin/agy --log-file /dev/null "$@"
    fi
}

alias agy-cp="agy-compat"
```
