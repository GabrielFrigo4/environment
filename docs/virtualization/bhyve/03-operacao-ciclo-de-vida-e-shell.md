# 🛠️ Operação Diária, Ciclo de Vida, Snapshots e Integração com o Shell

> Runbook operacional cobrindo a governança do hipervisor Bhyve, snapshots atômicos no ZFS, comandos do Shell e diagnóstico de integridade.

---

## 🖥️ 1. Gestão do Ciclo de Vida da VM (`vm-bhyve`)

Todas as operações de controle da máquina virtual são disparadas diretamente no host FreeBSD:

| Operação                 | Comando                   | Descrição                                                         |
| :----------------------- | :------------------------ | :---------------------------------------------------------------- |
| **Status da VM**         | `vm list`                 | Exibe estado (`Running`, `Stopped`), datastore, vCPUs, RAM e IP.  |
| **Inicialização**        | `sudo vm start debian`    | Inicia a VM em modo headless com aceleração VT-x.                 |
| **Parada Graciosa**      | `sudo vm stop debian`     | Envia sinal ACPI de desligamento para o sistema operacional.      |
| **Desligamento Forçado** | `sudo vm poweroff debian` | Encerra a VM imediatamente em situações de travamento.            |
| **Console Serial**       | `sudo vm console debian`  | Conecta ao console de texto via dispositivo `nmdm` (saída: `~.`). |

---

## 🗄️ 2. Governança de Storage & Snapshots Atômicos no ZFS

Antes de executar atualizações volumosas no Debian (`apt dist-upgrade`) ou alterar pacotes da base, capture um snapshot instantâneo do volume da VM no host FreeBSD:

```sh
# 1. Criar snapshot instantâneo antes de modificações
sudo zfs snapshot zroot/vm/debian@pre-upgrade

# 2. Listar snapshots para verificação
zfs list -t snapshot | grep debian

# 3. Rollback imediato em caso de falha no sistema operacional guest:
sudo vm stop -f debian
sudo zfs rollback zroot/vm/debian@pre-upgrade
sudo vm start debian

# 4. Destruir snapshot após homologação da estabilidade
sudo zfs destroy zroot/vm/debian@pre-upgrade
```

---

## 🐚 3. Integração com o Shell & Despacho de Comandos

A integração é implementada de forma modular e em conformidade estrita POSIX `/bin/sh` em [`Shell/target/freebsd/bhyve.sh`](file:///home/gabrielf/Documents/Environment/Shell/target/freebsd/bhyve.sh).

### Mecanismos de Funcionamento:

1. **Boot Sob Demanda (`_ensure_debian_running`):** Valida se o processo do Bhyve está em execução via `vm list`. Caso contrário, dispara `sudo vm start debian` e aguarda 2 segundos antes de enviar o comando.
2. **Preservação de Diretório:** Se o usuário estiver trabalhando sob `/home/gabrielf`, o despachante navega para a mesma pasta no guest (`cd "$PWD"`). Se estiver em caminho de sistema do FreeBSD (ex: `/usr/ports`, `/tmp`), realiza fallback defensivo para a raiz de `/home/gabrielf`.
3. **Propagação de TTY e Variáveis de Ambiente:** Detecta dinamicamente se o terminal ativo é um pseudoterminal gráfico (PTY) ou um console físico puro (`ttyv*`). Em TTY puro, exporta e propaga `RAW_TTY=1` e `LC_RAW_TTY=1` via opções do OpenSSH (`-o SendEnv=LC_RAW_TTY`), garantindo prompts textuais leves sem mojibake ou fontes ausentes.

### Atalhos e Comandos Principais:

- **`linux-host`** (aliases: `linux`, `lx`, `debian`, `deb`): Despacha comandos interativos ou inicia um shell completo na VM.
    ```sh
    lx uname -a           # Executa comando pontual no Debian
    lx                   # Abre sessão interativa de shell no guest
    ```
- **`agy-lx`** (alias: `agy`): Executa o Google Antigravity CLI isolado no Debian com suporte pleno ao runtime Go e persistência no ZFS.
    ```sh
    agy status           # Executa comandos do agente de IA
    ```

---

## 🛡️ 4. Modo Efêmero no Linuxulator (`agy-compat`)

Para cenários onde a máquina virtual estiver parada ou inacessível, o ecossistema mantém a rotina de contenção via FreeBSD Linuxulator em [`Shell/target/freebsd/compat.sh`](file:///home/gabrielf/Documents/Environment/Shell/target/freebsd/compat.sh):

```sh
# Execução local temporária com mitigação de vazamento e pinning de CPU
agy-compat           # Alias: agy-cp
```

Parâmetros de contenção aplicados:

- `COMPAT_GODEBUG="netdns=go,http2client=0,asyncpreemptoff=1"`
- `COMPAT_GOMAXPROCS=2`
- `COMPAT_GOGC=8`
- `COMPAT_GOMEMLIMIT="1GiB"`
- Confinamento via `cpuset -l` e prioridade rebaixada via `nice -n 16`.

> [!NOTE]
> O modo `agy-compat` é estritamente efêmero (para invocações rápidas de diagnóstico). Para fluxos de trabalho prolongados, utilize sempre o runtime nativo no Bhyve (`agy`).

---

## 🔄 5. Rotinas Automatizadas de Atualização

O comando [`update-linux`](file:///home/gabrielf/Documents/Environment/Shell/target/freebsd/bhyve.sh) (aliases: `uplx`, `updeb`) conecta à VM e dispara a suíte completa de atualização:

```sh
# Atualização manual do Linux guest
update-linux
uplx
```

Esse comando é acionado de forma automática pelo orquestrador global [`update-all`](file:///home/gabrielf/Documents/Environment/Shell/library/functions.sh) (`upall`) sempre que executado em estações FreeBSD.

---

## 🔍 6. Checklist de Diagnóstico e Resolução de Problemas

Se o despacho de comandos via `lx` ou `agy` não responder:

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
4. **O diretório compartilhado está montado no guest?**
    ```sh
    ssh gabriel@192.168.8.2 "df -h | grep /home/gabrielf"
    ```
