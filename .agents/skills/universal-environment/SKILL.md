---
name: universal-environment
description: >-
    Runbook cognitivo para governança e orquestração do hub Universal Environment.
    Usar ao gerenciar submódulos, orquestrar operações via Makefile, propagar
    documentos canônicos e garantir paridade nos componentes do ecossistema.
---

# 🌐 Universal Environment — Orquestrador do Ecossistema

Este guia define os modelos de governança, o isolamento entre bancada e produção e o fluxo operacional do repositório **Universal Environment** (hub orquestrador de todos os componentes soberanos).

---

## 🏛️ Bancada de Desenvolvimento vs. Runtimes de Produção

O repositório `Environment` (`~/Documents/Environment`) funciona **estritamente como bancada de desenvolvimento e orquestração**:

1. **Isolamento de Produção:** Nenhum script ou configuração deste diretório deve ser consumido diretamente pelo sistema operacional.
2. **Vedação de Symlinks para o Hub:** É proibido criar links simbólicos a partir de configurações do sistema apontando para o interior do repositório hub.
3. **Provisionamento Canônico:** A instalação é realizada via `make install` (ou `./environment.sh install`), que provisiona cada repositório em suas localizações formais (`~/.local/share/shell`, `~/.config/profile`, `~/.vault`, `~/.emacs.d`, etc).
4. **Ciclo Sagrado de Propagação:**
    - Edições são realizadas exclusivamente na bancada, validadas via `make test` e `make audit`, e enviadas ao Git upstream.
    - Runtimes de produção atualizam-se unicamente via `git pull` (ou rotinas de ciclo como `upsh`).
    - **Proibição de Cópia Manual:** É expressamente vedado utilizar `cp` ou `rsync` da bancada para os diretórios de runtime no sistema, prevenindo árvores de trabalho em estado sujo (`dirty`).

---

## 🗂️ Roteador Modular de Operações

Consulte os manuais técnicos especializados em `references/`:

- [references/operations.md](references/operations.md): Matriz de responsabilidade dos 8 componentes, ciclo de vida de submódulos Git, sincronização de `ENVIRONMENT.md`/`PRINCIPLES.md` e biblioteca semântica de terminal `_ui_*`.
- [references/runtime-hybrid.md](references/runtime-hybrid.md): Arquitetura de contenção FreeBSD (Host) + Bhyve Debian (Guest) com exportação NFS e wrappers transparentes de shell.

---

## 📐 Invariantes de Engenharia e Roadmap

- **Modularização Atômica:** Scripts do componente `Setup` são idempotentes e escritos em POSIX `/bin/sh`.
- **Sensibilidade de Display:** Editores inspecionam capacidades gráficas e de aceleração em voo com degradação graciosa.
- **Paridade Multiplataforma:** Perfis de shell e terminal preservam equivalência entre UNIX e Windows.
- **Instalação Out-of-the-Box:** Zero intervenções manuais de permissões pós-clonagem.

---

## 🚀 Quality Gates de Validação

Antes de concluir qualquer ciclo de modificação no repositório:

```sh
git diff --check
git status
make status
make test
make audit
```
