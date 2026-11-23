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
sudo zfs snapshot zroot/vm/debian@pre-upgrade
zfs list -t snapshot | grep debian
sudo vm stop -f debian
sudo zfs rollback zroot/vm/debian@pre-upgrade
sudo vm start debian
sudo zfs destroy zroot/vm/debian@pre-upgrade
```

---

## 🐚 3. Integração com o Shell & Despacho de Comandos

A integração é implementada de forma modular e em conformidade estrita POSIX `sh` em [`Shell/target/freebsd/bhyve.sh`](../../../Shell/target/freebsd/bhyve.sh).

### Mecanismos de Funcionamento:

1. **Boot Sob Demanda (`_bhyve_ensure_linux`):** Valida se a porta SSH da VM responde ou inicia `vm start "${_bhyve_vm}"` automaticamente sob demanda antes de enviar o comando.
2. **Preservação de Diretório (`BHYVE_LINUX_WORKDIR`):** Se `BHYVE_LINUX_WORKDIR` estiver configurado e `$PWD` estiver sob esse prefixo, o despachante navega para a mesma pasta no guest (`cd "$PWD"`), realizando fallback silencioso caso invocado fora da árvore compartilhada.
3. **Propagação de TTY e Variáveis de Ambiente:** Detecta dinamicamente se o terminal ativo é um pseudoterminal gráfico (PTY) ou um console físico puro (`ttyv*`). Em TTY puro, exporta e propaga `RAW_TTY=1` e `LC_RAW_TTY=1` via opções do OpenSSH (`-o SendEnv=LC_RAW_TTY`), garantindo prompts textuais leves sem mojibake ou fontes ausentes.

### Atalhos e Comandos Principais:

- **`linux-host`** (aliases: `linux`, `lx`, `debian`, `deb`): Despacha comandos interativos ou inicia um shell completo na VM.
    ```sh
    lx uname -a
    lx
    ```
- **`agy-bhyve`** (alias: `agy-lx`, despacho opcional para a VM): Executa o `agy` isolado no Debian sob demanda. Por padrão (`SHELL_RUNTIME=auto`), o **`agy`** usa `agy-compat` (Linuxulator) com fallback automático para `agy-bhyve` caso o binário local não exista; para rotear `agy` para o guest Bhyve diretamente, defina `SHELL_RUNTIME=vm` (ou execute `runtime vm` / `install.sh -r vm`).
    ```sh
    agy-bhyve status
    agy-lx status
    ```

---

## 🛡️ 4. Execução via Linuxulator (`linux-compat` / `agy-compat`)

Como alternativa nativa no próprio host sem virtualização completa, o ecossistema mantém a rotina genérica `linux-compat` (alias `compat-run`) e o wrapper `agy-compat` (alias `agy-cp`) em [`Shell/target/freebsd/compat.sh`](../../../Shell/target/freebsd/compat.sh):

```sh
agy-compat
agy-cp
linux-compat /caminho/para/binario-linux
```

Parâmetros padrão de contenção aplicados por execução (sem poluir o ambiente global com `export`):

- `COMPAT_GODEBUG="netdns=go,http2client=0,asyncpreemptoff=1"`
- `COMPAT_GOMAXPROCS=2`
- `COMPAT_GOGC=50`
- `COMPAT_GOMEMLIMIT="2GiB"`
- Confinamento dinâmico nos E-cores via `kern.sched.topology_spec` (`cpuset -l`) e prioridade rebaixada via `nice -n 10`.

---

## 🔄 5. Rotinas Automatizadas de Atualização

O comando `update-linux` (aliases: `uplx`, `updeb`, definido em [`Shell/library/system/network.sh`](../../../Shell/library/system/network.sh)) conecta ao runtime Linux configurado e dispara a rotina de atualização:

```sh
update-linux
uplx
```

Quando `LINUX_HOST_IP` / `BHYVE_LINUX_IP` estiver configurado, o orquestrador global `update-all` (`upall`) integra essa etapa automaticamente no FreeBSD.

---

## 🔍 6. Checklist de Diagnóstico e Resolução de Problemas

Se o despacho de comandos via `lx` ou `agy-lx` não responder:

1. **A VM está em execução?**
    ```sh
    vm list
    ```
2. **A interface de rede da bridge responde a ping?**
    ```sh
    ping -c 2 "${BHYVE_LINUX_IP:-${LINUX_HOST_IP}}"
    ```
3. **O servidor NFS do FreeBSD está anunciando os diretórios?**
    ```sh
    showmount -e 127.0.0.1
    ```
4. **O diretório compartilhado está montado no guest?**
    ```sh
    ssh "${USER}@${BHYVE_LINUX_IP:-${LINUX_HOST_IP}}" "df -h | grep '${HOME}'"
    ```
