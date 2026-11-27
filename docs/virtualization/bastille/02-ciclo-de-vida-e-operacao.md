# 🔄 Ciclo de Vida, Rede & Operação no BastilleBSD

> Comandos operacionais, criação em modos VNET e Shared IP, encaminhamento de portas via PF e governança de snapshots ZFS.

---

## 🧭 Modos de Criação de Containers

O BastilleBSD suporta dois modos fundamentais de rede ao provisionar uma nova instância:

### 1. Modo Tradicional (IP Compartilhado / Loopback):

Utiliza uma interface virtual clonada (`bastille0` em `127.0.0.1` ou `10.17.0.1`) ao criar um container com IP na rede interna:

```sh
doas bastille create db01 15.1-RELEASE 10.17.0.10
```

### 2. Modo VNET (Pilha de Rede Isolada Dedicada):

O modo `-V` provisiona uma interface `epair` virtual conectada à ponte do host (`bridge0`), concedendo à Jail sua própria pilha de rede e MAC address independente:

```sh
doas bastille create -V web01 15.1-RELEASE 192.168.10.50/24 bridge0
```

---

## ⚙️ Comandos do Ciclo de Vida

Operações para iniciar um container ou todos (`ALL`), parar graciosamente, reiniciar e destruir (purgando o dataset ZFS):

```sh
doas bastille start web01
doas bastille start ALL
doas bastille stop web01
doas bastille restart web01
doas bastille destroy web01
```

---

## 💻 Execução de Comandos & Acesso Interativo

O Bastille oferece ergonomia semelhante ao `docker exec` para execução pontual, shell interativo e comandos em lote:

```sh
doas bastille cmd web01 uname -a
doas bastille cmd web01 pkg install --yes git vim-tiny
doas bastille console web01
doas bastille cmd ALL uptime
```

---

## 🌐 Encaminhamento de Portas (Port Forwarding via PF)

Para expor uma porta interna do container (ex.: redirecionar `8080` do host para `80` da jail, listar ou limpar regras) no Packet Filter:

```sh
doas bastille rdr web01 tcp 8080 80
doas bastille rdr web01 list
doas bastille rdr web01 clear
```

---

## 🗄️ Governança de Storage & Snapshots ZFS

Por utilizar ZFS nativo em todas as camadas, criação de snapshots, listagem, rollback e exportação/importação de containers são operações atômicas:

```sh
doas bastille zfs snapshot web01@pre-upgrade
doas bastille zfs snaplist web01
doas bastille zfs rollback web01@pre-upgrade
doas bastille export web01
doas bastille import /caminho/para/web01.tar.gz
```
