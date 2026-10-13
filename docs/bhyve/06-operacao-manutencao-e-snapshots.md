# 🛠️ Operação, Manutenção e Snapshots (ZFS + Bhyve)

Runbook operacional para manutenção, snapshots atômicos de disco no ZFS, gestão do ciclo de vida da máquina virtual e rotinas de atualização no ecossistema **FreeBSD + Bhyve**.

---

## 1. Alinhamento de Identidades POSIX (UID/GID 1001)

Para evitar que permissões de arquivos (`0600`/`0700`) bloqueiem acessos via NFSv3, a VM Debian tem o UID e GID do usuário `gabriel` configurados para espelhar exatamente o `gabrielf` do FreeBSD:

- **Host FreeBSD:** `uid=1001(gabrielf)` / `gid=1001(gabrielf)`
- **Guest Debian:** `uid=1001(gabriel)` / `gid=1001(gabriel)`

Caso a VM seja reconstruída a partir da ISO original, execute o realinhamento no guest:

```sh
ssh gabriel@192.168.8.2 'sudo sh -c "
sed -i \"s/^gabriel:x:1000:1000:/gabriel:x:1001:1001:/\" /etc/passwd
sed -i \"s/^gabriel:x:1000:/gabriel:x:1001:/\" /etc/group
chown -R 1001:1001 /home/gabriel
"'
```

---

## 2. Snapshots Atômicos da VM com ZFS

Antes de executar atualizações volumosas no Debian (`apt dist-upgrade`) ou modificar pacotes da base, capture um snapshot do dataset do Bhyve diretamente no host FreeBSD:

```sh
# 1. Criar snapshot instantâneo do volume da VM
sudo zfs snapshot zroot/vm/debian@pre-upgrade

# 2. Listar snapshots para conferência
zfs list -t snapshot | grep debian

# 3. Reversão imediata caso ocorra corrupção ou quebra do sistema guest:
sudo vm stop -f debian
sudo zfs rollback zroot/vm/debian@pre-upgrade
sudo vm start debian

# 4. Destruir snapshot após homologar a estabilidade do sistema
sudo zfs destroy zroot/vm/debian@pre-upgrade
```

---

## 3. Gestão do Ciclo de Vida da VM (`vm-bhyve`)

Comandos executados diretamente no terminal do host FreeBSD:

- **Listar status detalhado das VMs:**
    ```sh
    vm list
    ```
- **Parada graciosa via sinal ACPI:**
    ```sh
    sudo vm stop debian
    ```
- **Desligamento forçado imediato:**
    ```sh
    sudo vm poweroff debian
    ```
- **Acessar console serial de texto (emergência se a rede falhar):**
    ```sh
    sudo vm console debian
    # Para sair do console: pressione ~. (til seguido de ponto)
    ```

---

## 4. Atualização do Binário `agy`

Quando uma nova versão compilada ou instalador do agente de IA for obtido:

```sh
# Enviar o binário do host FreeBSD para a VM e ajustar permissões executáveis
scp /usr/local/bin/agy gabriel@192.168.8.2:/tmp/
ssh gabriel@192.168.8.2 "sudo mv /tmp/agy /usr/local/bin/agy && sudo chmod 0755 /usr/local/bin/agy"
```

---

## 5. Rotina de Atualização: `update-linux`

O ecossistema implementa a função canônica [`update-linux`](file:///home/gabrielf/Documents/Environment/04-antigravity-cli-dual-exec.md) (com atalhos `uplx` e `updeb`), além de ser acionada automaticamente pelo comando global [`update-all`](file:///home/gabrielf/Documents/Environment/Shell/library/functions.sh) (`upall`) quando executado no FreeBSD:

```sh
# Execução manual pelo terminal
update-linux
# ou via atalhos:
uplx
updeb
```

Comando interno executado na VM via SSH (dispara o `update-all` do Shell no guest, com fallback para apt):

```sh
ssh -t gabriel@192.168.8.2 "if command -v zsh > '/dev/null' 2>&1 && [ -f \"\${HOME}/.zshrc\" ]; then zsh -ic 'update-all'; else sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y; fi"
```

---

## 6. Checklist de Diagnóstico Rápido

Caso a invocação do `agy` ou do `linux-host` falhe ou trave:

1. **A VM está em execução?**
    ```sh
    vm list
    ```
2. **A interface de rede da bridge responde a ping?**
    ```sh
    ping -c 2 192.168.8.2
    ```
3. **O servidor NFS do FreeBSD está anunciando os diretórios?**
    ```sh
    showmount -e 127.0.0.1
    ```
4. **O ponto de montagem está montado no guest?**
    ```sh
    ssh gabriel@192.168.8.2 "df -h | grep /home/gabrielf"
    ```

---

## 7. Biblioteca Canônica de Integração com o Shell

Trecho consolidado em conformidade estrita POSIX `/bin/sh` para injeção no ambiente:

```sh
# ================================================================
# Bhyve Debian: Boot Sob Demanda e Paridade de Shell
# ================================================================

_ensure_debian_running() {
    if ! vm list 2> "/dev/null" | grep -q "debian.*Running"; then
        echo "==> Iniciando máquina virtual Debian no Bhyve..."
        sudo vm start debian
        sleep 2
    fi
}

linux-host() {
    _ensure_debian_running

    _target_dir="/home/gabrielf"
    case "${PWD}" in
        /home/gabrielf|/home/gabrielf/*)
            _target_dir="${PWD}"
            ;;
    esac

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

update-linux() {
    _ensure_debian_running
    echo "==> Atualizando máquina virtual Linux-host (Bhyve)..."
    ssh -t gabriel@192.168.8.2 \
        "if command -v zsh > '/dev/null' 2>&1 && [ -f \"\${HOME}/.zshrc\" ]; then zsh -ic 'update-all'; else sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y; fi"
}

# Aliases de Atalho
alias debian="linux-host"
alias deb="linux-host"
alias linux="linux-host"
alias lx="linux-host"
alias agy="agy-lx"
alias agy-bh="agy-lx"
alias uplx="update-linux"
alias updeb="update-linux"
```
