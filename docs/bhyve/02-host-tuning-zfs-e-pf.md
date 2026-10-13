# ⚙️ Host Tuning: ZFS ARC, Sysctl e Firewall PF com NAT

Diretrizes de calibração do kernel FreeBSD, escalonamento dinâmico de memória ZFS ARC e roteamento de rede para suporte a máquinas virtuais no Bhyve.

---

## 1. Gestão Dinâmica de Memória do ZFS ARC

O teto estático rígido (`vfs.zfs.arc.max`) foi descontinuado nas versões modernas do OpenZFS no FreeBSD. O subsistema ARC opera com governança dinâmica coordenada com o escalonador de memória virtual (VM pager) do kernel, liberando páginas de buffer de leitura sob demanda quando o Bhyve aloca memória física (*wired*).

---

## 2. Configuração do Firewall PF (Sintaxe Moderna com NAT)

Configuração em `/etc/pf.conf` com regras de comutação dinâmica entre interface cabeada (`re0`) e interface sem fio (`wlan0`):

```pf
# Tradução de endereços (NAT) para o segmento da VM Bhyve (192.168.8.0/24)
match out on re0 inet from 192.168.8.0/24 to any nat-to (re0) round-robin
match out on wlan0 inet from 192.168.8.0/24 to any nat-to (wlan0) round-robin

# Passagem de tráfego com rastreamento de estado
pass all flags S/SA keep state
```

---

## 3. Roteamento, Bridge e Persistência no Arranque

Comandos para configuração e persistência do roteamento no FreeBSD:

```sh
# 1. Ativar encaminhamento permanente de pacotes e serviços no /etc/rc.conf
sudo sysrc gateway_enable="YES"
sudo sysrc pf_enable="YES"
sudo sysrc pf_rules="/etc/pf.conf"
sudo sysrc vm_enable="YES"
sudo sysrc vm_dir="zfs:zroot/vm"

# 2. Desativar filtragem de pacotes nas interfaces da bridge no /etc/sysctl.conf
sudo sh -c 'cat << "SYSCTL" >> /etc/sysctl.conf
net.link.bridge.pfil_member=0
net.link.bridge.pfil_bridge=0
SYSCTL'
sudo sysctl net.link.bridge.pfil_member=0
sudo sysctl net.link.bridge.pfil_bridge=0

# 3. Carregar regras e ativar o Packet Filter (PF)
sudo pfctl -f /etc/pf.conf
sudo pfctl -e 2> "/dev/null" || true

# 4. Criar o switch virtual interno e fixar o IP do gateway (Host: 192.168.8.1)
sudo vm switch create public 2> "/dev/null" || true
sudo vm switch address public 192.168.8.1/24
```
