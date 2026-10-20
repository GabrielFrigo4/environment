# Operações de Submódulos e Documentação Canônica

Procedimentos operacionais para manutenção de submódulos, sincronização de arquivos canônicos e convenções de interface de terminal no hub.

---

## 1. Mapeamento de Responsabilidades do Hub

| Conteúdo                       | Destino Canônico       | Papel no Ecossistema                  |
| :----------------------------- | :--------------------- | :------------------------------------ |
| Makefile global                | Environment            | Orquestração de tarefas nos 8 repos   |
| ENVIRONMENT.md / PRINCIPLES.md | Environment (canônico) | Fonte unificada da verdade            |
| README.md do hub               | Environment            | Documento de apresentação do hub      |
| AGENTS.md do hub               | Environment            | Constituição e diretrizes locais      |
| Provisionamento do SO          | Setup                  | Receitas executáveis de instalação    |
| Scripts e prompts de terminal  | Shell                  | Motor de shells e interatividade      |
| Segredos e chaves              | Vault                  | Cofre criptografado com dados de auth |
| Dotfiles e configurações       | Profile                | Identidade e ferramentas do operador  |
| Editores modais                | Editor/*               | Runtimes de Emacs, Helix, Nvim e Vim  |

---

## 2. Gerenciamento de Submódulos

Atualização de todos os submódulos para o commit mais recente do upstream:

```sh
git submodule update --remote --merge
git add Setup Shell Profile Editor/Emacs Editor/Helix Editor/NeoVim Editor/Vim
git commit -m "update submodules to latest upstream"
```

Inicialização do ambiente de desenvolvimento em novo host:

```sh
git clone --recurse-submodules "[https://github.com/GabrielFrigo4/environment](https://github.com/GabrielFrigo4/environment)" "${HOME}/Documents/Environment"
cd "${HOME}/Documents/Environment"
make clone
make install
```

---

## 3. Propagação de Documentação Canônica

Ao atualizar `ENVIRONMENT.md` ou `PRINCIPLES.md`:

1. Edite o documento na raiz do repositório `Environment`.
2. Propague o conteúdo para todos os submódulos executando `make sync-docs`.
3. Crie os commits e realize o envio (`git push`) em cada repositório individualmente.

---

## 4. Biblioteca Semântica de Terminal (_ui_*)

Scripts e rotinas de status devem emitir saídas formatadas com as funções semânticas padronizadas:

- `_ui_step`: Início de etapa primária (`==>`).
- `_ui_sub`: Subtarefa ou item em validação (`  ↳`).
- `_ui_ok`: Conclusão bem-sucedida de etapa (`  ✅`).
- `_ui_warn`: Alerta preventivo sem interrupção (`  ⚠️`).
- `_ui_err`: Falha crítica direcionada ao stderr (`  ❌`).
- `_ui_info`: Informação contextual relevante (`  ℹ️`).
- `_ui_banner`: Linha de destaque estrutural.
