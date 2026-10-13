# ⚖️ Paridade POSIX/GNU, Identidade & XDG

> Diretrizes canônicas para alinhamento de UID/GID, governança de diretórios XDG e harmonização de utilitários entre sistemas BSD e GNU/Linux.

---

## 🧭 O Desafio da Identidade Multi-SO: Paridade UID/GID 1001

Em ambientes heterogêneos onde arquivos são compartilhados entre nós via NFS ou replicação de storage, o sistema de arquivos não registra nomes de usuários textuais (como `gabrielf`), mas sim identificadores numéricos primitivos de 32 bits (**UID - User ID** e **GID - Group ID**).

- No **FreeBSD**, o primeiro usuário comum criado pelo instalador tradicionalmente recebe `UID=1001` e `GID=1001`.
- No **Debian/Ubuntu**, o usuário padrão frequentemente recebia `UID=1000`.

Se um arquivo for criado no Linux com `UID 1000` sobre um diretório compartilhado NFS com o FreeBSD, o host FreeBSD enxergará o arquivo como pertencente a outro usuário ou a uma conta não mapeada, gerando falhas de permissão (`Permission denied`).

### Regra de Ouro da Paridade:

No Universal Environment, **todos os ambientes Linux (guests Bhyve e bare-metal) devem registrar o desenvolvedor sob `UID=1001` e `GID=1001`**:

```sh
# Comando canônico de provisionamento de usuário no Debian/Linux:
sudo groupadd -g 1001 gabrielf 2>/dev/null || true
sudo useradd -u 1001 -g 1001 -m -s /bin/bash gabrielf
```

---

## 📂 Conformidade com o XDG Base Directory Specification

Para evitar que a pasta `$HOME` se torne um repositório caótico de arquivos ocultos (`.vim`, `.bashrc`, `.cache`, etc.), tanto os perfis Linux quanto BSD aderem estritamente à especificação XDG:

| Variável de Ambiente | Caminho Padrão   | Finalidade Canônica                                                         |
| :------------------- | :--------------- | :-------------------------------------------------------------------------- |
| `XDG_CONFIG_HOME`    | `~/.config`      | Arquivos de configuração declarativos dos programas.                        |
| `XDG_DATA_HOME`      | `~/.local/share` | Dados persistentes do usuário, repositórios soberanos (`shell/`, `vault/`). |
| `XDG_STATE_HOME`     | `~/.local/state` | Histórico de shell, logs e estado dinâmico de editores.                     |
| `XDG_CACHE_HOME`     | `~/.cache`       | Dados efêmeros e caches descartáveis de compiladores e formatters.          |

---

## ⚔️ Harmonização de Divergências: BSD vs. GNU Coreutils

Ferramentas padrão do sistema apresentam pequenas divergências sintáticas entre o ecossistema BSD e o GNU/Linux. Todo código escrito no ecossistema deve ser antifrágil contra essas variações:

### 1. Edição em Linha (`sed -i`):

- **BSD `sed`:** Exige extensão explícita (mesmo que vazia): `sed -i '' -e 's/.../.../' arquivo`.
- **GNU `sed`:** Não aceita string vazia como argumento separado: `sed -i 's/.../.../' arquivo` ou `sed -i'' '...' arquivo`.
- **Padrão Canônico do Ecossistema:** Preferir utilitários Python (`replace_file_content` / scripts `.py`) ou usar a sintaxe compatível com ambos: `sed -i.bak ... && rm -f ...bak`, ou verificar o sistema via `uname -s`.

### 2. Leitura de Permissões Octais (`stat`):

- **BSD `stat`:** `stat -f %Lp arquivo` (retorna permissão octal pura, como `755`).
- **GNU `stat`:** `stat -c %a arquivo`.
- **Padrão Canônico:** O ecossistema padroniza a auditoria de permissões em Python nativo (`os.stat(p).st_mode & 0o7777`), eliminando bifurcações frágeis de subshell.

### 3. Timestamp de Arquivos (`date`):

- **BSD `date`:** `date -r <timestamp>` ou `date -r <arquivo>`.
- **GNU `date`:** `date -d @<timestamp>` ou `date -r <arquivo>`.
