---
name: deep-investigation
description: >-
    Runbook cognitivo para diagnóstico técnico de causa raiz no hub orquestrador.
    Usar ao investigar falhas de submódulos Git, descompasso entre repositórios,
    erros no Makefile central e anomalias na CLI do GitHub.
---

# 🔍 Deep Investigation — Diagnóstico Técnico de Causa Raiz

Esta skill define o protocolo para análise de defeitos e investigação técnica de causa raiz no repositório **Universal Environment** (hub orquestrador).

Diante de quebras em submódulos, dessincronização de documentação, erros de orquestração via Makefile ou falhas de comunicação com a CLI do GitHub, as decisões devem ser fundamentadas rigorosamente na inspeção empírica de fontes primárias, sem suposições conceituais.

---

## 🏛️ Hierarquia e Consulta a Fontes Primárias

Toda hipótese diagnóstica deve ser validada contra documentações oficiais e o estado físico versionado:

1. **Nível 1 (Manpages e Especificações Oficiais):**
    - Submódulos e referências Git: documentação oficial de `git-submodule`, `git-remote` e `git-worktree`.
    - Ferramentas GitHub: manual oficial da CLI `gh` (`cli.github.com/manual`).
    - Automação de compilação: documentação canônica do GNU Make.
2. **Nível 2 (Repositórios Upstream do Ecossistema):**
    - Manuais e declarações de diretrizes nos componentes (`Setup`, `Shell`, `Vault`, `Profile`, `Editor/*`).
    - Análise cruzada das fontes de verdade (`ENVIRONMENT.md`, `PRINCIPLES.md`).
3. **Nível 3 (Estado do Ambiente Local):**
    - Estado de ponteiros e commits locais (`git submodule status`, `git log`, `git diff`).
    - Integridade da árvore de trabalho e validação de hooks.

---

## 📋 Protocolo Sequencial de Diagnóstico

Ao receber um relato de falha ou comportamento inesperado:

1. **Isolamento de Estado:**
    - Inspecione ponteiros de submódulos com `git submodule status`.
    - Identifique submódulos não inicializados ou descompassados com o branch de trabalho.
2. **Auditoria de Sincronização:**
    - Compare hashes criptográficos de arquivos de documentação canônica distribuídos entre os repositórios.
    - Localize divergências de conteúdo entre o hub e seus componentes.
3. **Validação Estática e Dry-Run:**
    - Execute a suíte de status com `make status`.
    - Realize simulação de execução de alvos críticos via `make --dry-run <alvo>`.
4. **Resolução de Conflitos de API:**
    - Valide tokens de autenticação via `gh auth status` antes de operações remotas.
    - Analise saídas detalhadas de erro sem mascaramento de stderr.
