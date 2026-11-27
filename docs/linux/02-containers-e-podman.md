# 📦 Containers OCI & Podman Rootless

> Governança de containers no Linux com arquitetura sem daemon, execução rootless via namespaces de usuário e compatibilidade Docker.

---

## 🧭 Por que Podman em vez de Docker Daemon?

Historicamente, o Docker popularizou o padrão de containers através de uma arquitetura baseada em um daemon central (`dockerd`) executando com privilégios irrestritos de `root`. Qualquer usuário com acesso ao socket `/var/run/docker.sock` possui controle total sobre o kernel da máquina.

No Universal Environment, adota-se o **Podman (Pod Manager)** pelos seguintes motivos de engenharia:

1. **Daemonless (Filosofia UNIX Pura):** O Podman não depende de um daemon residente em background. Containers são instanciados como filhos diretos do processo atual (`fork/exec`), facilitando integração com `systemd`, `cron` e supervisores de processo.
2. **Rootless por Padrão:** Containers rodam inteiramente no contexto do usuário comum (`UID=1001`), utilizando _User Namespaces_ do Linux. Mesmo se um processo malicioso escapar do container, ele terá apenas os privilégios limitados do usuário no host.
3. **Compatibilidade 100% OCI:** O Podman consome imagens dos mesmos registros (Docker Hub, Quay, GitHub Container Registry) e compartilha a sintaxe de comandos com a CLI do Docker.

```mermaid
flowchart LR
    subgraph DOCKER ["Arquitetura Tradicional (Docker)"]
        DCLI["docker CLI"] -->|HTTP/REST| DSOCK["/var/run/docker.sock"]
        DSOCK --> DDAEMON["dockerd (Root Daemon)"]
        DDAEMON --> C1["Container (Root)"]
    end

    subgraph PODMAN ["Arquitetura Soberana (Podman Rootless)"]
        PCLI["podman CLI (UID 1001)"] -->|fork/exec| RUNTIME["crun / runc"]
        RUNTIME --> C2["Container (User Namespace)"]
    end
```

---

## ⚙️ Configuração de User Namespaces: `subuid` e `subgid`

Para que o usuário possa mapear UIDs internos do container sem ser root, o sistema operacional necessita de faixas alocadas em `/etc/subuid` e `/etc/subgid`:

```text
<user>:100000:65536
```

Para aplicar e inicializar as faixas após alterar os arquivos:

```sh
podman system migrate
```

---

## 🔌 Emulação do Docker Socket para Ferramentas Externas

Determinadas ferramentas de build e IDEs esperam a presença física de um soquete compatível com a API Docker. O Podman disponibiliza um soquete exclusivo por usuário (habilitado no escopo do usuário não-root e exportado via `DOCKER_HOST`):

```sh
systemctl --user enable --now podman.socket
export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/podman/podman.sock"
```

---

## 🚀 Operação Cotidiana & Podman Compose

### Aliases Transparentes no Shell:

No Universal Shell (`Shell/`), o Podman é exposto naturalmente:

```sh
alias docker="podman"
alias docker-compose="podman-compose"
```

### Comandos de Gestão:

Execução de container efêmero interativo, listagem de containers, inspeção de disco e limpeza de artefatos não utilizados:

```sh
podman run --rm -it alpine:latest sh
podman ps -a
podman system df
podman system prune -af
```
