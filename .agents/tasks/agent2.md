# 🤖 Agent 2: Arquitetura Modular & Auto-Detecção Sensorial do GNU Emacs

> **Plano Operacional Especializado — Épico 9 do Ecossistema**
> 🔒 **Trava de Modelo:** Exclusivo **Gemini Pro 4** (demanda orquestração Elisp avançada, bootstrapping assíncrono via Elpaca, depuração de compilação nativa C-level e arquitetura de módulos resilientes).
> **Referência Obrigatória Prévia:** Leia atentamente o [`all_agents.md`](all_agents.md).

---

## 🎯 1. Objetivo Central da Missão

Elevar a configuração do **GNU Emacs 30.1+** (`~/Documents/Environment/Editor/Emacs`), transformando o ambiente em uma plataforma modular, sensorialmente adaptativa (auto-detectando Wayland, X11, DirectWrite, `libgccjit` e aceleração gráfica), com carregamento assíncrono blindado via Elpaca e boot batch/headless em tempo inferior a 1 segundo.

---

## 🗺️ 2. Topografia de Arquivos a Explorar

O agente deve mapear e inspecionar a árvore do repositório `Editor/Emacs`:

1. **Ciclo de Boot Primário:**
    - [`Editor/Emacs/early-init.el`](file:///home/gabrielf/Documents/Environment/Editor/Emacs/early-init.el): Configurações críticas pré-GUI, alocação de Garbage Collection (`gc-cons-threshold`), supressão de redraws e inibição de barras nativas.
    - [`Editor/Emacs/init.el`](file:///home/gabrielf/Documents/Environment/Editor/Emacs/init.el): Entrypoint do bootstrapping, carregador do Elpaca e módulos.
2. **Gerenciador de Pacotes Declarativo:**
    - [`Editor/Emacs/elpaca.el`](file:///home/gabrielf/Documents/Environment/Editor/Emacs/elpaca.el) (ou módulos de bootstrap): Configuração da esteira paralela e assíncrona de instalação e atualização de pacotes.
3. **Módulos Especializados em `lisp/` ou `core/`:**
    - Configurações de UI, Eglot (LSP), Tree-sitter nativo, Org-mode e `gptel` (IA).
4. **Makefile & Quality Gates:**
    - [`Editor/Emacs/Makefile`](file:///home/gabrielf/Documents/Environment/Editor/Emacs/Makefile): Alvos de validação em lote (`make test`, `emacs --batch -l init.el`).

---

## 📋 3. Roteiro Metódico de Execução (Passo a Passo)

### Fase 1: Camada Sensorial de Hardware & Display

- [x] Implementar em Elisp predicados de auto-detecção de sistema e servidor gráfico:
    - `(featurep 'pgtk)`: Detecção de Pure GTK sob Wayland.
    - `(eq window-system 'x)`: Detecção de X11 tradicional.
    - `(eq window-system 'w32)`: Detecção de Windows nativo (DirectWrite).
    - `(not window-system)`: Detecção de execução em modo terminal puro (TTY).
- [x] Auto-detecção de compilação nativa (`libgccjit`):
    - Verificar `(featurep 'native-compile)` antes de configurar `native-comp-async-report-warnings-errors` e diretórios de cache `eln-cache`.

### Fase 2: Tipografia Adaptativa & Engine de Fontes

- [x] No Windows: Configurar backend de fontes DirectWrite para evitar fontes borradas ou serrilhadas.
- [x] No Linux e FreeBSD: Configurar HarfBuzz e Fontconfig priorizando fontes monoespaçadas com suporte a ligaduras (ex: JetBrains Mono, Fira Code, Hack) com fallback transparente para Nerd Fonts e emojis Noto/Symbola.
- [x] Em modo TTY (`not window-system`): Forçar desativação de glyphs compostos pesados e garantir que o tema use cores ANSI de 16/256 cores sem travamentos.

### Fase 3: Desacoplamento Modular com Blindagem `condition-case`

- [x] Organizar a pasta `lisp/` ou `modules/` em camadas funcionais:
    - `core-ui.el`: Modeline, temas, fontes e janelas.
    - `core-editor.el`: Comportamento modal, navegação, histórico e buffers.
    - `core-dev.el`: Eglot LSP, Tree-sitter, formatadores e REPLs.
    - `core-org.el`: Org-mode, agenda, capture templates.
    - `core-ai.el`: `gptel` e integrações de LLM.
- [x] Envolver o carregamento de cada módulo subordinado em um bloco defensivo `condition-case`:
    ```elisp
    (condition-case err
        (require 'meu-modulo)
      (error (message "[ERRO] Falha ao carregar modulo meu-modulo: %s" err)))
    ```
    Isso garante que um pacote corrompido ou indisponibilidade de rede NUNCA impeça a abertura do editor.

### Fase 4: Modernização da IA Local (`gptel` + Ollama)

- [x] Atualizar a lista de modelos pré-configurados do Ollama no `gptel`:
    - Expurgar referências a modelos obsoletos.
    - Adicionar modelos modernos: `gemma2:9b`, `qwen2.5-coder:7b`, `phi4:14b`, `deepseek-r1:8b`.
- [x] Implementar a função `ollama-detect-p`: Testar via socket/probe TCP leve (`make-network-process`) na porta `11434` se o daemon local do Ollama está ativo, desativando comandos de IA graciosamente caso offline.

### Fase 5: Validação Headless & Testes em Batch

- [x] Testar a inicialização completa sem GUI via:
    ```sh
    emacs --batch --eval "(message \"Boot OK em %s\" (emacs-init-time))" -l init.el
    ```
- [x] Assegurar que o tempo de inicialização em batch seja inferior a 1.0 segundo.
- [x] Executar `make -C Editor/Emacs test` e assegurar zero warnings fatais.

---

## ⚠️ 4. Invariantes Críticas & Gotchas

1. **Invariante `rm -rf .agents`:** Código Elisp de produção não pode referenciar diretórios `.agents/`.
2. **Submódulos vs Árvores Rastreadas:** Lembre-se de que pacotes locais em `usr/local/` (`aweshell`, `aweww`, `emacs-lisp-ts-mode`) são arquivos rastreados nativos no Git, não submódulos externos.
3. **Menu Bar e Tool Bar:** No FreeBSD/Linux desktop, preserve a ativação dinâmica de barras de menu/ferramentas com tema Breeze-Dark GTK conforme alinhado no ecossistema, mantendo a guarda para desativação em consoles TTY.
