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

### 1.2 O Modelo GPM no Linux VT & O PTY Mouse Bridge

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
│                    │                     │             │
│                    ▼                     ▼             │
│            [Vim / Emacs]         [PTY Mouse Bridge]    │
│            (libgpm nativo)       (ctypes + python)     │
│                                          │             │
│                                          ▼ SGR 1006    │
│                                   [NeoVim / Helix]     │
└────────────────────────────────────────────────────────┘
```

1. **Vim (`+mouse_gpm`):** Linka com `libgpm.so.2`. Deve manter `ttymouse` vazio sob `$TERM == 'linux'` para ativar a leitura do socket `/dev/gpmctl`.
2. **GNU Emacs (`gpm-mouse-mode`):** Implementado no módulo interno `t-mouse.el`. Ativado via `(gpm-mouse-mode 1)` quando `$TERM == 'linux'`.
3. **NeoVim, Helix e Micro:** Operam através do wrapper `_raw_tty_pty_bridge()` em `Shell/context/desktop/common.sh`. O wrapper aloca um PTY, abre o socket do GPM via `libgpm.so.2` com `ctypes` e injeta sequências SGR 1006 (`\x1b[<btn;x;yM`) no descritor mestre (`master`) do PTY.

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
- **Mitigação 2 (Despacho Agendado):** No NeoVim, disparos de `set_cur()` são duplicados através de `vim.schedule()` para sobrescrever qualquer reset emitido pelo ciclo de redraw do TUI.

---

## 🔀 3. Substituição de Caractere Único (`r`)

Ao pressionar `r` para substituir um único caractere, o editor aguarda a entrada sem trocar formalmente de modo:

- **Vim:** Função `s:replace_single_char()` com `getcharstr()`, exibindo o cursor de replace durante a espera e restaurando o cursor anterior imediatamente após a tecla.
- **Emacs Evil:** Advice `:around` na função `evil-replace` com `unwind-protect`, garantindo a exibição do cursor de replace e sua restauração limpa.
- **NeoVim:** Interceptação por `vim.on_key` rastreando o estado de espera em modo normal e modo insert (`<C-o>r`).

---

## 🎨 4. Calibração Tonal Dinâmica de Tema

Para respeitar as diretrizes de design de temas e prevenir quebra de contraste:

1. **Proibição de Cores Fixas:** Cores literais como `#ffffff` ou `#a8a8a8` são vedadas em modos de edição.
2. **Escala Relativa de Luminância:** O cursor amostra a cor base do tema ativo (`cursor` face no Emacs, grupos `Cursor`/`Normal` no NeoVim e Vim) e calcula a luminosidade proporcional:
    - **Normal:** 100% (tom base)
    - **Insert:** 85% (atenuado)
    - **Replace:** 70% (moderado)
    - **Visual:** 55% (escurecido, priorizando o highlight da seleção)

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
