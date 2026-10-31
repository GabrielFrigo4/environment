# 🤖 Universal Template — AI Agent Briefing

> Arquétipo canônico e scaffold para novos repositórios do ecossistema, definindo governança soberana, automação POSIX silenciosa e quality gates locais.

---

## 🧭 Identidade e Papel

O **Template** é o modelo de referência para criação de novos componentes e projetos no ecossistema de Gabriel Frigo. Fornece estrutura pré-configurada de automação, documentação e auditoria:

- **Stack Primária:** POSIX Shell, Makefiles portáteis (compatíveis com BSD `bmake` e GNU `gmake`), Prettier e scripts de auditoria
- **Filosofia:** Minimalismo, determinismo, zero ruído, alta performance e soberania técnica

### 📁 Estrutura Canônica de Arquivos

```text
.
├── .agents/
│   └── rules/
│       ├── clean-code.md
│       └── principles.md
├── .githooks/
│   ├── commit-msg
│   └── pre-commit
├── .github/
│   └── workflows/
│       └── ci.yml
├── .gitattributes
├── .gitignore
├── .prettierrc
├── AGENTS.md
├── CONTRIBUTING.md
├── ENVIRONMENT.md
├── Makefile
├── PRINCIPLES.md
├── README.md
├── TODO.md
└── VERSION
```

---

## ⚠️ Regras Críticas para Agentes de IA

1. **A Regra de Ouro:** Ao iniciar qualquer sessão ou tarefa, o agente deve ler `AGENTS.md`, `PRINCIPLES.md` e os arquivos em `.agents/rules/` antes de realizar qualquer alteração no código.
2. **Taxonomia Tripartite de Comentários:** O código adota estritamente três categorias: 1. Comentários de Sistema = PERMITIDOS (shebangs, pragmas, linters); 2. Comentários Estruturais de 64/32 colunas = PERMITIDOS (cabeçalhos de 64 `-`, seções de 32 caracteres `### ===`, réguas de 64 `=` em `.gitignore`, sem vazamento); 3. Comentários Explicativos/Narrativos = PROIBIDOS em código, configs E blocos de código dentro de Markdowns.
3. **Hierarquia de Banners Estruturais:** Permitidos exclusivamente delimitadores estruturais de arquitetura: cabeçalhos com 64 hífens (`# ----------------------------------------------------------------`), seções com 32 caracteres (`### ================================` ou `### --------------------------------`), e seções com 64 sinais de igualdade em `.gitignore` (`# ================================================================`).
4. **Hermetismo de Produção & Invariante `rm -rf .agents`:** Repositório 100% autônomo. Zero acoplamento de código de produção, automação ou testes a `.agents/` ou `.githooks/` (o sistema opera plenamente se `.agents/` for deletado).
5. **Bancada de Desenvolvimento vs. Runtimes de Produção:** NUNCA aponte symlinks ou diretórios de runtime para a bancada de desenvolvimento. Componentes operam soberanamente em seus destinos canônicos.
6. **Ciclo Canônico de Propagação & Banimento de Cópia Manual:** Toda alteração é testada na bancada (`make test`, `make ci`), comitada e enviada via Git. Clones de produção recebem atualizações exclusivamente via `git pull` mantendo a working tree limpa (Invariante Zero-Dirty).
7. **Modos Canônicos no Git Index:** `0755` para scripts executáveis e ganchos (`.githooks/*`), e `0644` para fontes, documentações e manifestos.
8. **Invariante de Clonagem "Out-of-the-Box" (Zero-Tweaks Git Invariant):** O repositório deve funcionar imediatamente após um simples `git clone`, com modos octais canônicos mantidos no Git Index e rotinas de auto-cura em tempo de execução sem requerer etapas manuais pós-clone.
9. **Padrão Universal de Emissão de UI (`_ui_*`):** Toda saída interativa de status ou etapas deve utilizar a taxonomia semântica `_ui_*` (`_ui_step`, `_ui_sub`, `_ui_ok`, `_ui_warn`, `_ui_err`, `_ui_info`, `_ui_banner`), sendo proibido `echo` avulso com emojis soltos.
10. **Commits Semânticos:** Mensagens de commit devem seguir o padrão `<tipo>(<escopo>): <descrição>` ou `<tipo>: <descrição>` com os tipos permitidos (`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`).
11. **Matriz de Shells Suportada:** Automação e scripts de shell visam `zsh`, `bash`, FreeBSD `sh` e OpenBSD `ksh`. Shells ultra-restritos de recuperação (Debian `dash`, NetBSD `sh`) estão fora de escopo.
12. **Governança de Roadmap (TODO.md):** O repositório mantém seu [TODO.md](TODO.md) canônico atualizado com a matriz de status operacional e backlog de evolução.
13. **Refatoração Sem Legado (Clean-Break / Zero-Cruft Invariant):** O ecossistema é monousuário soberano. Não mantenha shims temporários, wrappers obsoletos ou aliases de transição ao renomear variáveis, comandos ou caminhos. Toda refatoração deve ser direta, atômica e limpa (_clean break_).
14. **Ambiente Híbrido Host/Guest (FreeBSD Workstation + Bhyve Linux Runtime):** Em estações FreeBSD, o agente de IA (`agy`) opera isolado dentro de uma máquina virtual Debian no Bhyve (`192.168.8.2`), conectada via NFSv3 à `/home/gabrielf` do host com paridade de UID/GID 1001. O agente executa comandos em ambiente Linux nativo (kernel 6.12/GNU), porém seus arquivos de trabalho residem fisicamente no ZFS do FreeBSD. Ao despachar comandos no terminal, utilize ferramentas Linux disponíveis no guest ou faça a demarcação correta ao editar scripts específicos de cada sistema operacional.
15. **Simetria de Escopo & Não-Assimetria de Subgrupo na Documentação:** Se um comportamento, protocolo ou invariante pertence a todo um grupo de componentes, documente-o no nível do grupo (documento de arquitetura, README do módulo pai ou especificação geral), evitando a criação de falsas assimetrias. Um sub-membro só deve receber documentação específica se implementar o comportamento de forma mais especializada, detalhada ou otimizada.

