# 🖱️ Subsistemas de TTY: Mouse, Formatos de Cursor & Paletas DAC

> Documentação técnica canônica sobre a arquitetura de mouse, controle de formatos de cursor de hardware e padronização da paleta de 16 cores nos consoles puros do ecossistema (**FreeBSD `vt(4)`** e **Linux VT**).

---

## 🏛️ 1. O Mouse em Consoles Virtuais: FreeBSD vs Linux

### 1.1 Emulação de Kernel no FreeBSD `vt(4)`

No FreeBSD, a integração de mouse opera inteiramente em **nível de driver de kernel** (`sys/dev/vt/vt_core.c`):

1. O daemon `moused` lê o dispositivo físico (`/dev/ums0` ou `/dev/psm0`) e escreve em `/dev/sysmouse`.
2. O driver `vt(4)` monitora as sequências de ativação de mouse emitidas pelas aplicações (`\e[?1000h`, `\e[?1002h`, `\e[?1006h`).
3. Quando ativadas, o kernel intercepta cliques e movimentos e injeta sequências padrão **xterm SGR 1006** (`\e[<btn;col;linM`) diretamente no buffer de entrada (`stdin`) do terminal.
4. **Resultado:** Aplicações modernas desacopladas (NeoVim, Helix, Micro) operam com mouse nativo sem exigir nenhuma biblioteca externa.

---

### 1.2 O Modelo GPM no Linux VT & Diretriz Soberana de I/O Direto

No Linux, o driver do terminal virtual (`drivers/tty/vt/`) não provê emulação de sequências xterm no `stdin`. O ecossistema depende historicamente do **GPM** (_General Purpose Mouse_):

```
┌────────────────────────────────────────────────────────┐
│                   Linux Console (TTY)                  │
│                                                        │
│  [Hardware Mouse] ──> [/dev/input/mice]               │
│                             │                          │
│                             ▼                          │
│                     [gpm daemon]                       │
│                             │                          │
│                             ▼                          │
│                  UNIX Socket: /dev/gpmctl              │
│                    │                                   │
│                    ▼                                   │
│            [Vim (+mouse_gpm)]                          │
│            (libgpm nativo em C)                        │
└────────────────────────────────────────────────────────┘
```

1. **Vim (`+mouse_gpm`):** Linka com `libgpm.so.2`. Deve manter `ttymouse` vazio sob `$TERM == 'linux'` para ativar a leitura do socket `/dev/gpmctl`. O mouse reage estritamente ao clique (`GPM_DOWN`), ignorando hover.
2. **Rejeição do Bridge PTY Virtual:** Envelopar editores de texto interativos (`nvim`, `hx`, `micro`, `emacs`) sob wrappers virtuais de PTY (`pty.fork`) em Python introduz latência de I/O, instabilidade no repasse de sinais (`SIGWINCH`, `SIGTSTP`) e risco de anomalias no cursor. O ecossistema adota a **Diretriz Soberana de I/O Direto**: editores executam diretamente contra o descritor de terminal provido pelo kernel (`direct stdio`), priorizando estabilidade e simplicidade sobre pontes artificiais de mouse.

---

## 📐 2. Formatos de Cursor no Linux VT & Bug de Terminfo

O Linux VT provê controle de scanlines do cursor de hardware VGA via códigos de escape privados:

| Código   | Formato de Hardware            | Estado nos Editores            |
| :------- | :----------------------------- | :----------------------------- |
| `\e[?1c` | Oculto                         | Ocultação temporária           |
| `\e[?2c` | Sublinhado fino inferior (20%) | Modo Insert (`i`)              |
| `\e[?3c` | Sublinhado médio (35%)         | Linha de comando (`:`)         |
| `\e[?4c` | Meio bloco inferior (50%)      | Modo Replace (`r`, `R`)        |
| `\e[?5c` | Três quartos de bloco (75%)    | Modo Visual (`v`, `V`, `\x16`) |
| `\e[?6c` | Bloco sólido completo (100%)   | Modo Normal (`n`)              |

### Mitigação do Bug Upstream de Terminfo

No arquivo de terminfo padrão (`/usr/share/terminfo/l/linux`), as entradas de visibilidade contêm `cnorm=\E[?25h\E[?0c`. O código `\E[?0c` reseta o hardware para o bloco padrão do kernel a cada redesenho de tela.

- **Mitigação 1 (Terminfo Sanitizado):** Compilação automática de `~/.terminfo/l/linux` com `cnorm=\E[?25h`, `cvvis=\E[?25h`, `civis=\E[?25l` via `tic`.
- **Mitigação 2 (Despacho Agendado):** No NeoVim, disparos de `set_cur()` são duplicados através de `vim.schedule()` e `vim.defer_fn(emit, 15)` para sobrescrever qualquer reset emitido pelo ciclo de redraw do TUI.

---

## 🔀 3. Substituição de Caractere Único (`r`)

Ao pressionar `r` para substituir um único caractere, o editor aguarda a entrada sem trocar formalmente de modo:

