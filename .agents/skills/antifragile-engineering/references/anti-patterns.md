# Catálogo de Anti-Padrões de Fragilidade

Exemplos contrastivos de implementações frágeis e suas mitigações antifrágeis canônicas.

---

## Anti-Padrão 1: Caminhos Rígidos Hardcoded

Implementação Frágil:

```sh
KEY="${HOME}/.vault/keys/server.key"
ssh -i "${KEY}" user@host
```

Falha: Interrompe a execução caso o cofre resida em caminhos compatíveis com XDG ou se o repositório for clonado em outra conta.

Correção Canônica:

```sh
_resolve_vault_key() {
	_explicit="${1:-}"
	_filename="${2:-}"

	if [ -n "${_explicit}" ] && [ -f "${_explicit}" ]; then
		chmod 0600 "${_explicit}" 2> "/dev/null" || true
		echo "${_explicit}"
		return 0
	fi

	for _cand in \
		"${VAULT_DIR:-}/keys/${_filename}" \
		"${XDG_DATA_HOME:-${HOME}/.local/share}/vault/keys/${_filename}" \
		"${XDG_CONFIG_HOME:-${HOME}/.config}/vault/keys/${_filename}" \
		"${HOME}/.vault/keys/${_filename}" \
		"/usr/local/share/vault/keys/${_filename}"; do
		if [ -n "${_cand}" ] && [ -f "${_cand}" ]; then
			chmod 0600 "${_cand}" 2> "/dev/null" || true
			echo "${_cand}"
			return 0
		fi
	done

	return 1
}
```

---

## Anti-Padrão 2: Concatenação Cega de Nulo

Implementação Frágil:

```lua
["my-server"] = "ssh -i " .. os.getenv("SERVER_KEY") .. " user@host"
```

Falha: Dispara erro fatal de interrupção se a variável não estiver presente no ambiente.

Correção Canônica:

```lua
local key = os.getenv("SERVER_KEY")
local key_flag = (key and key ~= "") and ("-i " .. key .. " ") or ""
["my-server"] = "ssh " .. key_flag .. "user@host"
```

---

## Anti-Padrão 3: Inclusão Estática em Tempo de Parse no NuShell

Implementação Frágil:

```nu
source ~/.vault/vault.nu
```

Falha: O NuShell valida caminhos no parse time; se o arquivo não existir fisicamente, o interpretador encerra a sessão interativa.

Correção Canônica:

```nu
let vault_path = ($env.HOME | path join ".vault" "vault.nu")
if ($vault_path | path exists) {
	source $vault_path
}
```

---

## Anti-Padrão 4: Suposição Rígida de Diretórios Compartilhados

Implementação Frágil:

```sh
ssh guest "cd \"$PWD\" && agy $*"
```

Falha: Se o comando for executado fora do ponto de montagem compartilhado entre os hosts, o comando encerra em erro de diretório inexistente.

Correção Canônica:

```sh
_target_dir="/home/gabrielf"
case "${PWD}" in
	/home/gabrielf|/home/gabrielf/*) _target_dir="${PWD}" ;;
esac
ssh guest "cd \"${_target_dir}\" 2> "/dev/null" || cd /home/gabrielf; env HOME=/home/gabrielf agy $*"
```
