# 🤖 Agent 4: Blindagem, Auditoria & Ferramentas do Universal Vault

> **Plano Operacional Especializado — Segurança e Tooling do Vault**
> ⚡ **Execução:** Autônomo (**Gemini Flash 3.x** / Pro)
> **Referência Obrigatória Prévia:** Leia atentamente o [`all_agents.md`](all_agents.md).

---

## 🎯 1. Objetivo Central da Missão

Implementar utilitários avançados de segurança, auditoria contínua, backups criptografados e novos loaders no repositório **Universal Vault** (`~/Documents/Environment/Vault`), elevando a resiliência operacional do cofre criptográfico sem comprometer o sigilo de dados.

---

## 🗺️ 2. Topografia de Arquivos a Explorar

1. **Repositório do Cofre Privado (`Vault/`):**
    - [`Vault/vault.sh`](file:///home/gabrielf/Documents/Environment/Vault/vault.sh): Entrypoint conciso (42 linhas).
    - [`Vault/core/perms.sh`](file:///home/gabrielf/Documents/Environment/Vault/core/perms.sh): Auto-cura e checagem de permissões `0700` e `0600`.
    - [`Vault/core/env.sh`](file:///home/gabrielf/Documents/Environment/Vault/core/env.sh): Injetor atômico de variáveis sensíveis em shells.
    - [`Vault/core/ui.sh`](file:///home/gabrielf/Documents/Environment/Vault/core/ui.sh): Emissão de UI semântica.
    - `Vault/keys/`: Chaves SSH e pares criptográficos.
    - `Vault/servers/`: Arquivos de hosts e configurações `.env`.
    - `Vault/TODO.md`: Backlog oficial do repositório.

---

## 📋 3. Roteiro Metódico de Execução (Passo a Passo)

### Fase 1: Script de Auditoria Canônica (`audit-vault.sh`)

- [x] Criar a rotina de auditoria em `Vault/core/audit.sh` (com atalho via `vault.sh --audit` ou script autônomo):
    - Verificar e reportar recursivamente se há diretórios fora de `0700` ou arquivos fora de `0600`.
    - Detectar chaves privadas sem chave pública correspondente (`.pub`) ou chaves públicas órfãs.
    - Verificar a integridade do `.gitignore` para garantir que nenhum arquivo temporário ou descriptografado escape ao versionamento.
    - Testar a entropia básica de chaves privadas e integridade de formato OpenSSH/PKCS8.
    - Utilizar a biblioteca `_ui_*` para emitir sumário claro de conformidade.

### Fase 2: Suporte a Criptografia com `age`

- [x] Implementar rotinas para suporte ao utilitário moderno [age](https://github.com/FiloSottile/age):
    - Suporte a encriptar/decriptar arquivos sensíveis com chave de identidade `age` ou senha protegida por scrypt.
    - Manter compatibilidade com `git-crypt` existente.

### Fase 3: Comando de Backup Seguro (`vault-backup`)

- [x] Implementar comando `vault-backup` que:
    - Gera tarball comprimido em memória dos segredos e chaves.
    - Encripta o bundle diretamente via `age` (ou GPG) para um arquivo de destino seguro (`vault-backup-$(date +%Y%m%d).tar.gz.age`).
    - Auto-limpa arquivos temporários em memória/ramfs sem deixar rastros em disco.

### Fase 4: Templates Declarativos `.env`

- [x] Adicionar templates seguros (`example.env` ou `template.env`) nas subpastas pertinentes de servidores e serviços, permitindo que novos ambientes saibam exatamente quais chaves preencher.

### Fase 5: Loader Nativo para Fish Shell (`vault.fish`)

- [x] Criar o injetor de variáveis `vault.fish` para ambientes que utilizam Fish Shell, garantindo leitura atômica e silenciamento de erros idênticos ao Bash/Zsh.

### Fase 6: Quality Gates e Validação

- [x] Validar sintaxe POSIX via `sh -n` em todos os scripts do Vault.
- [x] Assegurar limite de ≤ 256 linhas por arquivo.

---

## ⚠️ 4. Invariantes Críticas & Gotchas

1. **VAULT É ESTRITAMENTE PRIVADO:** NUNCA mencione chaves reais, hashes privados, tokens ou dados pessoais em mensagens de commit ou documentações públicas.
2. **Auto-Cura Obrigatória:** O Vault deve continuar corrigindo automaticamente permissões frouxas para `0700` e `0600` ao ser invocado.
3. **Multiplataforma:** No Windows, o script de permissões deve preservar o uso do `icacls` restritivo.
