# 🖥️ Virtualização Bhyve: Debian 13.7 (amd64)

Guia de criação, parametrização e operação da máquina virtual Debian 13.7 sobre o hipervisor Bhyve no FreeBSD.

---

## 1. Template da Máquina Virtual

Arquivo de configuração `/zroot/vm/.templates/debian.conf`:

```text
loader="uefi"
cpu=4
memory=2G
network0_type="virtio-net"
network0_switch="public"
disk0_type="virtio-blk"
disk0_name="disk0.img"
utctime="yes"
```

> [!NOTE]
> A fixação de `memory=2G` evita a retenção excessiva de memória física cabeada (*wired memory*) pelo Bhyve, permitindo coexistência harmônica com o cache ZFS ARC do host.

---

## 2. Criação da VM e Instalação Inicial

```sh
# 1. Criar o volume e registrar a VM (4 vCPUs, 2 GB RAM, 16 GB disco ZFS)
sudo vm create -t debian -s 16G -m 2G -c 4 debian

# 2. Configurar temporariamente o suporte gráfico VNC em /zroot/vm/debian/debian.conf para instalação:
# graphics="yes"
# graphics_port="5900"
# graphics_res="1024x768"
# graphics_wait="yes"
# xhci_mouse="yes"

# 3. Disparar a instalação via ISO:
sudo vm install debian debian-13.7.0-amd64-netinst.iso

# 4. Em outro terminal, conectar via VNC para concluir a instalação:
vncviewer 127.0.0.1:5900
```

---

## 3. Transição para Modo Headless de Produção

Após concluir a instalação do Debian e gravar o GRUB na partição principal (`/dev/vda`), desativa-se a espera gráfica para permitir boot instantâneo em segundo plano:

```sh
# Desativar espera de cliente VNC
sudo sed -i '' 's/graphics_wait="yes"/graphics_wait="no"/' /zroot/vm/debian/debian.conf

# Iniciar a VM em modo headless
sudo vm start debian
```

---

## 4. Parâmetros de Rede e Usuário da VM Debian

* **Configuração de Rede Estática (Guest):**
  * **Endereço IP:** `192.168.8.2`
  * **Máscara de rede:** `255.255.255.0` (`/24`)
  * **Gateway:** `192.168.8.1` (Host FreeBSD)
  * **Servidores DNS:** `1.1.1.1`, `8.8.8.8`
  * **Hostname:** `debian`
* **Usuário local da VM:** `gabriel` (UID 1001)
* **Usuário local do Host:** `gabrielf` (UID 1001)

---

## 5. Permissões Administrativas sem Senha (Guest Debian)

Configuração de escalonamento sem interrupção de credenciais:

```sh
# 1. Configurar sudoers
echo "gabriel ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/gabriel
sudo chmod 0440 /etc/sudoers.d/gabriel

# 2. Configurar doas
echo "permit nopass gabriel as root" | sudo tee /etc/doas.conf
sudo chmod 0400 /etc/doas.conf
```

---

## 6. Autenticação SSH por Chave Pública (Host ➔ VM)

Garante comunicação e execução remota transparente:

```sh
# No host FreeBSD:
ssh-copy-id -i ~/.ssh/id_ed25519.pub gabriel@192.168.8.2
```

---

## 7. Espelhamento da Home via NFSv3

Permite que ferramentas no Debian acessem diretamente os diretórios de desenvolvimento (`Documents`, `Projects`, `~/.gemini`, `~/.config`) hospedados no ZFS:

### No Host FreeBSD:
```sh
# 1. Habilitar daemons NFS no /etc/rc.conf
sudo sysrc rpcbind_enable="YES" nfs_server_enable="YES" mountd_enable="YES"

# 2. Exportar /home/gabrielf mapeado para o UID nativo do host
echo "/home/gabrielf -alldirs -mapall=gabrielf 192.168.8.2" | sudo tee /etc/exports

# 3. Iniciar serviços de rede
sudo service rpcbind start
sudo service mountd restart
sudo service nfsd restart
```

### Na VM Debian (`ssh gabriel@192.168.8.2`):
```sh
# 1. Instalar cliente NFS
sudo apt update && sudo apt install -y nfs-common

# 2. Criar ponto de montagem idêntico ao caminho do FreeBSD
sudo mkdir -p /home/gabrielf
sudo chown 1001:1001 /home/gabrielf

# 3. Configurar montagem automática via NFSv3 no /etc/fstab
echo "192.168.8.1:/home/gabrielf /home/gabrielf nfs rw,soft,intr,nfsvers=3 0 0" | sudo tee -a /etc/fstab
sudo mount /home/gabrielf
```

---

## 8. Implantação do Binário do Agente (`agy`)

```sh
# No host FreeBSD:
scp /usr/local/bin/agy gabriel@192.168.8.2:/tmp/
ssh gabriel@192.168.8.2 "sudo mv /tmp/agy /usr/local/bin/agy && sudo chmod 0755 /usr/local/bin/agy"
```

---

## 9. Integração com o Shell Interativo

Acesso unificado e transparente a partir do terminal do FreeBSD através da função [`linux-host`](file:///home/gabrielf/Documents/Environment/04-antigravity-cli-dual-exec.md) e seus atalhos (`linux`, `lx`, `debian`, `deb`).
