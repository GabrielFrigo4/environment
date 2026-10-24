# ----------------------------------------------------------------

# Plano de Execução: Fase 4 — GNU Emacs & aweww (LSP da Web)

# ----------------------------------------------------------------

### ================================

### 1. OBJETIVO DA FASE

### ================================

Polir as configurações base do Emacs para operação em modo terminal (`-nw`),
blindar a inicialização contra warnings do Emacs 31+ e evoluir o pacote local
integrado `aweww` (`Editor/Emacs/usr/local/aweww/`) para o paradigma inovador
de "LSP da Web", utilizando navegadores headless via CDP com foco em soberania
(Firefox como padrão), isolamento de perfil temporário, WebSockets em Elisp puro
e reprodução de áudio/vídeo via socket IPC do `mpv` com proteção contra processos zumbis.

### ================================

### 2. ARQUIVOS ALVO

### ================================

| Arquivo                                  | Componente        | Ação                                                                                               |
| :--------------------------------------- | :---------------- | :------------------------------------------------------------------------------------------------- |
| `Editor/Emacs/etc/init/settings.el`      | Emacs             | Habilitar `xterm-mouse-mode`, `use-short-answers t` e silenciar bell sonoro                        |
| `Editor/Emacs/early-init.el`             | Emacs             | Adicionar isolamento defensivo para warnings de compilação de macros obsoletas no Emacs 31+        |
| `Editor/Emacs/usr/local/aweww/aweww.el`  | Emacs (usr/local) | Implementar motor CDP headless, WebSocket client, cascata Firefox-first e integração IPC com `mpv` |
| `Editor/Emacs/usr/local/aweww/README.md` | Emacs (usr/local) | Atualizar documentação e manual de uso do `aweww` com arquitetura CDP                              |
| `Editor/Emacs/usr/local/aweww/aweww.sh`  | Emacs (usr/local) | Atualizar rotinas de teste e compilação do componente local                                        |

### ================================

### 3. CONTRATOS TÉCNICOS

### ================================

- **Cascata Selecionável de Navegadores Headless (`defcustom`):**
    - **Opção Padrão Soberana (`'firefox-first`):**
      `firefox` -> `chromium` -> `brave` -> `google-chrome` -> `microsoft-edge`.
      Garante máxima liberdade, ausência de monocultura Blink e paridade oficial 1:1 entre Linux, FreeBSD e Windows.
    - Opções alternativas selecionáveis via `M-x customize-variable`:
        - `'chromium-first` (`chromium` -> `google-chrome` -> `brave` -> `microsoft-edge` -> `firefox`).
        - `'custom-list` (lista personalizada definida pelo usuário).
    - Comando interativo `M-x aweww-switch-browser` para alternar o motor em tempo de voo.
- **Isolamento Estrito de Perfil Temporário:**
    - O navegador headless roda com perfil efêmero e limpo em `${XDG_RUNTIME_DIR:-/tmp}/aweww-profile/` (ou `--profile` no Firefox), impedindo qualquer colisão ou lock com navegadores gráficos do usuário.
- **Engine Elisp Pura:**
    - Conexão via `websocket.el` com parse de respostas JSON via C-native `json-parse-string`.
    - DOM hidratado e Accessibility Tree passados para `shr.el` nativo com `shrface`.
- **Integração Multimídia (`mpv` JSON-IPC) & Zero Processos Zumbis:**
    - URLs de áudio e YouTube interceptadas para reprodução headless leve via `mpv --no-video --input-ipc-server=<socket>`.
    - **Process Sentinel e Cleanup:** Mapear `set-process-sentinel` e hooks em `kill-buffer-hook` e `kill-emacs-hook` para enviar comando `quit` e expurgar arquivos de socket em `/tmp/`, prevenindo processos zumbis de áudio.

### ================================

### 4. CRITÉRIOS DE ACEITE

### ================================

- [x] Inicialização batch do Emacs validada com sucesso (`make batch` / `make test` em `Editor/Emacs`).
- [x] Script de teste do componente aprovado: `sh Editor/Emacs/usr/local/aweww/aweww.sh test`.
- [x] Commit semântico atômico em `Editor/Emacs`: `feat(aweww): implement headless cdp web lsp engine with firefox default and mpv ipc` (`4bf6360`).
