# 🤝 Guia de Contribuição — Universal Environment

> Diretrizes de desenvolvimento, setup inicial da bancada, quality gates e padrões de engenharia para o repositório hub do **Quarteto de Produtividade**.

---

## 🚀 Setup Inicial da Bancada (Primeiros Passos)

O **Universal Environment** é o orquestrador global do ecossistema. Para clonar a bancada completa e inicializar os submódulos e ganchos de segurança:

```sh
# 1. Clonar com submódulos recursivos
git clone --recurse-submodules "https://github.com/GabrielFrigo4/environment" "${HOME}/Documents/Environment"
cd "${HOME}/Documents/Environment"

# 2. Inicializar submódulos e configurar ganchos Git em todos os repositórios
make clone

# 3. Validar a sintaxe e integridade do ecossistema
make test

# 4. Executar suíte completa de auditoria estática
make audit
```

> [!IMPORTANT]
> O alvo `make clone` executa automaticamente `make hooks`, que configura `core.hooksPath -> .githooks` e aplica permissões canônicas em todos os repositórios federados. Se já clonou anteriormente, execute `make hooks` manualmente.

---

## 🛡️ Invariantes de Engenharia

Toda contribuição ao ecossistema deve obedecer rigorosamente aos princípios em [PRINCIPLES.md](PRINCIPLES.md) e às regras em [AGENTS.md](AGENTS.md):

1. **Invariante de Clonagem "Out-of-the-Box" (Zero-Tweaks Invariant):**
    - O ecossistema deve funcionar 100% imediatamente após um `git clone`, sem necessidade de intervenções manuais.
    - **Modos Octais no Git Index:** Scripts e ganchos executáveis devem estar registrados com modo `100755`. Arquivos de configuração, documentação e dados devem estar em `100644`.
    - Se cometer um erro de permissão no Git Index, corrija com:
        ```sh
        git update-index --chmod=+x caminho/script.sh    # Para executáveis
        git update-index --chmod=-x caminho/arquivo.md   # Para configs/docs
        ```

2. **Hermetismo de Produção (`rm -rf .agents`):**
    - O código executável de produção (scripts, Makefiles, dotfiles, hooks) NUNCA deve depender de arquivos em `.agents/` ou `skills/`. Se `.agents/` for deletado, 100% do sistema deve continuar operando.

3. **Bancada de Desenvolvimento vs. Runtimes de Produção:**
    - O clone do Environment (`~/Documents/Environment`) é **exclusivamente uma bancada de orquestração**. Nenhum arquivo dentro dele deve ser symlinkado diretamente pelo SO hospedeiro. Para instalar no sistema, use `make install`.

4. **Padrão de Banners & Clean Code:**
    - Cabeçalhos de scripts: exatamente 64 hífens (`# ----------------------------------------------------------------`).
    - Seções internas: exatamente 32 caracteres (`### ================================` ou `### --------------------------------`).
    - Zero comentários narrativos que apenas parafraseiem o código.

---

## 🪝 Quality Gates & Ganchos Git

O repositório utiliza ganchos Git versionados em `.githooks/`:

- **`pre-commit`:** Valida formatação de espaços (`git diff --check`), modos de arquivo no Git Index (0755 vs 0644), status dos submódulos, sintaxe POSIX dos scripts de shell e conformidade Markdown com Prettier.
- **`commit-msg`:** Valida a mensagem de commit conforme a especificação semântica.

Para rodar manualmente toda a bateria de validação local antes de abrir um PR ou enviar commits:

```sh
make ci
```

---

## 📝 Convenção de Commits Semânticos

As mensagens de commit devem seguir o formato:

```text
<tipo>(<escopo>): <descrição objetiva em português ou inglês>
```

### Tipos Permitidos:

| Tipo       | Emoji | Finalidade                                                |
| :--------- | :---: | :-------------------------------------------------------- |
| `feat`     |  ✨   | Nova funcionalidade ou recurso                            |
| `fix`      |  🐛   | Correção de bug ou falha                                  |
| `refactor` |  ♻️   | Refatoração sem alteração de comportamento externo        |
| `docs`     |  📝   | Alterações exclusivamente em documentação                 |
| `style`    |  🎨   | Formatação, Prettier, banners ou estilo visual            |
| `test`     |  🧪   | Adição ou ajuste de testes e auditorias                   |
| `ci`       |  👷   | Ajustes em pipelines GitHub Actions ou ganchos Git locais |
| `chore`    |  🔧   | Manutenção rotineira, Makefiles ou submódulos             |

---

## 📖 Referências Canônicas

- [ENVIRONMENT.md](ENVIRONMENT.md) — Arquitetura federada e ciclo operacional
- [PRINCIPLES.md](PRINCIPLES.md) — Os 22 Princípios de Engenharia UNIX + Clean Code
- [AGENTS.md](AGENTS.md) — Briefing para agentes autônomos de IA
- [TODO.md](TODO.md) — Roadmap estratégico e status do ecossistema
