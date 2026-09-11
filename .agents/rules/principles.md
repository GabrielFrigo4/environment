# Universal Environment — Engineering Rules & Constraints

Essas diretrizes são de aplicação obrigatória para qualquer modificação ou extensão neste repositório (`Environment`).

## 1. Papel do Environment: Hub Orquestrador (Não-Monorepo)

- O Environment é um repositório de **orquestração e documentação**, não de código de produção.
- Os 3 repos públicos (`Setup`, `Shell`, `Profile`) são **Git Submodules** — nunca edite código neles a partir do Environment sem entrar no diretório do sub-repo.
- O `Vault` é um **clone privado** ignorado pelo `.gitignore` — NUNCA o adicione como submodule ou rastreie seu conteúdo.

## 2. Documentação Canônica

- O `ENVIRONMENT.md` e `PRINCIPLES.md` **nesta raiz** são as versões autoritativas do ecossistema.
- Os sub-repos contêm cópias sincronizadas que referenciam estas versões.
- Ao atualizar princípios ou arquitetura, atualize primeiro aqui e propague para os sub-repos.

## 3. Makefile como Orquestrador

- Todas as operações globais (`make clone`, `make pull`, `make status`, `make audit`, `make ci`) são executadas via Makefile.
- O `make clone` inicializa submódulos + clone defensivo do Vault via SSH.
- O `make pull` atualiza submódulos + pull de todos os repos.
- Novos comandos globais devem ser adicionados ao Makefile mantendo o padrão existente.

## 4. Modelo Híbrido de Submódulos

- **Submódulos Públicos (Setup, Shell, Profile):** Rastreados pelo `.gitmodules` via URLs HTTPS públicas.
- **Vault Privado:** Clonado via SSH (`git@github.com:GabrielFrigo4/vault.git`) com tratativa defensiva/tolerante a falhas.
- Ao atualizar submódulos, use `git submodule update --remote --merge`.

## 5. Permissões e Segurança

- `chmod 0644` para arquivos de documentação e configuração do Environment.
- `chmod 0755` para o Makefile.
- NUNCA commite ou mencione conteúdos do Vault no Environment.

## 6. Padrão Universal de Documentação

- **README.md:** Portal institucional com badges do Quarteto, diagrama de arquitetura, tabela de comandos e instruções de instalação.
- **AGENTS.md:** Briefing para agentes de IA com identidade, regras e referências.
- **ENVIRONMENT.md / PRINCIPLES.md:** Documentação canônica do ecossistema.

## 7. Execução pelo Shell Ativo (Active Shell Invocation)

- Funções utilitárias e rotinas interativas no ecossistema devem sempre delegar sub-rotinas para o shell atualmente em execução, seguindo a cascata de preferência: `command -v "$(_detect_shell)" || command -v zsh || command -v bash || command -v sh`.
- Isso previne falhas no `dash` (Debian/Ubuntu) e assegura que os nomes canônicos em `kebab-case` (`reinstall-shell`, `update-editors`, etc.) rodem no shell compatível (`zsh`, `bash` ou FreeBSD `/bin/sh` como fallback).

## 8. Checklist de Validação

Antes de concluir qualquer modificação no Environment:

1. `git diff --check` (deve retornar 0 erros).
2. `git status` (deve mostrar apenas arquivos do hub, nada dos sub-repos).
3. `make status` (deve funcionar em todos os repos).
