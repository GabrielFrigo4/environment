# 🔄 Ciclo de Vida, Rede & Operação no BastilleBSD

> Comandos operacionais, criação em modos VNET e Shared IP, encaminhamento de portas via PF e governança de snapshots ZFS.

---

## 🧭 Modos de Criação de Containers

O BastilleBSD suporta dois modos fundamentais de rede ao provisionar uma nova instância:

### 1. Modo Tradicional (IP Compartilhado / Loopback):

Utiliza uma interface virtual clonada (`bastille0` em `127.0.0.1` ou `10.17.0.1`):

```sh
# Criar container com IP na rede interna
sudo bastille create db01 14.2-RELEASE 10.17.0.10
```

### 2. Modo VNET (Pilha de Rede Isolada Dedicada):

O modo `-V` provisiona uma interface `epair` virtual conectada à ponte do host (`bridge0`), concedendo à Jail sua própria pilha de rede e MAC address independente:

```sh
# Criar container em modo VNET conectado à interface bridge0
sudo bastille create -V web01 14.2-RELEASE 192.168.10.50/24 bridge0
```

---

## ⚙️ Comandos do Ciclo de Vida

```sh
# Iniciar um container específico
sudo bastille start web01

# Iniciar TODOS os containers declarados
sudo bastille start ALL

# Parar um container graciosamente
sudo bastille stop web01

# Reiniciar um container
sudo bastille restart web01

# Destruir um container e purgar seu dataset ZFS
sudo bastille destroy web01
```

---

## 💻 Execução de Comandos & Acesso Interativo

O Bastille oferece ergonomia idêntica ao `docker exec`:

```sh
# Executar comando único e capturar a saída sem login interativo
sudo bastille cmd web01 uname -a
sudo bastille cmd web01 pkg install -y git vim-tiny

# Abrir sessão de terminal interativa
sudo bastille console web01

# Executar comando em múltiplos containers em lote
sudo bastille cmd ALL uptime
```

---

## 🌐 Encaminhamento de Portas (Port Forwarding via PF)

Para expor uma porta interna do container para a rede física externa do host, o Bastille integra-se diretamente ao Packet Filter:

```sh
# Redirecionar a porta 8080 do host para a porta 80 da jail
sudo bastille rdr web01 tcp 8080 80

# Listar todos os redirecionamentos de portas ativos
sudo bastille rdr web01 list

# Limpar redirecionamentos
sudo bastille rdr web01 clear
```

---

## 🗄️ Governança de Storage & Snapshots ZFS

Por utilizar ZFS nativo em todas as camadas, as operações de backup, restauração e exportação são instantâneas:

```sh
# Criar snapshot atômico do container
sudo bastille zfs snapshot web01@pre-upgrade

# Listar snapshots de um container
sudo bastille zfs snaplist web01

# Reverter para um snapshot anterior
sudo bastille zfs rollback web01@pre-upgrade

# Exportar container comprimido para arquivo tar.gz/zfs stream
sudo bastille export web01

# Importar container em outro servidor FreeBSD
sudo bastille import /caminho/para/web01.tar.gz
```
