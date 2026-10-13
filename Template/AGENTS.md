# 🤖 AGENTS.md — Diretrizes para Agentes de IA

Bem-vindo ao repositório **{{PROJECT_NAME}}**. Este documento constitui a constituição primária e instrução mandatória para qualquer agente autônomo de Inteligência Artificial operando nesta base de código.

---

## 1. Identidade e Papel

O **{{PROJECT_NAME}}** é {{PROJECT_DESCRIPTION}}.

- **Stack Primária:** {{PROJECT_STACK}}
- **Filosofia:** Minimalismo, determinismo, zero ruído, alta performance e soberania técnica.

---

## 2. Regras Críticas Soberanas

1. **A Regra de Ouro:** Ao iniciar qualquer sessão ou tarefa, o agente deve ler `AGENTS.md`, `PRINCIPLES.md` e os arquivos em `.agents/rules/` antes de realizar qualquer alteração no código.
2. **Zero Comentários Narrativos:** Não insira comentários explicando o que o código faz ou parafraseando lógica óbvia. Utilize código expressivo, autoevidente e funções puras coesas.
3. **Hierarquia de Banners em Três Camadas:** Permitidos exclusivamente comentários estruturais de arquitetura: cabeçalhos com 64 hífens (`# ----------------------------------------------------------------`) e seções com 32 caracteres (`### ================================`).
4. **Hermetismo de Produção (`rm -rf .agents`):** Nenhuma rotina de build, teste ou execução em produção pode acoplar-se a `.agents/` ou `.githooks/`.
5. **Modos Canônicos no Git Index:** `0755` para scripts executáveis e ganchos (`.githooks/*`), e `0644` para fontes, documentações e manifestos.
6. **Commits Semânticos:** Mensagens de commit devem seguir o padrão `<tipo>(<escopo>): <descrição>` ou `<tipo>: <descrição>` com os tipos permitidos.
7. **Escapes ANSI & Banimento de Octal:** Não utilize escapes octais (`\033`, `\001`) para cores ANSI ou caracteres de controle. Use sempre `$'\e'` (em Makefiles: `_e=$$'\e';`) ou hexadecimal (`\x1b`). Notação octal é reservada para permissões de sistema de arquivos POSIX (`chmod 0755`, `0644`, `0700`, `0600`, `umask 022`).
8. **Matriz de Shells Suportada:** Automação e scripts de shell visam `zsh`, `bash`, FreeBSD `sh` e OpenBSD `ksh`. Shells ultra-restritos de recuperação (Debian `dash`, NetBSD `sh`) estão fora de escopo.
9. **Invariante de Clonagem "Out-of-the-Box" (Zero-Tweaks Git Invariant):** O repositório deve funcionar imediatamente após um simples `git clone`, com modos octais canônicos mantidos no Git Index e rotinas de auto-cura em tempo de execução sem requerer etapas manuais pós-clone.
10. **Padrão Universal de Emissão de UI (`_ui_*`):** Toda saída interativa de status ou etapas deve utilizar a taxonomia semântica `_ui_*` (`_ui_step`, `_ui_sub`, `_ui_ok`, `_ui_warn`, `_ui_err`, `_ui_info`, `_ui_banner`), sendo proibido `echo` avulso com emojis soltos.
11. **Governança de Roadmap (TODO.md):** O repositório mantém seu `TODO.md` canônico atualizado com a matriz de status operacional e backlog de evolução.
12. **Refatoração Sem Legado (Clean-Break / Zero-Cruft Invariant):** O ecossistema é monousuário soberano. Não mantenha shims temporários, wrappers obsoletos ou aliases de transição ao renomear variáveis, comandos ou caminhos. Toda refatoração deve ser direta, atômica e limpa (_clean break_).
13. **Ambiente Híbrido Host/Guest (FreeBSD Workstation + Bhyve Linux Runtime):** Em estações FreeBSD, o agente de IA (`agy`) opera isolado dentro de uma máquina virtual Debian no Bhyve (`192.168.8.2`), conectada via NFSv3 à `/home/gabrielf` do host com paridade de UID/GID 1001. O agente executa comandos em ambiente Linux nativo (kernel 6.12/GNU), porém seus arquivos de trabalho residem fisicamente no ZFS do FreeBSD. Ao despachar comandos no terminal, utilize ferramentas Linux disponíveis no guest ou faça a demarcação correta ao editar scripts específicos de cada sistema operacional.

---

## 3. Regra do Escoteiro (Boy Scout Rule)

Sempre deixe o acampamento mais limpo e organizado do que você o encontrou:

- [ ] Elimine comentários narrativos redundantes ou desatualizados.
- [ ] Remova espaços em branco residuais no final de linhas.
- [ ] Formate código e documentações com `make format`.
- [ ] Execute a suíte de validação com `make ci` antes de concluir a tarefa.

---

## 4. Estrutura do Repositório

```text
.
├── .agents/
│   └── rules/
│       ├── clean-code.md      # Diretrizes de clean code e arquitetura de comentários
│       └── principles.md      # Os 22 princípios soberanos de engenharia
├── .githooks/
│   ├── commit-msg             # Validador de commits semânticos
│   └── pre-commit             # Quality gate local (whitespace, syntax, prettier)
├── .github/
│   └── workflows/
│       └── ci.yml             # Pipeline de integração contínua GitHub Actions
├── .gitattributes             # Normalização de finais de linha (LF)
├── .gitignore                 # Filtro de artefatos de build e temporários
├── .prettierrc                # Configuração unificada de formatação Markdown/JSON
├── AGENTS.md                  # Constituição e briefing para agentes de IA
├── CONTRIBUTING.md            # Guia de desenvolvimento e convenções locais
├── Makefile                   # Orquestrador POSIX silencioso compatível com bmake/gmake
├── PRINCIPLES.md              # 22 Princípios de Engenharia UNIX & Soberania
├── README.md                  # Portal institucional reader-first
├── TODO.md                    # Roadmap de tarefas e itens em aberto
└── VERSION                    # Versão semântica canônica do projeto
```

---

## 5. Comandos de Verificação Rápida

| Comando         | Finalidade Operacional                                             |
| :-------------- | :----------------------------------------------------------------- |
| `make help`     | Exibe o catálogo interativo de comandos disponíveis                |
| `make build`    | Compila os artefatos de produção em `bin/` ou `dist/`              |
| `make dev`      | Compila e executa o projeto em modo interativo/desenvolvimento     |
| `make check`    | Executa validação estática de tipos e sintaxe                      |
| `make test`     | Executa a suíte automatizada de testes locais                      |
| `make format`   | Formata código-fonte e documentações com formatadores canônicos    |
| `make prettier` | Formata arquivos Markdown e configurações com Prettier             |
| `make lint`     | Valida padrões de código e documentação sem modificar arquivos     |
| `make hooks`    | Configura e aplica permissão `0755` nos ganchos de `.githooks/`    |
| `make ci`       | Executa a pipeline local completa de validação (`check test lint`) |
| `make clean`    | Remove artefatos de compilação, diretórios temporários e caches    |

---

## 6. Referências Obrigatórias

- [README.md](README.md) — Documentação e visão geral do projeto
- [PRINCIPLES.md](PRINCIPLES.md) — Os 22 Princípios de Engenharia Soberanos
- [CONTRIBUTING.md](CONTRIBUTING.md) — Guia de contribuição e convenções
- [.agents/rules/clean-code.md](.agents/rules/clean-code.md) — Regra de Clean Code
- [.agents/rules/principles.md](.agents/rules/principles.md) — Regra de Princípios
