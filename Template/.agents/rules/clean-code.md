---
description: Regra canônica de Clean Code e arquitetura de comentários no ecossistema soberano.
globs: "**/*"
always_on: true
---

# 🧼 Clean Code & Arquitetura de Comentários

No ecossistema de engenharia de Gabriel Frigo, o código deve ser autoexplicativo, enxuto, determinístico e elegante por construção. Comentários narrativos que parafraseiam o óbvio mascaram complexidade acidental e devem ser evitados.

## 🚫 Diretriz contra Comentários Narrativos

- **Evite** inserir comentários explicando "o que" o código faz ou "por que" foi feito no meio de algoritmos, funções ou blocos lógicos.
- Violações típicas a rejeitar:
    - `// inicializa a variável de controle`
    - `// loop para percorrer os itens`
    - `# verifica se o arquivo existe`
    - `/* atualiza o estado */`
- Se um bloco de código parece confuso a ponto de exigir explicação textual, **refatore-o imediatamente**:
    - Extraia funções puras com nomes semânticos declarativos.
    - Adote variáveis autoexplicativas (`isCacheValid`, `maxRetryAttempts`).
    - Torne o fluxo linear e reduza aninhamentos profundos.

## 🏛️ A Hierarquia Canônica de Comentários em Três Camadas

Apenas comentários estruturais de delimitação de arquitetura são admitidos em Makefiles, infraestrutura e headers de arquivos:

1. **Header Banner do Arquivo (Exatamente 64 hífens):**
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

## ⚙️ Exceções Estritas Permitidas

Apenas instruções mandatórias para compiladores e interpretadores de sistema são permitidas:

1. **Shebang na Linha 1:** `#!/usr/bin/env sh` ou `#!/usr/bin/env bash`.
2. **Pragmas de Ferramentas:** Pragmas explicitamente exigidos (`//go:embed`, `//go:build`, `/* @vite-ignore */`, `#pragma once`).
3. **Frontmatter YAML:** Metadados estruturais em Markdown de documentação ou regras.

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
