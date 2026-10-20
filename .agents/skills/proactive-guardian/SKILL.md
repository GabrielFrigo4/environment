---
name: proactive-guardian
description: >-
    Runbook cognitivo para governança proativa e garantia contínua de qualidade no hub.
    Usar ao auditar consistência de documentação canônica, estado de submódulos,
    integridade do Makefile e integridade de comentários estruturais.
---

# 🛡️ Proactive Guardian — Auditoria Autônoma de Qualidade

Esta skill orienta a postura operacional preventiva no repositório **Universal Environment** (hub orquestrador). O agente atua de forma autônoma para identificar desvios, inconsistências estruturais e quebras de convenção antes da entrega final.

---

## 🏛️ Postura de Ação Autônoma

O agente identifica e propõe a regularização imediata das seguintes anomalias:

- **Sincronização de Documentação Canônica:** Ao constatar alterações em `ENVIRONMENT.md` ou `PRINCIPLES.md` no hub, sinalize a necessidade de propagação via `make sync-docs` para os sub-repositórios.
- **Ponteiros de Submódulos:** Identifique submódulos desatualizados em relação ao branch remoto e indique a atualização com `git submodule update --remote --merge`.
- **Acesso Defensivo ao Cofre:** Não force operações contra o submódulo `Vault/` em estações sem credenciais SSH autorizadas.
- **Arquitetura Canônica de Comentários:** Inspecione scripts e arquivos de configuração para manter réguas de 64 colunas no topo e 32 colunas nos blocos internos, prevenindo narrativas redundantes e código comentado.

---

## 📋 Checklist de Verificação Proativa

Antes de concluir qualquer ciclo de modificação no ecossistema:

- [ ] **Submódulos:** Todos os componentes apontam para os commits designados de trabalho.
- [ ] **Documentação Canônica:** `ENVIRONMENT.md` e `PRINCIPLES.md` idênticos e atualizados em todos os submódulos.
- [ ] **Orquestração Make:** Alvos `make status`, `make test` e `make audit` executam com sucesso.
- [ ] **Proteção de Segredos:** Diretório `Vault/` adequadamente registrado no `.gitignore`.
- [ ] **Constituições Agentic:** Arquivos `AGENTS.md` presentes e válidos no hub e nos componentes.
- [ ] **Higienização de Comentários:** Ausência de código morto e respeito às réguas estruturais.

---

## 🚀 Ciclo de Entrega e Fechamento

Execute os passos de fechamento rigorosamente nesta sequência:

```sh
git diff --check
git status
make status
```
