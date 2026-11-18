# 🛠️ Setup: Provisionamento Ativo de Sistema

> Documentação canônica do Setup: receitas de provisionamento idempotentes, modelo zero-clone via GitHub RAW, matriz multi-SO e elevação antifrágil.

---

## 🧭 O Papel do Setup no Ecossistema

O repositório **Setup** é o **braço executor de privilégios** do ecossistema. Ele é o único componente autorizado a interagir com arquivos de sistema (`/etc`, `/usr/local`, `/var`), instalar pacotes nativos e configurar controladores de hardware via `sudo` ou `doas`.

### Invariantes Fundamentais do Setup:

1. **Idempotência Absoluta:** Qualquer receita do Setup pode ser executada centenas de vezes consecutivas sem corromper arquivos ou falhar caso um pacote já esteja instalado.
2. **Modelo Zero-Clone:** Qualquer script do Setup pode ser invocado diretamente da web sem a necessidade de clonar o repositório Git localmente:
    ```sh
    curl -fsSL https://raw.githubusercontent.com/GabrielFrigo4/setup/main/freebsd/desktop/system/ttys.sh | sudo sh
    ```
3. **Resolução Antifrágil de Privilégios (`ELEVATE`):** Scripts que necessitam de privilégios de superusuário resolvem o binário de elevação dinamicamente e suportam execução direta como root, via `sudo` ou via `doas`.

---

## 🗄️ Estrutura de Diretórios Canônica

```text
Setup/
├── common/             # Receitas universais multi-SO
│   ├── ai/             # Ollama e aceleração de IA
│   ├── editors/        # Editores de código (Emacs, Neovim, Vim, Helix, Micro)
│   ├── graphics/       # Slang, shaders e Vulkan
│   ├── office/         # Suítes de produtividade (LibreOffice, Collabora)
│   └── workspace/      # Organização de repositórios e projetos
├── freebsd/            # Provisionamento FreeBSD
│   ├── container/      # Bhyve, Jails, Bastille
│   ├── desktop/        # DRM, áudio, KDE Plasma 6, ttys.sh, Ly
│   └── server/         # Serviços headless, SSH, ZFS
├── linux/              # Provisionamento Linux
│   ├── arch/
│   ├── debian/
│   ├── fedora/
│   └── desktop/
├── windows/            # Provisionamento Windows via WinGet
└── .scripts/audit/     # Suíte de auditoria estática (all.py, banners.py)
```

---

## 🔒 O Padrão Canônico de Elevação (`ELEVATE`)

O Setup adota a resolução explícita de `ELEVATE` via condicional POSIX sob `set -eu`, evitando falhas causadas por subshells de teste de comando:

```sh
#!/usr/bin/env sh
set -eu

ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo > "/dev/null" 2>&1; then
        ELEVATE="sudo"
    elif command -v doas > "/dev/null" 2>&1; then
        ELEVATE="doas"
    else
        echo "Erro: Privilegios de superusuario necessarios (sudo ou doas)." >&2
        exit 1
    fi
fi

$ELEVATE pkg install -y git
```

---

## 📦 Provisão Modular de Escritório e Editores

### Suíte LibreOffice Completa (`common/office/office.sh`)

A receita universal de escritório automatiza a instalação e integração adaptativa de todos os 6 componentes da suíte LibreOffice:

- **Componentes:** `Writer` (texto), `Calc` (planilhas), `Impress` (apresentações), `Draw` (vetores/diagramas), `Math` (fórmulas) e `Base` (banco de dados).
- **Plugins VCL & Integração GTK3:** Instala `libreoffice-gtk3` e `libreoffice-gtk4`, mantendo o tema claro/escuro sob controle dinâmico do ambiente desktop.
- **Injeção Limpa nos `.desktop`:** Copia e atualiza os lançadores em `~/.local/share/applications/` aplicando `env SAL_USE_VCLPLUGIN=gtk3 ` (sem fixar `GTK_THEME`) e `NoDisplay=false` para expor o lançador genérico `libreoffice-startcenter.desktop`.
- **Higienização de Sessão (`environment.d` / `systemd`):** Remove `~/.config/environment.d/gtk-dark.conf`, limpa variáveis estáticas `GTK_THEME` e `GTK_APPLICATION_PREFER_DARK_THEME` no `systemctl --user`, e propaga apenas `SAL_USE_VCLPLUGIN=gtk3` via `systemctl --user` e `dbus-update-activation-environment`.
- **Runtimes Flatpak:** Executa `flatpak override --unset-env=GTK_THEME` (usuário e sistema) e instala `org.gtk.Gtk3theme.adw-gtk3` e `org.gtk.Gtk3theme.adw-gtk3-dark` do Flathub para que aplicativos empacotados sigam automaticamente o esquema ativo do sistema.

### Preservação e Lançador Adaptativo do Emacs (`common/editors/editors.sh`)

A receita de editores padroniza a integração desktop do GNU Emacs sem sobrescrever configurações gerenciadas pelo **Profile**:

- **Preservação do Profile & Fallback `emacs.desktop`:** Mantém intactos symlinks e lançadores já sincronizados pelo **Profile**. Quando ausente (ou caso detecte arquivo legado contendo `GTK_THEME=`), cria `emacs.desktop` adaptativo (em `~/.local/share/applications/` e `/usr/local/share/applications/` quando elevado) invocando `emacs-client` ou `emacsclient --create-frame --alternate-editor="" "$@"` sem forçar `GTK_THEME`.
- **Ocultação de Entradas Redundantes:** Gera arquivos com `NoDisplay=true` para `emacsclient.desktop`, `emacs-mail.desktop` e `emacsclient-mail.desktop` apenas quando ainda não existem, evitando duplicidade no menu de aplicativos.
- **Editores Adicionais:** Clona e sincroniza repositórios soberanos para Neovim (`~/.config/nvim`), Vim (`~/.vim` e `.vimrc`), Helix (`~/.config/helix`) e Micro com tema Dracula (`~/.config/micro`).

---

## 🛡️ Auditoria Estática Contínua (`all.py`)

O Setup mantém uma bateria de auditorias locais executadas via Python antes de cada commit:

- Validação estrita de modo de permissão POSIX (`0755` para scripts executáveis, `0644` para arquivos de configuração e documentação).
- Inspeção de banners visuais com exatamente 64 caracteres de largura no topo e 32 caracteres em seções.
- Detecção e eliminação de comandos `shift` sem proteção de contagem `$#`.
- Verificação de sintaxe de shell através de interpretadores estritos.
