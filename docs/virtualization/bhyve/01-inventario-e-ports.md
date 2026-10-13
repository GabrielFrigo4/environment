# 📦 Inventário do Sistema e Script de Ports

Documento de inventário e rastreabilidade para o ecossistema híbrido **FreeBSD Host + Bhyve Debian**.

---

## 1. Pacotes Instalados no Host (FreeBSD via `pkg`)

- **`vm-bhyve`**: Utilitário de gestão do ciclo de vida de máquinas virtuais, switches e templates do Bhyve (fornece `/usr/local/sbin/vm`).
- **`bhyve-firmware`**: Imagens binárias de firmware UEFI (EDK2) para inicialização de sistemas operacionais modernos em 64 bits.
- **`tigervnc-viewer`**: Cliente VNC gráfico (`vncviewer`) utilizado durante a etapa de instalação interativa do sistema operacional guest.

---

## 2. Imagens ISO e Mídias de Instalação

- **`debian-13.7.0-amd64-netinst.iso`**: Imagem oficial de instalação de rede (_netinst_) do Debian 13.7 (amd64), armazenada canonicamente em `/zroot/vm/.iso/debian-13.7.0-amd64-netinst.iso`.

---

## 3. Binários e Scripts Locais no Host

- **`/usr/local/bin/agy`**: Binário Linux do Google Antigravity CLI (instalado no FreeBSD para contenção legada via Linuxulator e transferido para o Debian guest).
- **`/usr/local/bin/upports`**: Script POSIX de sincronização e atualização da árvore `/usr/ports` via Git.

---

## 4. Pacotes Instalados e Configurados na VM (Debian via `apt`)

- **`nfs-common`**: Suporte a montagens cliente de rede NFS (fornece `/sbin/mount.nfs`, indispensável para montagens NFSv3).
- **`sudo`**: Privilégios administrativos sem senha em `/etc/sudoers.d/gabriel` (`NOPASSWD: ALL`).
- **`doas`**: Alternativa leve de escalonamento sem senha configurada em `/etc/doas.conf` (`permit nopass gabriel as root`).
- **`curl`**: Utilitário de transferência HTTP/HTTPS para download de ferramentas e testes de conectividade.
- **`/usr/local/bin/agy`**: Binário Linux instalado em `/usr/local/bin/` na VM para execução nativa e isolada do agente de IA.

---

## 5. Script Canônico `/usr/local/bin/upports`

Atualiza a árvore local do FreeBSD Ports via Git _fast-forward_ sem alterar pacotes instalados no sistema:

```sh
#!/usr/bin/env sh
set -eu

PORTS_DIR="/usr/ports"

if [ ! -d "${PORTS_DIR}/.git" ]; then
    echo "==> Repositório não encontrado. Clonando árvore oficial..."
    sudo git clone --depth 1 https://git.freebsd.org/ports.git "${PORTS_DIR}"
else
    echo "==> Atualizando árvore do FreeBSD Ports (${PORTS_DIR})..."
    sudo git -C "${PORTS_DIR}" pull --ff-only
fi
```
