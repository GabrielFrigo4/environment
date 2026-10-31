# 🖥️ Gráficos DRM & KDE Plasma 6 Wayland

> Arquitetura gráfica no FreeBSD, diagnóstico de drivers Intel Alder Lake-P (12ª Geração), mitigação de congelamentos por PSR/FBC/Preemption Timeout e ambiente de desktop KDE Plasma 6 Wayland.

---

## 🧭 O Subsistema Gráfico no FreeBSD

A aceleração gráfica moderna no FreeBSD é implementada através do subsistema **`drm-kmod`** (Direct Rendering Manager). Esse subsistema utiliza a camada **LinuxKPI** do kernel do FreeBSD para compilar e executar diretamente os drivers DRM do kernel Linux (i915, amdgpu, radeon) sobre a arquitetura BSD.

O ambiente de desktop primário do Universal Environment é o **KDE Plasma 6** rodando nativamente sobre o protocolo de exibição moderno **Wayland** (`kwin_wayland`).

```mermaid
flowchart TD
    HW["💻 GPU Intel Iris Xe Graphics (Alder Lake-P, Device ID 46a8)"]
    FW["📦 Firmware: gpu-firmware-intel-kmod-alderlake<br/>(adlp_dmc.bin, adlp_guc_70.bin, tgl_huc.bin)"]
    KMOD["⚙️ Kernel Driver: drm-kmod (LinuxKPI i915)"]
    LOADER["🎛️ /boot/loader.conf<br/>• i915_enable_psr=0 / psr2_sel_fetch=0<br/>• i915_enable_fbc=0 / enable_dc=0<br/>• i915_enable_guc=2"]
    WAY["🌐 Servidor Gráfico Wayland (kwin_wayland)"]
    PLASMA["🖥️ Desktop KDE Plasma 6"]
    APPS["🎨 Aplicações Wayland Nativas (wl-clipboard, Qt6, GTK4)"]

    HW --> KMOD
    FW --> KMOD
    LOADER -.->|Mitigação de Energia & HuC Aceleração de Mídia| KMOD
    KMOD --> WAY
    WAY --> PLASMA
    PLASMA --> APPS
```

---

## 🔬 Diagnóstico de Hardware: Intel Alder Lake-P (12ª Geração)

A inspeção do buffer de mensagens do kernel (`dmesg`) revela a controladora de vídeo exata:

```text
drmn0: [drm] Found ALDERLAKE_P (device ID 46a8) display version 13.00 stepping D0
```

### 1. A Anatomia dos Travamentos Silenciosos (Tela Preta com Backlight)

Em estações FreeBSD com processadores Intel Core de 12ª geração e desktop Wayland, a combinação de economia de energia agressiva do driver com o compositor KWin produz dois comportamentos críticos:

1. **Micro-travamentos do cursor do mouse (5 a 10s):** O controlador de display tenta forçar o painel interno a entrar em modo de suspensão profunda (_PSR2 - Panel Self Refresh_) a cada milissegundo ocioso. Quando o usuário move o mouse, o compositor Wayland envia novos quadros e o driver `i915` engasga para restabelecer a sincronia de clock com o display a tempo.
2. **Tela preta definitiva com backlight aceso:** Em determinado momento de oscilação de quadros, o driver perde o sinal de sincronia com a controladora e desliga a renderização. Para o kernel, o sistema operacional continua funcionando normalmente (sem registrar pânico ou erro no `/var/log/messages`), forçando o desligamento pelo botão de energia.

### 2. A Anatomia do `GPU HANG` em Cascata (`preemption time out` no Motor `rcs0`)

Mesmo quando `psr=0`, `fbc=0` e `dc=0` estão ativos, a submissão via GuC (`compat.linuxkpi.i915_enable_guc: 1` ou `3`) induz instabilidades na camada LinuxKPI sob pressão de RAM no FreeBSD 15.1:

```text
drmn0: [drm] GPU HANG: ecode 12:1:85dfbfff, in Renderer [104348]
drmn0: [drm] Resetting rcs0 for preemption time out
drmn0: [drm] Renderer[104348] context reset due to GPU hang
drmn0: [drm] GPU HANG: ecode 12:1:85dfffff, in kwin_wayland [101380]
drmn0: [drm] Resetting rcs0 for preemption time out
drmn0: [drm] kwin_wayland[101380] context reset due to GPU hang
drmn0: [drm] GPU HANG: ecode 12:1:859ffffb, in QSGRenderThread [101660]
drmn0: [drm] Resetting rcs0 for preemption time out
drmn0: [drm] CanvasRenderer[104369] context reset due to GPU hang
drmn0: [drm] GPU HANG: ecode 12:1:86d8ffe0, in CanvasRenderer [104369]
```

- **O Gatilho (`Renderer` e `CanvasRenderer`):** Uma thread de renderização do navegador (WebGL/Canvas acelerado) ocupa a fila `rcs0` na GPU Intel Gen12 (`ecode 12:1`).
- **Mitigação Definitiva:** Manter o escalonador estável via CPU enquanto se autentica e ativa exclusivamente o microcódigo **HuC** (`compat.linuxkpi.i915_enable_guc="2"`), assegurando decodificação e aceleração de mídia eficientes sem submissão instável de comandos pelo GuC.

---