- **Vim:** Função `s:replace_single_char()` com `getcharstr()`, chamando `redraw` explícito antes e depois da leitura, cobrindo `r` no modo normal e `<C-o>r` no modo insert.
- **Emacs Evil:** Interceptação via advice em `evil-refresh-cursor` verificando `evil-force-cursor == 'replace'` gerado pela especificação `interactive` de `evil-replace`.
- **NeoVim:** Interceptação por `vim.on_key` rastreando o estado de espera em modo normal (`n`) e transição de insert (`niI`).

---

## 🎨 4. Alpha Blending Real & Simetria de Plataformas

Para respeitar as diretrizes de design de temas e garantir invariância de contraste em **Dark Mode** e **Light Mode**:

### 4.1 A Falha da Atenuação Linear Simples

Multiplicar os canais RGB por um fator ($R \times 0.85$) falha criticamente em temas claros:

- Em **Light Mode** (cursor preto `(0, 0, 0)` sobre fundo branco `(255, 255, 255)`), multiplicar `0` por qualquer valor resulta em `0` (continua preto sólido). Se o cursor for cinza escuro, multiplicar por 0.55 o torna _ainda mais escuro_ (aumentando o contraste em vez de suavizá-lo).

### 4.2 A Fórmula Matemática de Alpha Blending

A transparência genuína é obtida interpolando linearmente (lerp) a cor do cursor ($C_{\text{cur}}$) contra a **cor de fundo ativa do tema** ($C_{\text{bg}}$) usando o coeficiente de opacidade $\alpha \in [0.0, 1.0]$:

$$C_{\text{final}} = \text{round}(C_{\text{cur}} \times \alpha + C_{\text{bg}} \times (1 - \alpha))$$

| Modo de Edição | Opacidade ($\alpha$) | Dark Mode (Fundo Escuro)   | Light Mode (Fundo Claro)   |
| :------------- | :------------------: | :------------------------- | :------------------------- |
| **Normal**     |    `1.00` (100%)     | Sólido (100% contraste)    | Sólido (100% contraste)    |
| **Insert**     |     `0.92` (92%)     | Levemente translúcido      | Levemente translúcido      |
| **Minibuffer** |     `0.84` (84%)     | Focado na linha de comando | Focado na linha de comando |
| **Replace**    |     `0.76` (76%)     | Moderadamente translúcido  | Moderadamente translúcido  |
| **Visual**     |     `0.68` (68%)     | Translúcido atenuado       | Translúcido atenuado       |

### 4.3 Simetria Técnica: FreeBSD `vt(4)` vs Linux VT

- **No FreeBSD `vt(4)`:** O driver de console suporta sequências **OSC 12** (`\e]12;#RRGGBB\7`) para reprogramar a cor RGB do cursor em tempo real, porém não implementa controle de scanlines VGA. Portanto, **Alpha Blending via OSC 12 é o mecanismo canônico de indicação modal**.
- **No Linux VT:** O driver de console **NÃO** suporta OSC 12 (ignora a sequência) e sua cor é acoplada à máscara de atributos de célula. Em contrapartida, suporta nativamente **scanlines de hardware (`\e[?c`)**, tornando a indicação modal por **forma física** o padrão canônico no Linux.

---

## 🌈 5. Padronização da Paleta DAC de 16 Cores com FreeBSD `vt(4)`

A tabela DAC de 16 cores do Linux VT é reprogramada para espelhar exatamente os valores de fábrica do FreeBSD `vt(4)` (`sys/dev/vt/vt.h`):

| Índice | Cor           | Hexadecimal | RGB Decimal     |
| :----: | :------------ | :---------- | :-------------- |
| **0**  | Black         | `#000000`   | `0, 0, 0`       |
| **1**  | Dark Red      | `#7f0000`   | `127, 0, 0`     |
| **2**  | Dark Green    | `#007f00`   | `0, 127, 0`     |
| **3**  | Dark Yellow   | `#c4a100`   | `196, 161, 0`   |
| **4**  | Dark Blue     | `#3366a3`   | `51, 102, 163`  |
| **5**  | Dark Magenta  | `#7f007f`   | `127, 0, 127`   |
| **6**  | Dark Cyan     | `#007f00`   | `0, 127, 127`   |
| **7**  | Light Gray    | `#bfbfbf`   | `191, 191, 191` |
| **8**  | Dark Gray     | `#73828a`   | `115, 130, 138` |
| **9**  | Light Red     | `#ff0000`   | `255, 0, 0`     |
| **10** | Light Green   | `#00ff00`   | `0, 255, 0`     |
| **11** | Light Yellow  | `#ffff00`   | `255, 255, 0`   |
| **12** | Light Blue    | `#739ecf`   | `115, 158, 207` |
| **13** | Light Magenta | `#ff00ff`   | `255, 0, 255`   |
| **14** | Light Cyan    | `#00ffff`   | `0, 255, 255`   |
| **15** | White         | `#ffffff`   | `255, 255, 255` |

### Mecanismos de Aplicação:

- **Shell (`Shell/core/environment.sh`):** Sequência OSC `\e]P0000000\e]P17f0000...\e]PFffffff` no boot do console.
- **Setup (`Setup/linux/common/system/console.sh`):** Configuração persistente via sysfs em `/etc/tmpfiles.d/console-cursor.conf` escrevendo os arrays em `/sys/module/vt/parameters/default_{red,grn,blu}`.
