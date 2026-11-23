# 📦 Virtualização & Isolamento no FreeBSD: A Tríade Soberana

> Arquitetura comparativa, casos de uso e governança das três camadas de isolamento e execução no FreeBSD: Hipervisor Tipo-2 (Bhyve), Containers no nível do SO (Jails) e Orquestração Declarativa (BastilleBSD).

---

## 🧭 Visão Geral & Filosofia de Isolamento

O FreeBSD disponibiliza três primitivas nativas de isolamento, cada uma projetada para um nível diferente de abstração, sobrecarga e controle de kernel:

```mermaid
flowchart TD
    HW["💻 Hardware Bare-Metal (Host FreeBSD)"]
    ZFS["🗄️ Storage ZFS (Datasets Dedicados)"]
    PF["🛡️ Packet Filter (NAT & Redes Virtuais)"]

    HW --> ZFS
    HW --> PF

    subgraph BH ["1. Hipervisor Tipo-2: Bhyve"]
        B1["Kernel Linux Próprio (Debian)"]
        B2["Syscalls GNU/Linux Nativas (OCI, ML)"]
        B3["Ponte de Rede TAP/Bridge + NFSv3"]
    end

    subgraph JL ["2. Virtualização de SO: Jails Nativas"]
        J1["Kernel FreeBSD Compartilhado"]
        J2["Pilha de Rede VNET Dedicada"]
        J3["Zero Overhead de CPU/Memória"]
    end

    subgraph BST ["3. Orquestração: BastilleBSD"]
        T1["Templates Declarativos de Jails"]
        T2["Bootstrap Automatizado de Bases"]
        T3["Gerenciamento Simétrico (estilo Docker)"]
    end

    ZFS --> BH
    ZFS --> JL
    ZFS --> BST

    PF --> BH
    PF --> JL
    PF --> BST
```

---

## 📊 Matriz Comparativa das Tecnologias

| Dimensão                  | 🖥️ Bhyve (VM Headless)              | 🛡️ Jails Nativas                      | 🏰 BastilleBSD                     |
| :------------------------ | :---------------------------------- | :------------------------------------ | :--------------------------------- |
| **Tipo de Isolamento**    | Hipervisor de Hardware (Tipo-2)     | Namespaces de Processos & FS          | Orquestrador de Jails              |
| **Kernel Utilizado**      | Kernel convidado (Linux/GNU)        | Kernel do Host (FreeBSD)              | Kernel do Host (FreeBSD)           |
| **Overhead de RAM/CPU**   | 1–2 GB + virtualização VT-x         | Virtualmente zero (processos nativos) | Virtualmente zero                  |
| **Pilha de Rede**         | Interface `tap0` em ponte `bridge0` | VNET (`epair`) ou IP compartilhado    | VNET automatizada com NAT          |
| **Storage Subjacente**    | Dataset ZFS com arquivo RAW/ZVOL    | Dataset ZFS (`zroot/jails/...`)       | Dataset ZFS (`zroot/bastille/...`) |
| **Principal Caso de Uso** | Containers Linux/OCI, Toolchains    | Serviços FreeBSD de produção          | Ambientes efêmeros e testes        |

---

## 📚 Índice da Seção

| Subsistema           | Caminho                           | Foco Arquitetural e Operacional                                                     |
| :------------------- | :-------------------------------- | :---------------------------------------------------------------------------------- |
| **Hipervisor Bhyve** | [`bhyve/`](bhyve/README.md)       | Execução sob demanda de VM Debian para containers OCI e workloads Linux nativos.    |
| **Jails Nativas**    | [`jails/`](jails/README.md)       | Isolamento leve de serviços nativos do FreeBSD com pilha de rede virtualizada VNET. |
| **BastilleBSD**      | [`bastille/`](bastille/README.md) | Orquestração declarativa de containers FreeBSD baseada em templates e ZFS.          |

---

## ⚡ Comandos Rápidos & Referência Diária

### Hipervisor Bhyve:

```sh
vm list
vm start debian
vm console debian
```

### Jails Nativas:

```sh
jls -v
sudo jail -c -f /etc/jail.conf minha_jail
sudo jexec minha_jail sh
```

### BastilleBSD:

```sh
sudo bastille list
sudo bastille start container01
sudo bastille cmd container01 pkg update
```