## 🛡️ A Solução Definitiva no `/boot/loader.conf`

Para neutralizar tanto a instabilidade do pipeline de energia (perda de sinal e tela preta) quanto o timeout de preempção do motor `rcs0` nos gráficos Iris Xe Alder Lake, os cinco parâmetros abaixo são aplicados no `/boot/loader.conf` via [`Setup/freebsd/desktop/system/system.sh`](../../Setup/freebsd/desktop/system/system.sh):

```text
compat.linuxkpi.i915_enable_psr="0"
compat.linuxkpi.i915_enable_psr2_sel_fetch="0"
compat.linuxkpi.i915_enable_fbc="0"
compat.linuxkpi.i915_enable_dc="0"
compat.linuxkpi.i915_enable_guc="2"
```

- **`i915_enable_psr="0"` e `i915_enable_psr2_sel_fetch="0"`:** Desativam completamente o _Panel Self Refresh_ e a busca seletiva do _PSR2_. O painel interno opera com taxa de atualização constante, eliminando o lag do cursor do mouse e a perda de sinal.
- **`i915_enable_fbc="0"`:** Desativa a compressão do framebuffer (_Framebuffer Compression_), prevenindo falhas de memória gráfica e artefatos de renderização sob o Plasma 6.
- **`i915_enable_dc="0"`:** Desativa os estados de dormência profunda da GPU (_Display C-states: DC5/DC6_).
- **`i915_enable_guc="2"`:** Habilita o microcódigo **HuC** (`2`: autenticação de workloads de mídia VA-API e decodificação acelerada) com submissão de tarefas via CPU mantida estável, eliminando instabilidades e panes de preempção da camada LinuxKPI sob pressão de RAM no FreeBSD 15.1.

> [!TIP]
> **Prevenção complementar no Firefox:** Para evitar que elementos `<canvas>` 2D mal otimizados em páginas web sobrecarreguem o processo `CanvasRenderer` na fila `rcs0`, defina `gfx.canvas.accelerated = false` no `about:config` (sem impacto em WebGL ou decodificação de vídeo VA-API).

---

## 📦 Stack de Pacotes Wayland, DRM & Firmware

Provisionado através das receitas do subsistema desktop:

| Pacote                                           | Função no Ecossistema                                                                                   |
| :----------------------------------------------- | :------------------------------------------------------------------------------------------------------ |
| **`graphics/drm-kmod`**                          | Metapacote de drivers de kernel (`drm-61-kmod`) para aceleração de vídeo Intel/AMD.                     |
| **`graphics/gpu-firmware-intel-kmod-alderlake`** | Binários de microcódigo essenciais para 12ª Geração (`adlp_dmc.bin`, `adlp_guc_70.bin`, `tgl_huc.bin`). |
| **`x11/plasma6-plasma-desktop`**                 | Núcleo do ambiente gráfico KDE Plasma 6 Wayland.                                                        |
| **`x11/wl-clipboard`**                           | Utilitários de linha de comando para manipular a área de transferência Wayland (`wl-copy`, `wl-paste`). |
| **`x11/xclip`**                                  | Ponte de compatibilidade para aplicações legadas baseadas em XWayland.                                  |
| **`x11-themes/plasma6-breeze-gtk`**              | Integração do tema visual Breeze em aplicações GTK (Firefox, VS Code).                                  |

---

## 🛠️ Comandos de Inspeção e Verificação Pós-Boot

1. **Checar se o módulo `i915kms` e o pacote de firmware Alder Lake estão presentes:**

```sh
kldstat | grep -i i915
pkg info | grep gpu-firmware-intel-kmod-alderlake
```

2. **Validar todas as flags do `i915` em tempo de voo e a ativação do HuC no `dmesg`:**

```sh
sysctl compat.linuxkpi.i915_enable_psr compat.linuxkpi.i915_enable_psr2_sel_fetch compat.linuxkpi.i915_enable_fbc compat.linuxkpi.i915_enable_dc compat.linuxkpi.i915_enable_guc && dmesg | grep -iE "drmn0|guc|huc"
```

### Saída Esperada (Estado Saudável Canônico):

```text
compat.linuxkpi.i915_enable_psr: 0
compat.linuxkpi.i915_enable_psr2_sel_fetch: 0
compat.linuxkpi.i915_enable_fbc: 0
compat.linuxkpi.i915_enable_dc: 0
compat.linuxkpi.i915_enable_guc: 2
drmn0: <drmn> on vgapci0
drmn0: [drm] Found ALDERLAKE_P (device ID 46a8) display version 13.00 stepping D0
drmn0: successfully loaded firmware image 'i915/adlp_dmc.bin'
drmn0: [drm] Finished loading DMC firmware i915/adlp_dmc.bin (v2.20)
drmn0: successfully loaded firmware image 'i915/adlp_guc_70.bin'
drmn0: successfully loaded firmware image 'i915/tgl_huc.bin'
drmn0: [drm] GT0: HuC firmware i915/tgl_huc.bin version 7.9.3
drmn0: [drm] GT0: HuC: authenticated for all workloads
drmn0: [drm] GT0: GUC: submission disabled
[drm] Initialized i915 1.6.0 for drmn0 on minor 0
```

3. **Testar a área de transferência Wayland via CLI:**

```sh
echo "Universal Environment" | wl-copy
wl-paste
```
