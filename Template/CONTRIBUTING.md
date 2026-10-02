# 🤝 Guia de Contribuição

Diretrizes de desenvolvimento, setup inicial, quality gates e convenções para o repositório **{{PROJECT_NAME}}**.

---

## 🚀 Setup Inicial

Para clonar e configurar os ganchos Git defensivos do repositório:

```sh
# 1. Clonar o repositório
git clone "https://github.com/{{ORGANIZATION}}/{{PROJECT_NAME}}"
cd "{{PROJECT_NAME}}"

# 2. Configurar ganchos Git com permissões canônicas (0755)
make hooks

# 3. Validar a integridade local do projeto
make ci
```

---

## 🛡️ Invariantes de Engenharia

Toda contribuição deve respeitar rigorosamente as diretrizes em [PRINCIPLES.md](PRINCIPLES.md) e [AGENTS.md](AGENTS.md):

1. **Invariante de Modos no Git Index (0755 vs 0644):**
    - Scripts de automação e ganchos Git executáveis devem estar registrados com permissão `100755`.
    - Códigos-fonte, manifestos, arquivos de configuração e documentações Markdown devem estar em `100644`.
    - Para ajustar permissões no índice do Git:
        ```sh
        git update-index --chmod=+x scripts/util.sh
        git update-index --chmod=-x README.md
        ```

2. **Hermetismo de Produção (`rm -rf .agents`):**
    - Nenhum build ou execução em produção deve depender de arquivos em `.agents/` ou `.githooks/`.

3. **Arquitetura de Banners e Clean Code:**
    - Header banner: 64 hífens (`# ----------------------------------------------------------------`).
    - Seções estruturais: régua de 32 caracteres (`### ================================`).
    - Código autoexplicativo sem comentários narrativos.

---

## 🪝 Quality Gates & Ganchos Git

O projeto inclui validações automáticas em `.githooks/`:

- **`pre-commit`:** Valida formatação de whitespace (`git diff --check`), integridade de modos no Git Index, sintaxe POSIX de scripts de shell e conformidade Markdown com Prettier.
- **`commit-msg`:** Valida conformidade com a convenção de commits semânticos.

Para rodar manualmente todas as verificações antes de abrir um PR ou enviar alterações:

```sh
make ci
```

---

## 📝 Convenção de Commits Semânticos

As mensagens de commit devem seguir o padrão:

```text
<tipo>(<escopo>): <descrição objetiva>
```

ou

```text
<tipo>: <descrição objetiva>
```

### Tipos Permitidos:

| Tipo       | Descrição                                                    |
| :--------- | :----------------------------------------------------------- |
| `add`      | Adição de novo arquivo, módulo ou recurso                    |
| `feat`     | Nova funcionalidade de produto ou sistema                    |
| `fix`      | Correção de bug ou falha de execução                         |
| `refactor` | Refatoração de código sem alteração de comportamento externo |
| `docs`     | Alterações estritamente em documentação                      |
| `style`    | Ajustes visuais, formatação de código ou Prettier            |
| `test`     | Adição ou refatoração de testes automatizados                |
| `ci`       | Ajustes em ganchos Git locais ou pipelines de CI             |
| `chore`    | Tarefas rotineiras de manutenção, Makefile ou dependências   |
| `update`   | Atualização de componentes, dados ou configurações           |

---

## 📖 Referências Obrigatórias

- [README.md](README.md) — Documentação e visão geral
- [PRINCIPLES.md](PRINCIPLES.md) — Os 22 Princípios Soberanos de Engenharia
- [AGENTS.md](AGENTS.md) — Constituição para agentes autônomos de IA
- [TODO.md](TODO.md) — Roadmap de desenvolvimento
