---
description: Regra canônica de Clean Code e arquitetura de comentários no ecossistema soberano.
globs: "**/*"
always_on: true
---

# 🧼 Clean Code & Taxonomia Tripartite de Comentários

No ecossistema de engenharia de Gabriel Frigo, o código deve ser autoexplicativo, enxuto, determinístico e elegante por construção. A política de comentários segue uma taxonomia tripartite estrita e universal.

## 🏛️ A Taxonomia Tripartite de Comentários

### 1. Comentários de Sistema (PERMITIDOS)

Instruções mandatórias e metadados estruturais exigidos pelo sistema operacional, compiladores, interpretadores e ferramentas de análise estática:

1. **Shebang na Linha 1:** `#!/usr/bin/env sh` ou `#!/usr/bin/env python3`.
2. **Pragmas e Diretivas de Compilação:** Pragmas indispensáveis (`//go:embed`, `//go:build`, `/* @vite-ignore */`, `#pragma once`, `# shellcheck disable=...`, `;;; -*- lexical-binding: t -*-`).
3. **Frontmatter YAML:** Metadados estruturais delimitados por `---` no topo de documentações ou regras.

### 2. Comentários Estruturais de 64/32 Colunas (PERMITIDOS)

Delimitadores geométricos de arquitetura estritamente padronizados:

1. **Header Banner do Arquivo (Exatamente 64 hífens nas linhas 2-4):**
    ```text
    # ----------------------------------------------------------------
    # Makefile: <Nome do Projeto ou Módulo>
    # ----------------------------------------------------------------
    ```
2. **Seções Estruturais Maiores (Régua de 32 caracteres com igualdade):**
    ```text
    ### ================================
    ### QUALIDADE & VALIDAÇÃO
    ### ================================
    ```
3. **Subseções Internas (Régua de 32 caracteres com hífen):**
    ```text
    ### --------------------------------
    ### SETUP & GANCHO LOCAL
    ### --------------------------------
    ```
4. **Seções Estruturais em `.gitignore` (Régua de 64 caracteres com igualdade):**
    ```text
    # ================================================================
    # Operating System Cruft
    # ================================================================
    ```
5. **Regra do Não-Vazamento:** O título da seção DEVE estar estritamente contido no limite de 32 colunas (ou 64 em `.gitignore`), sem parênteses ou caracteres soltos que vazem a régua.

### 3. Comentários Explicativos/Narrativos (ESTRITAMENTE PROIBIDOS)

É expressamente proibido inserir comentários explicando o que o código faz, como faz ou parafraseando lógica algorítmica:

- **Proibição Universal:** Aplica-se a código-fonte executável, scripts utilitários, dotfiles, manifestos de configuração **E TAMBÉM a blocos de código dentro de documentos Markdown**!
- Violações típicas a rejeitar:
    - `// inicializa a variável de controle`
    - `// loop para percorrer os itens`
    - `# verifica se o arquivo existe`
    - `/* atualiza o estado */`
- Se um bloco de código parece complexo a ponto de sugerir explicação textual, **refatore-o imediatamente**:
    - Extraia funções puras com nomes semânticos declarativos.
    - Adote variáveis autoexplicativas (`isCacheValid`, `maxRetryAttempts`).
    - Torne o fluxo linear e reduza aninhamentos profundos.

## 🚫 Banimento de Notação Octal para Bytes e Escapes ANSI

- Não utilize notação octal (`\033`, `\001`, `\077`) para caracteres de escape ANSI, formatação de cores em terminal ou bytes arbitrários.
- **Forma Canônica:** Utilize `$'\e'` (em Makefiles: `_e=$$'\e';`) ou escapes hexadecimais (`\x1b`, `\x01`).
- **Exceção Exclusiva para Octal:** Notação octal é aceita e exigida **estritamente** em contextos onde a natureza matemática da informação é octal por definição de sistema de arquivos POSIX (`chmod 0755`, `chmod 0644`, `chmod 0700`, `chmod 0600`, `umask 022`).

## 🏕️ Regra do Escoteiro (Boy Scout Rule)

- Sempre deixe o arquivo mais limpo, mais aderente aos padrões e com menos warnings do que quando você o abriu.
- Encontrou whitespace residual no final de linhas, shebangs incorretos, permissões erradas ou comentários narrativos? Corrija-os proativamente.

## 📦 Hermetismo de Produção (`rm -rf .agents`)

- O código em produção, compilação de binários e rotinas de deploy **NUNCA** devem depender de arquivos contidos em `.agents/` ou `.githooks/`.
- Deletar `.agents/` deve deixar o repositório 100% operacional.
