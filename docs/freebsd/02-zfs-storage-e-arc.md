# 🗄️ Storage OpenZFS & Governança de Memória ARC

> Arquitetura de datasets, particionamento matemático de memória física (4/8 ARC, 3/8 Host, 1/8 VM), integridade de dados e política de snapshots no FreeBSD[cite: 6].

---

## 🧭 Visão Geral do OpenZFS no FreeBSD

O **OpenZFS** é o subsistema de armazenamento padrão do FreeBSD[cite: 6]. Ele unifica os conceitos de gerenciador de volumes lógicos (LVM) e sistema de arquivos transacional em uma única camada com garantia estrita de integridade[cite: 6]:

- **Copy-on-Write (CoW):** Blocos de dados nunca são sobrescritos no lugar (_in-place_)[cite: 6]. Uma nova escrita aloca um novo bloco e atualiza a árvore de metadados apenas após a conclusão bem-sucedida, tornando corrupções de sistema de arquivos matematicamente impossíveis mesmo sob cortes abruptos de energia[cite: 6].
- **Auto-Detecção de Bit-Rot:** Cada bloco de dados possui um checksum criptográfico (Blake3 ou SHA256) validado em cada leitura[cite: 6]. Caso um setor do disco físico sofra degradação magnética silenciosa, o ZFS detecta a anomalia imediatamente[cite: 6].
- **Compressão Transparente:** Datasets adotam o algoritmo `zstd` (Zstandard), que reduz o espaço físico ocupado em 30% a 50% e acelera o throughput de leitura em SSDs NVMe ao ler menos bytes físicos[cite: 6].

```mermaid
flowchart TD
    RAM["Memória RAM Total (16 GB)"]
    ARC["1. ZFS ARC Cache (4/8 = 8 GB)<br/>• Cache em RAM de leitura ultra-rápida<br/>• Teto estrito via arc_max"]
    HOST["2. Host Desktop (3/8 = 6 GB)<br/>• KDE Plasma 6 Wayland<br/>• Browsers, Editores, Daemons"]
    VM["3. Bhyve Linux VM (1/8 = 2 GB)<br/>• Debian 13 Headless<br/>• Google Antigravity & Podman"]

    RAM --> ARC
    RAM --> HOST
    RAM --> VM
```

---

## 📐 O Modelo Matemático de Particionamento de RAM

Em estações de trabalho de 16 GB rodando simultaneamente ZFS, ambiente gráfico moderno e máquinas virtuais, o dimensionamento cego de memória é a principal causa de travamentos e lentidão[cite: 6].

O ecossistema implementa o **Algoritmo de Proporção Octal** através da receita [`Setup/freebsd/desktop/system/zfs-arc.sh`](../../Setup/freebsd/desktop/system/zfs-arc.sh)[cite: 6]:

$$\text{Memória Total} = \frac{4}{8}\text{ (ARC Cache)} + \frac{3}{8}\text{ (Host Desktop)} + \frac{1}{8}\text{ (Bhyve VM)}$$

### Tabela de Dimensionamento Prático (16 GB):

| Componente         | Proporção     | Memória Alocada     | Mecanismo de Aplicação                  |
| :----------------- | :------------ | :------------------ | :-------------------------------------- |
| **ZFS ARC Cache**  | $4/8$ (50%)   | **8.192 MB** (8 GB) | `/boot/loader.conf` (`vfs.zfs.arc_max`) |
| **Host Desktop**   | $3/8$ (37.5%) | **6.144 MB** (6 GB) | Limite operacional do KDE Plasma        |
| **Bhyve Linux VM** | $1/8$ (12.5%) | **2.048 MB** (2 GB) | Configuração da VM (`guest.conf`)       |

---

## 📂 Taxonomia de Datasets do Host

O pool primário `zroot` organiza seus dados em datasets atômicos com políticas de compressão e montagem distintas[cite: 6]:

```text
zroot/
├── ROOT/
│   └── default
├── home/
│   └── gabrielf
├── usr/
│   ├── ports
│   └── src
├── var/
├── vm/
└── bastille/
```

- **`zroot/ROOT/default`:** Sistema operacional base FreeBSD montado em `/`[cite: 6].
- **`zroot/home/gabrielf`:** Diretório de usuário exportado via NFS para a VM[cite: 6].
- **`zroot/usr/ports` e `zroot/usr/src`:** Árvore oficial de ports (`/usr/ports`) e código-fonte do kernel (`/usr/src`)[cite: 6].
- **`zroot/var`:** Logs e caches temporários[cite: 6].
- **`zroot/vm`:** Discos virtuais e imagens RAW do Bhyve[cite: 6].
- **`zroot/bastille`:** Bases e containers do BastilleBSD[cite: 6].

### Propriedades Canônicas Recomendadas:

1. **Ativar compressão ZSTD de alta performance no dataset `home`[cite: 6]:**

```sh
sudo zfs set compression=zstd zroot/home
```

2. **Desativar gravação desnecessária de access time (`atime`) nos datasets `home` e `vm` para ganho de I/O[cite: 6]:**

```sh
sudo zfs set atime=off zroot/home
sudo zfs set atime=off zroot/vm
```

---

## 🔄 Rotina de Snapshots e Manutenção

Snapshots no ZFS são instantâneos, atômicos e ocupam zero espaço inicial no disco[cite: 6].

### Comandos de Operação:

1. **Criar snapshot atômico antes de atualizações de sistema[cite: 6]:**

```sh
sudo zfs snapshot zroot/ROOT/default@pre-upgrade-$(date +%Y%m%d)
```

2. **Listar snapshots existentes com uso de espaço[cite: 6]:**

```sh
zfs list -t snapshot -r zroot
```

3. **Executar scrub periódico de integridade (recomenda-se mensalmente)[cite: 6]:**

```sh
sudo zpool scrub zroot
```

4. **Checar status da verificação de integridade[cite: 6]:**

```sh
zpool status zroot
```