---

## 🛡️ Regra da Proatividade e Correção Contínua (Boy Scout Rule)

O agente de IA atua de forma proativa na manutenção e aplicação dos padrões canônicos deste repositório.

Ao identificar linhas ou artefatos fora dos padrões estabelecidos:

1. **Notificar concisamente** o usuário sobre o ajuste realizado.
2. **Corrigir a inconformidade**, aplicando o padrão correspondente:
    - **Taxonomia Tripartite de Comentários:** Eliminar comentários explicativos óbvios em código, configs e blocos de código em Markdowns, preservando exclusivamente comentários de sistema e delimitadores estruturais (64/32 colunas).
    - **Banners Estruturais:** Ajustar réguas para exatamente 64 hífens no topo ou 32 caracteres com `### ` no corpo (ou 64 `=` em `.gitignore`).
    - **Portabilidade POSIX:** Substituir bashismos (`[[ ]]`, `&>`, arrays, `source`) por sintaxe estrita POSIX `/bin/sh`.
    - **Shebang Universal:** Garantir sempre `#!/usr/bin/env sh` ou `#!/usr/bin/env python3`.
    - **Sequências ANSI & Escapes:** Não use octais (`\033`, `\001`) para caracteres ou escapes. Use `[ -t 1 ] && echo -n $'\e...'` ou notação hexadecimal (`\x01`, `\x1b`). Octal é exclusivo para permissões POSIX (`chmod 0755`, `chmod 0644`, `umask`).
    - **Redirecionamento Seguro:** Envolver destinos em aspas duplas (ex: `> "/dev/null" 2>&1`).
    - **Makefiles:** Assegurar cabeçalho `.POSIX: .SILENT:`, `MAKEFLAGS += --no-print-directory -s`, alinhamento estético de variáveis e zero `@` redundante.
    - **Permissões Canônicas:** Aplicar 4 dígitos octais (`chmod 0755`, `chmod 0644`, `chmod 0700`, `chmod 0600`).
    - **Invariante Out-of-the-Box:** Garantir modos octais corretos no Git Index e auto-cura em tempo de execução sem requerer intervenção manual pós-clone.
    - **Emissão Semântica de UI:** Substituir `echo` avulsos com emojis pelas rotinas canônicas `_ui_*`.
    - **Antifragilidade & Resiliência:** Resolução ativa de caminhos em cascata, auto-cura de permissões (0600 em chaves/segredos) e validação defensiva de pré-requisitos.
    - **Curadoria Cognitiva:** Capturar decisões estruturais e regras tácitas em skills locais compactas (`.agents/skills/`), mantendo-as atualizadas e expurgando ruído obsoleto.
    - **Refatoração Sem Legado:** Expurgar aliases obsoletos, variáveis mortas e shims de compatibilidade em renomeações.
    - **Elevação Antifrágil & Shift Seguro:** Usar o bloco explícito `if [ "$(id -u)" -ne 0 ]` para resolução de `ELEVATE` (evitando término fatal sob `set -e` como root) e proteger todo comando `shift` com validação prévia de parâmetros (`[ "$#" -ge N ] && shift N`).
    - **Simetria de Documentação:** Mover regras ou invariantes universais documentadas erroneamente em sub-membros específicos para o documento de arquitetura do grupo correspondente, eliminando falsas assimetrias.

---

## 🚀 Comandos de Verificação Rápida (Quality Gates)

| Comando         | Finalidade Operacional                                             |
| :-------------- | :----------------------------------------------------------------- |
| `make help`     | Exibe o catálogo interativo de comandos disponíveis                |
| `make check`    | Executa validação estática de tipos e sintaxe                      |
| `make test`     | Executa a suíte automatizada de testes locais                      |
| `make audit`    | Executa as suítes de auditoria estática de padrões e integridade   |
| `make format`   | Formata código-fonte e documentações com Prettier e linters        |
| `make prettier` | Formata arquivos Markdown e configurações com Prettier             |
| `make hooks`    | Configura e aplica permissão `0755` nos ganchos de `.githooks/`    |
| `make ci`       | Executa a pipeline local completa de validação (`check test lint`) |
| `make clean`    | Remove artefatos de compilação, diretórios temporários e caches    |

---

## 📖 Referências Obrigatórias

Antes de qualquer modificação neste ecossistema, consulte:

- [README.md](README.md) — Documentação e visão geral do projeto
- [PRINCIPLES.md](PRINCIPLES.md) — Os 22 Princípios de Engenharia Soberanos
- [ENVIRONMENT.md](ENVIRONMENT.md) — Arquitetura federada do ecossistema
- [CONTRIBUTING.md](CONTRIBUTING.md) — Guia de contribuição e convenções
- [TODO.md](TODO.md) — Roadmap de tarefas e status operacional
- [.agents/rules/clean-code.md](.agents/rules/clean-code.md) — Regra de Clean Code
- [.agents/rules/principles.md](.agents/rules/principles.md) — Regra de Princípios
