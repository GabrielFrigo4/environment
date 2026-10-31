# ⚙️ Inicialização, Loader & Kernel FreeBSD

> Governança canônica do ciclo de boot do FreeBSD, carregamento modular de drivers no `/boot/loader.conf` e parametrização dinâmica de kernel via `/etc/sysctl.conf`.

---

## 🧭 Visão Geral do Ciclo de Boot

O ciclo de inicialização do FreeBSD difere fundamentalmente do ecossistema Linux tradicional. Em vez de depender de imagens `initramfs`/`initrd` complexas montadas dinamicamente, o FreeBSD opera sob uma arquitetura determinística de dois estágios principais de configuração:

1. **Estágio Pré-Kernel (`/boot/loader.conf`):** Processado pelo bootloader UEFI (`loader.efi`) antes da carga do kernel na memória física. Configura drivers que devem estar residentes desde o primeiro instante (sistemas de arquivos raiz, controladores de disco, firewall e alocação máxima de memória ARC).
2. **Estágio Pós-Kernel (`/etc/sysctl.conf` e `/etc/rc.conf`):** Processado pelo `init(8)` durante a inicialização do modo multiusuário, ajustando parâmetros dinâmicos de rede, áudio, segurança e limites de memória em tempo de voo.

```mermaid
flowchart LR
    UEFI["1. UEFI BIOS"] --> LOADER["2. loader.efi"]
    LOADER --> CONF["3. /boot/loader.conf<br/>• ZFS, PF, ARC Limit (4/16)<br/>• Intel DRM & HuC Flags"]
    CONF --> KERN["4. Kernel FreeBSD (/boot/kernel)"]
    KERN --> SYSCTL["5. /etc/sysctl.conf<br/>• Coredump, Áudio, Rede"]
    SYSCTL --> RC["6. /etc/rc.conf & Daemons"]
```

---

## 🗄️ Configuração Canônica: `/boot/loader.conf`

O arquivo `/boot/loader.conf` do host deve permanecer limpo, estritamente modular e livre de duplicatas. Ele desativa labels GEOM redundantes, carrega os módulos fundamentais do kernel (ZFS e PF) e controladores de periféricos (`uplcom` e `ng_ubt`), define o teto máximo do ZFS ARC Cache em 4/16 da RAM física (4 GB em host de 16 GB, mantendo 11/16 livres para o Host e 1/16 para VM Bhyve) e aplica os parâmetros de estabilidade e aceleração de mídia HuC para a GPU Intel Alder Lake.

### Conteúdo Canônico Consolidado

```text
kern.geom.label.disk_ident.enable="0"
kern.geom.label.gptid.enable="0"

zfs_load="YES"
pf_load="YES"

uplcom_load="YES"
ng_ubt_load="YES"

vfs.zfs.arc.max="4294967296"
vfs.zfs.arc.min="1073741824"

compat.linuxkpi.i915_enable_psr="0"
compat.linuxkpi.i915_enable_psr2_sel_fetch="0"
compat.linuxkpi.i915_enable_fbc="0"
compat.linuxkpi.i915_enable_dc="0"
compat.linuxkpi.i915_enable_guc="2"
```

### Explicação dos Parâmetros do Loader:

- **`kern.geom.label.disk_ident.enable="0"` e `gptid.enable="0"`:** Desativam a criação de labels GEOM redundantes em `/dev/`.
- **`zfs_load="YES"` e `pf_load="YES"`:** Carregam os módulos fundamentais do sistema de arquivos ZFS e do firewall Packet Filter no estágio inicial de boot.
- **`uplcom_load="YES"` e `ng_ubt_load="YES"`:** Carregam os controladores de hardware para adaptadores seriais USB e Bluetooth.
- **`vfs.zfs.arc.max="4294967296"` e `vfs.zfs.arc.min="1073741824"`:** Impõe um teto estrito de 4 GB (4/16 de 16 GB) e piso de 1 GB ao cache em memória do ZFS. Sem esse parâmetro, o ZFS pode consumir até 90% da memória física, causando pressão de swap no ambiente gráfico e no hipervisor Bhyve.
- **`compat.linuxkpi.i915_enable_psr="0"` e `i915_enable_psr2_sel_fetch="0"`:** Desativam por completo o _Panel Self Refresh_ e a busca seletiva de quadros do _PSR2_ no driver Intel Iris Xe (Alder Lake-P). Sem desativar também o `psr2_sel_fetch`, a flag permanece em `1` mesmo com `enable_psr="0"`, mantendo rotinas parciais de suspensão do painel ativas.
- **`compat.linuxkpi.i915_enable_fbc="0"`:** Desativa a compressão do framebuffer (_Framebuffer Compression_), eliminando artefatos visuais e micro-congelamentos de renderização no KDE Plasma.
- **`compat.linuxkpi.i915_enable_dc="0"`:** Desativa estados profundos de economia de energia da GPU (_Display C-states_).
- **`compat.linuxkpi.i915_enable_guc="2"`:** Habilita o microcódigo **HuC** (`2`: autenticação de workloads de mídia VA-API e decodificação acelerada) com submissão estável via CPU, prevenindo congelamentos de anel e panes de preempção do motor `rcs0` no FreeBSD 15.1.

---

## 🎛️ Parâmetros em Tempo de Voo: `/etc/sysctl.conf`

O arquivo `/etc/sysctl.conf` aplica ajustes comportamentais ao kernel após a inicialização, desativando a gravação de core dumps no disco, roteando o som padrão do sistema para a interface de áudio USB e restringindo a visibilidade de processos entre diferentes usuários.

### Conteúdo Canônico Consolidado

```text
kern.coredump=0

hw.snd.default_unit=2
dev.pcm.2.mixer.vol_0_0.val=0
dev.pcm.2.mixer.vol_0_1.val=0

security.bsd.see_other_uids=0
```

### Explicação dos Parâmetros de Sysctl:

- **`kern.coredump=0`:** Impede que falhas de segmentação gravem arquivos de dump de gigabytes no ZFS, poupando I/O de disco e espaço de armazenamento.
- **`hw.snd.default_unit=2` e ajustes `dev.pcm.2`:** Selecionam nativamente o dispositivo de áudio USB como saída primária do sistema operacional e ajustam seus canais de mixer, evitando conflitos com saídas HDMI silenciosas.
- **`security.bsd.see_other_uids=0`:** Garante a privacidade de processos em execução entre diferentes usuários do sistema.

---

## 🛠️ Procedimento de Auditoria & Sanity Check

Execute no terminal do FreeBSD para verificar se todos os parâmetros foram aceitos pelo kernel ativo.

1. **Verificar teto máximo ativo do ZFS ARC, estado do coredump e áudio primário:**

```sh
sysctl vfs.zfs.arc.max vfs.zfs.arc.min kern.coredump hw.snd.default_unit
```

2. **Auditoria completa da GPU Intel (Sysctl + Firmware GuC/HuC no `dmesg`):**

```sh
sysctl compat.linuxkpi.i915_enable_psr compat.linuxkpi.i915_enable_psr2_sel_fetch compat.linuxkpi.i915_enable_fbc compat.linuxkpi.i915_enable_dc compat.linuxkpi.i915_enable_guc && dmesg | grep -iE "drmn0|guc|huc"
```
