# ⚡ Perfis de Terminal & Emissão Semântica no Windows

> Padronização de terminais no Windows: dotfiles declarativos para PowerShell 7, Nushell e CMD/Clink com a biblioteca de emissão semântica `_ui_*`.

---

## 🧭 O Desafio do Terminal no Windows

Ambientes Windows frequentemente sofrem com scripts de terminal rústicos que abusam de `Write-Host` ou `echo` ad-hoc com cores inconsistentes e ausência de tratamento estruturado de erros.

No Universal Environment, os terminais da **Classe 3 (Bronze)** compartilham:

1. **Biblioteca de Emissão Semântica `_ui_*`:** Funções padronizadas que replicam a experiência visual do Universal Shell UNIX (`_ui_step`, `_ui_ok`, `_ui_warn`, `_ui_err`, `_ui_info`, `_ui_banner`).
2. **Atalhos Simétricos da Família `up*`:** Comandos universais de atualização (`upall`, `upgit`, `upsys`, `sync-profile`).
3. **Prompt Git Resiliente em NTFS:** O prompt de terminal utiliza `git status --porcelain=v1` em vez de chamadas de baixo nível de índice (`git diff-index`), prevenindo falsos positivos decorrentes de granularidade de timestamps no NTFS.

---

## 🔷 PowerShell 7: O Perfil Canônico (`profile.ps1`)

O arquivo de perfil reside em `$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` (ou no diretório `$XDG_CONFIG_HOME\powershell\profile.ps1`).

### A Biblioteca Semântica `_ui_*` em PowerShell:

```powershell
# ================================================================
# Funções Semânticas de Interface (_ui_*)
# ================================================================
function _ui_banner([string]$Text) {
    $line = "=" * 60
    Write-Host "`n$line" -ForegroundColor DarkCyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "$line`n" -ForegroundColor DarkCyan
}

function _ui_step([string]$Text) {
    Write-Host ":: " -ForegroundColor Cyan -NoNewline
    Write-Host $Text
}

function _ui_ok([string]$Text) {
    Write-Host "  [OK] " -ForegroundColor Green -NoNewline
    Write-Host $Text
}

function _ui_warn([string]$Text) {
    Write-Host "  [AVISO] " -ForegroundColor Yellow -NoNewline
    Write-Host $Text
}

function _ui_err([string]$Text) {
    Write-Host "  [ERRO] " -ForegroundColor Red -NoNewline
    Write-Host $Text
}
```

### Integração da Família de Atualizações (`up*`):

```powershell
function upall {
    _ui_banner "ATUALIZAÇÃO GERAL DO SISTEMA"
    _ui_step "Atualizando pacotes do sistema via WinGet..."
    winget upgrade --all --include-unknown
    _ui_step "Atualizando repositórios Git..."
    upgit
    _ui_ok "Sistema completamente atualizado!"
}
```

---

## 🦀 Nushell: O Shell Estruturado Moderno (`config.nu`)

Para usuários que preferem um pipeline de dados tipado e nativo em Rust, o **Nushell** é provisionado via `Profile/terminals/nushell/config.nu`:

- Pipelines que operam sobre tabelas e registros JSON/YAML em vez de fluxos de bytes puros.
- Prompt assíncrono com tema Kanagawa integrado.
- Funções compatíveis para sincronização do ambiente:
    ```nu
    # Atualizar repositórios com Nushell
    def upgit [] {
        print "🔄 Atualizando repositórios Git recursivamente..."
        ls **/.git | each { |it|
            let repo = ($it.name | path dirname)
            print $"⬇️ Pulling ($repo)..."
            git -C $repo pull --ff-only
        }
    }
    ```

---

## 📟 CMD Clássico Aprimorado com Clink (`clink.lua`)

Mesmo o interpretador clássico `cmd.exe` recebe tratamento de primeira linha através do **Clink** (motor de emulação GNU Readline injetado na memória do CMD):

- Histórico pesquisável via `Ctrl + R`.
- Auto-completar inteligente com suporte a flags de comandos modernos (`git`, `winget`, `podman`).
- Script Lua `clink.lua` que provê o tema de prompt com status de branch Git sem atraso perceptível de digitação.
