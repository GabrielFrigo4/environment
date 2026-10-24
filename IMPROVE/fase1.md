# ----------------------------------------------------------------

# Plano de Execução: Fase 1 — Setup & Provisionamento de Base

# ----------------------------------------------------------------

### ================================

### 1. OBJETIVO DA FASE

### ================================

Provisionar pacotes de sistema, micro-compositores Wayland, players de mídia,
navegadores com suporte a headless CDP (Firefox & Chromium), tipografia de
console, suporte a mouse suave no TTY do kernel e dependências de compilação
para módulos nativos do Emacs OS.

### ================================

### 2. ARQUIVOS ALVO

### ================================

| Arquivo                                | Componente | Ação                                                                                                                                                                      |
| :------------------------------------- | :--------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `Setup/common/graphics/compositors.sh` | Setup      | Criar receita de micro-compositores (`sway`, `river`, `labwc`, `cage`, `seatd`, `foot`, `wlr-randr`)                                                                      |
| `Setup/common/media/players.sh`        | Setup      | Criar receita de players de mídia (`mpv` e `vlc`) com `yt-dlp`                                                                                                            |
| `Setup/common/web/browsers.sh`         | Setup      | Garantir instalação universal de `firefox` (padrão) e `chromium` (FreeBSD/Linux via pkg/dnf/apt; Windows via `Hibbiki.Chromium` e `eloston.ungoogled-chromium` no Winget) |
| `Setup/common/fonts/terminus.sh`       | Setup      | Criar receita de fontes Terminus (`terminus-fonts`, `terminus-ttf`, `terminus-fonts-console`)                                                                             |
| `Setup/freebsd/desktop/all.sh`         | Setup      | Configurar `sysrc moused_enable="YES"`, `sysrc moused_flags="-A 1.5,1.5 -a 1.2"` (mouse suave) e `sysrc keyrate="fast"`                                                   |
| `Setup/linux/common/system/console.sh` | Setup      | Adicionar provisionamento e ativação do `gpm` com aceleração suave e alta taxa de amostragem (`-a 2 -r 100`)                                                              |
| `Setup/common/languages/rust-ewm.sh`   | Setup      | Criar receita das dependências de compilação do EWM (Rust, `cargo`, `pkgconf`, `libinput`, `libxkbcommon`, `pixman`, `libgbm`, `hwdata`)                                  |

### ================================

### 3. CONTRATOS TÉCNICOS

### ================================

- Conformidade estrita com POSIX `/bin/sh` e cabeçalho `set -eu`.
- Despacho idempotente pela hierarquia canônica de gerenciadores:
  `pkg` (FreeBSD) -> `dnf` (Fedora) -> `apt` (Debian/Ubuntu) -> `pacman` (Arch/MSYS2) -> `winget` (Windows).
- Permissões octais canônicas: `0755` para scripts executáveis.
- Mensagens padronizadas pela biblioteca semântica `_ui_*`.
- Zero comentários narrativos no corpo do código.
- Aceleração de mouse calibrada tanto no FreeBSD (`moused_flags`) quanto no Linux (`gpm`).

### ================================

### 4. CRITÉRIOS DE ACEITE

### ================================

- [x] Execução limpa e idempotente de cada receita (`exit 0`).
- [x] `make test` em `Setup/` aprovado sem falhas sintáticas ou linters.
- [x] Teste de reinstalação sem efeitos colaterais.
- [x] Commit semântico atômico no sub-repositório `Setup`: `feat(setup): add wayland compositors, media players, smooth mouse and ewm toolchain` (commit `f93fa26`).
