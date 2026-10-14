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
    LOADER --> CONF["3. /boot/loader.conf<br/>• ZFS, PF, ARC Limit<br/>• Intel DRM Flags"]
    CONF --> KERN["4. Kernel FreeBSD (/boot/kernel)"]
    KERN --> SYSCTL["5. /etc/sysctl.conf<br/>• Coredump, Áudio, Rede"]
    SYSCTL --> RC["6. /etc/rc.conf & Daemons"]
```

---

## 🗄️ Configuração Canônica: `/boot/loader.conf`

O arquivo `/boot/loader.conf` do host deve permanecer limpo, estritamente modular e livre de duplicatas.

### Conteúdo Canônico Consolidado

```text
# Desativação de labels GEOM redundantes
kern.geom.label.disk_ident.enable="0"
kern.geom.label.gptid.enable="0"

# Módulos fundamentais do kernel
zfs_load="YES"
pf_load="YES"

# Controladores de hardware e periféricos
uplcom_load="YES"
ng_ubt_load="YES"

# Default ZFS ARC Cache (50% da RAM física - 8 GB em host de 16 GB)
vfs.zfs.arc_max="8589934592"

# Default Intel Alder Lake Graphics (Previne congelamentos, tela preta e GPU hang)
compat.linuxkpi.i915_enable_psr="0"
compat.linuxkpi.i915_enable_fbc="0"
compat.linuxkpi.i915_enable_dc="0"
```

### Explicação dos Parâmetros do Loader:

- **`vfs.zfs.arc_max="8589934592"`:** Impõe um teto estrito de 8 GB ao cache em memória do ZFS. Sem esse parâmetro, o ZFS pode consumir até 90% da memória física, causando pressão de swap no ambiente gráfico e no hipervisor Bhyve.
- **`compat.linuxkpi.i915_enable_psr="0"`:** Desativa o _Panel Self Refresh_ no driver Intel Iris Xe (Alder Lake-P). Em telas de notebooks da 12ª geração, o PSR tenta desligar o painel durante microssegundos ociosos, gerando perda irrecuperável de clock com o compositor Wayland (tela preta com backlight aceso).
- **`compat.linuxkpi.i915_enable_fbc="0"`:** Desativa a compressão do framebuffer (_Framebuffer Compression_), eliminando artefatos visuais e micro-congelamentos de renderização no KDE Plasma.
- **`compat.linuxkpi.i915_enable_dc="0"`:** Desativa estados profundos de economia de energia da GPU (_Display C-states_), evitando o erro `Resetting rcs0 for preemption time out` durante trocas de contexto entre o Firefox/Chromium e o KWin Wayland.

---

## 🎛️ Parâmetros em Tempo de Voo: `/etc/sysctl.conf`

O arquivo `/etc/sysctl.conf` aplica ajustes comportamentais ao kernel após a inicialização.

### Conteúdo Canônico Consolidado

```text
# Desativa geração de core dumps pesados no disco
kern.coredump=0

# Default USB Audio (Roteia som do sistema para placa USB)
hw.snd.default_unit=2
dev.pcm.2.mixer.vol_0_0.val=0
dev.pcm.2.mixer.vol_0_1.val=0

# Privacidade de processos entre usuários
security.bsd.see_other_uids=0
```

### Explicação dos Parâmetros de Sysctl:

- **`kern.coredump=0`:** Impede que falhas de segmentação gravem arquivos de dump de gigabytes no ZFS, poupando I/O de disco e espaço de armazenamento.
- **`hw.snd.default_unit=2`:** Seleciona nativamente o dispositivo de áudio USB como saída primária do sistema operacional, evitando conflitos com saídas HDMI silenciosas.

---

## 🛠️ Procedimento de Auditoria & Sanity Check

Execute no terminal do FreeBSD para verificar se todos os parâmetros foram aceitos pelo kernel ativo:

```sh
# 1. Verificar teto máximo ativo do ZFS ARC
sysctl vfs.zfs.arc_max

# 2. Verificar se o PSR e FBC da Intel estão desativados
sysctl compat.linuxkpi.i915_enable_psr
sysctl compat.linuxkpi.i915_enable_fbc

# 3. Verificar estado do coredump e áudio primário
sysctl kern.coredump hw.snd.default_unit
```
