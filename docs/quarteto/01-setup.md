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
├── common/             # Receitas universais multi-SO (ai/ollama.sh, etc.)
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

Em conformidade com a evolução antifrágil do ecossistema, o Setup rejeita qualquer emulação de ternário em subshell (`ELEVATE="$(...)"`) sob `set -e`. O bloco explícito canônico garante imunidade contra encerramentos fatais:

```sh
#!/usr/bin/env sh
set -eu

# Resolução canônica antifrágil de privilégios
ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo > "/dev/null" 2>&1; then
        ELEVATE="sudo"
    elif command -v doas > "/dev/null" 2>&1; then
        ELEVATE="doas"
    else
        echo "❌ Este script requer privilégios de superusuário (sudo ou doas)." >&2
        exit 1
    fi
fi

# Invocação limpa e segura
$ELEVATE pkg install -y git
```

---

## 🛡️ Auditoria Estática Contínua (`all.py`)

O Setup mantém uma bateria rigorosa de auditorias locais executadas via Python antes de cada commit:

- Validação estrita de modo de permissão POSIX (`0755` para scripts).
- Inspeção de banners visuais com exatamente 64 caracteres.
- Detecção e eliminação de comandos `shift` sem proteção de contagem `$#`.
- Verificação de sintaxe de shell através de interpretadores estritos.
