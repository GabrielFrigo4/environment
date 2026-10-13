# ⚙️ Provisionamento do Host FreeBSD e Instalação da VM Debian

> Guia passo a passo para calibração do kernel FreeBSD, roteamento PF com NAT, provisionamento do hipervisor Bhyve e configuração do Debian 13 guest.

---

## 📦 1. Pré-Requisitos e Pacotes no Host FreeBSD

O provisionamento do ecossistema Bhyve no FreeBSD requer a instalação dos seguintes pacotes oficiais via `pkg`:

```sh
sudo pkg install -y vm-bhyve bhyve-firmware tigervnc-viewer
```

- **`vm-bhyve`**: Utilitário de gestão do ciclo de vida de VMs, switches virtuais e templates (fornece o comando `/usr/local/sbin/vm`).
- **`bhyve-firmware`**: Imagens binárias de firmware UEFI (EDK2) para inicialização de sistemas modernos de 64 bits.
- **`tigervnc-viewer`**: Cliente VNC (`vncviewer`) utilizado exclusivamente durante a instalação interativa inicial do Debian.

As receitas automatizadas deste processo residem em [`Setup/freebsd/container/bhyve.sh`](file:///home/gabrielf/Documents/Environment/Setup/freebsd/container/bhyve.sh) e [`Setup/linux/desktop/debian/bhyve-guest.sh`](file:///home/gabrielf/Documents/Environment/Setup/linux/desktop/debian/bhyve-guest.sh).

---

## ⚙️ 2. Calibração do Kernel e Governança do ZFS ARC

O OpenZFS moderno no FreeBSD gerencia dinamicamente o ARC em coordenação com o subsistema de memória virtual (VM pager) do kernel. Para evitar contenção entre o ARC e a memória física alocada (_wired memory_) pelo hipervisor, dimensionamos a VM para 2 GB de RAM e desativamos a filtragem de pacotes nas bridges virtuais.

Configurações persistentes aplicadas em `/etc/rc.conf` e `/etc/sysctl.conf`:

```sh
# 1. Habilitar encaminhamento de rede e serviços essenciais no /etc/rc.conf
sudo sysrc gateway_enable="YES"
sudo sysrc pf_enable="YES"
sudo sysrc pf_rules="/etc/pf.conf"
sudo sysrc vm_enable="YES"
sudo sysrc vm_dir="zfs:zroot/vm"

# 2. Desativar filtragem do firewall nas interfaces da bridge no /etc/sysctl.conf
sudo sysrc -f /etc/sysctl.conf net.link.bridge.pfil_member=0
sudo sysrc -f /etc/sysctl.conf net.link.bridge.pfil_bridge=0

# 3. Aplicar parâmetros de sysctl imediatamente
sudo sysctl net.link.bridge.pfil_member=0
sudo sysctl net.link.bridge.pfil_bridge=0
```

---

## 🛡️ 3. Configuração de Rede: Firewall PF com NAT Dual-Homed

A máquina virtual opera no segmento de rede isolado `192.168.8.0/24`. O host FreeBSD realiza a tradução de endereços (NAT) comutando dinamicamente entre a interface cabeada (`re0`) e a sem fio (`wlan0`).

Regras canônicas em `/etc/pf.conf`:

```pf
# Tradução de endereços (NAT) para o segmento da VM Bhyve (192.168.8.0/24)
match out on re0 inet from 192.168.8.0/24 to any nat-to (re0) round-robin
match out on wlan0 inet from 192.168.8.0/24 to any nat-to (wlan0) round-robin

# Passagem de tráfego com rastreamento de estado
pass all flags S/SA keep state
```

Carregamento das regras e ativação do Packet Filter:

```sh
sudo pfctl -f /etc/pf.conf
sudo pfctl -e 2> "/dev/null" || true
```

Criação do switch virtual e fixação do IP do gateway (`192.168.8.1`):

```sh
sudo vm switch create public 2> "/dev/null" || true
sudo vm switch address public 192.168.8.1/24
```

---

## 🖥️ 4. Template e Criação da VM Debian

O template em `/zroot/vm/.templates/debian.conf` padroniza os recursos alocados para o runtime:

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

Criação do volume da VM (4 vCPUs, 2 GB RAM, 16 GB disco ZFS):

```sh
sudo vm create -t debian -s 16G -m 2G -c 4 debian
```

### Instalação Interativa via ISO:

1. Obtenha a imagem oficial netinst do Debian (armazenada em `/zroot/vm/.iso/debian-13.7.0-amd64-netinst.iso`).
2. Adicione temporariamente os parâmetros gráficos em `/zroot/vm/debian/debian.conf`:
    ```text
    graphics="yes"
    graphics_port="5900"
    graphics_res="1024x768"
    graphics_wait="yes"
    xhci_mouse="yes"
    ```
3. Dispare a instalação:
    ```sh
    sudo vm install debian debian-13.7.0-amd64-netinst.iso
    ```
4. Em outro terminal, conecte o cliente VNC:
    ```sh
    vncviewer 127.0.0.1:5900
    ```
5. Conclua a instalação padrão do Debian instalando o GRUB no disco principal (`/dev/vda`).

### Transição para Modo Headless de Produção:

Após a instalação, desative a espera do VNC para que a VM inicialize instantaneamente em segundo plano:

```sh
sudo sed -i '' 's/graphics_wait="yes"/graphics_wait="no"/' /zroot/vm/debian/debian.conf
sudo vm start debian
```

---

## 🌐 5. Pós-Instalação no Convidado Debian (Rede, Usuário e Acesso)

Conecte-se à VM e aplique os parâmetros de governança:

### Parâmetros de Rede Estática (Debian Guest):

- **IP:** `192.168.8.2/24`
- **Gateway:** `192.168.8.1` (Host FreeBSD)
- **DNS:** `1.1.1.1`, `8.8.8.8`
- **Hostname:** `debian`

### Alinhamento de Identidades POSIX (UID/GID 1001):

O usuário `gabriel` no Debian deve possuir UID/GID idênticos ao usuário `gabrielf` do host:

```sh
sudo sed -i 's/^gabriel:x:1000:1000:/gabriel:x:1001:1001:/' /etc/passwd
sudo sed -i 's/^gabriel:x:1000:/gabriel:x:1001:/' /etc/group
sudo chown -R 1001:1001 /home/gabriel
```

### Escalonamento Administrativo sem Senha:

```sh
# Configurar sudoers
echo "gabriel ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/gabriel
sudo chmod 0440 /etc/sudoers.d/gabriel

# Configurar doas
echo "permit nopass gabriel as root" | sudo tee /etc/doas.conf
sudo chmod 0400 /etc/doas.conf
```

### Autenticação SSH por Chave Pública:

No host FreeBSD, propague a chave pública para login sem senha:

```sh
ssh-copy-id -i ~/.ssh/id_ed25519.pub gabriel@192.168.8.2
```

---

## 🗄️ 6. Espelhamento Transparente de Armazenamento (NFSv3)

A integração de diretórios de desenvolvimento utiliza NFSv3 sobre a rede virtual privada:

### No Host FreeBSD:

```sh
# 1. Habilitar daemons NFS no /etc/rc.conf
sudo sysrc rpcbind_enable="YES" nfs_server_enable="YES" mountd_enable="YES"

# 2. Configurar exportação mapeada para o usuário nativo em /etc/exports
echo "/home/gabrielf -alldirs -mapall=gabrielf 192.168.8.2" | sudo tee /etc/exports

# 3. Reiniciar daemons de serviço
sudo service rpcbind start
sudo service mountd restart
sudo service nfsd restart
```

### No Guest Debian:

```sh
# 1. Instalar suporte ao cliente NFS
sudo apt update && sudo apt install -y nfs-common

# 2. Criar ponto de montagem com caminhos idênticos ao FreeBSD
sudo mkdir -p /home/gabrielf
sudo chown 1001:1001 /home/gabrielf

# 3. Persistir a montagem em /etc/fstab
echo "192.168.8.1:/home/gabrielf /home/gabrielf nfs rw,soft,intr,nfsvers=3 0 0" | sudo tee -a /etc/fstab
sudo mount /home/gabrielf
```
