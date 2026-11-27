# 🔐 Segurança de Chaves SSH, Pageant & ACLs no Windows

> Governança criptográfica no Windows: conversão de chaves PuTTY `.ppk`, agentes SSH Pageant e endurecimento de permissões NTFS via `icacls`.

---

## 🧭 O Desafio da Segurança de Chaves no Windows

No ecossistema UNIX, permissões octais POSIX como `chmod 0600 chave_id_ed25519` garantem categoricamente que apenas o proprietário do arquivo consiga ler os segredos.

No Windows, o sistema de arquivos NTFS utiliza **Listas de Controle de Acesso (ACLs - Access Control Lists)** herdadas hierarquicamente dos diretórios pais (`C:\Users`, etc.). Se não forem explicitamente endurecidas:

- Contas de serviço do sistema (`SYSTEM`) têm leitura irrestrita.
- Grupos genéricos de usuários locais (`BUILTIN\Users`) podem ter acesso de leitura.
- O utilitário OpenSSH do Windows abortará a conexão com a mensagem fatal:
  `Permissions for 'id_ed25519' are too open. It is required that your private key files are NOT accessible by others.`

---

## 🛡️ Endurecimento de Permissões NTFS via `icacls`

O utilitário `vault-perms` do ecossistema provê implementação nativa para Windows (em PowerShell e Bash/MSYS2) que purga heranças e restringe o Vault exclusivamente ao usuário conectado:

### Comando Canônico de Endurecimento:

Quebra heranças de ACL, concede acesso exclusivo ao usuário atual e remove grupos genéricos (`Authenticated Users` e `BUILTIN\Users`):

```powershell
$VaultPath = "$HOME\.local\share\vault"

icacls $VaultPath /inheritance:r
icacls $VaultPath /grant:r "${env:USERNAME}:(OI)(CI)F"
icacls $VaultPath /remove:g "Authenticated Users" 2>$null
icacls $VaultPath /remove:g "BUILTIN\Users" 2>$null
```

---

## 🔑 Conversão de Chaves & Agente Pageant

Diferente de sistemas UNIX (onde o formato OpenSSH puro reina universalmente), ferramentas legadas ou gráficas no Windows frequentemente adotam a suíte **PuTTY** e seu formato de chave **`.ppk` (PuTTY Private Key)**.

### Conversão Automatizada via `puttygen`:

Para gerar a versão `.ppk` a partir da chave privada OpenSSH:

```sh
puttygen ~/.local/share/vault/ssh/id_ed25519 -O private -o ~/.local/share/vault/ssh/id_ed25519.ppk
```

### Inicialização do Pageant:

O agente **Pageant (PuTTY Authentication Agent)** armazena as chaves descriptografadas na memória RAM do Windows:

- Chaves são carregadas uma única vez na inicialização da estação.
- Clientes PuTTY, TortoiseGit, FileZilla e emuladores de terminal autenticam instantaneamente sem requerer digitação repetida de passphrases.

---

## 🌉 A Ponte Pageant $\longleftrightarrow$ Windows OpenSSH

Para permitir que o binário nativo `ssh.exe` do Windows utilize as chaves residentes na memória do Pageant, exporta-se a variável `SSH_AUTH_SOCK` apontando para o pipe nomeado do agente (`wsl-ssh-pageant` ou ponte do Git for Windows):

```powershell
$env:SSH_AUTH_SOCK = "\\.\pipe\ssh-pageant"
```

Dessa forma, tanto ferramentas baseadas em PuTTY quanto clientes OpenSSH nativos consomem o mesmo cofre seguro de chaves na memória, eliminando cópias redundantes de segredos no disco.
