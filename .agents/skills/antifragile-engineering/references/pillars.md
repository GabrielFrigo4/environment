# Pilares da Engenharia Antifrágil

Este runbook detalha os contratos de auto-recuperação e resiliência em tempo de execução para scripts de infraestrutura e utilitários UNIX.

---

## 1. Cascata Ativa de Descoberta

Nenhum script, loader ou utilitário deve presumir localização estática única de arquivos. A resolução hierárquica respeita a seguinte precedência de especificidade:

1. Variável explícita de ambiente válida e com arquivo existente em disco.
2. Diretório ativo do componente injetado pelo orquestrador.
3. Diretório canônico XDG Data: `${XDG_DATA_HOME:-${HOME}/.local/share}/<app>/...`.
4. Diretório canônico XDG Config: `${XDG_CONFIG_HOME:-${HOME}/.config}/<app>/...`.
5. Fallback clássico do usuário: `${HOME}/.<app>/...`.
6. Diretório de sistema FHS: `/usr/local/share/<app>/...` ou `/etc/<app>/...`.

---

## 2. Auto-Cura de Permissões em Voo

Arquivos sensíveis como chaves SSH e certificados SSL que falham por permissões frouxas são corrigidos de maneira defensiva no instante do consumo:

```sh
if [ -n "${_found_key}" ] && [ -f "${_found_key}" ]; then
	chmod 0600 "${_found_key}" 2> "/dev/null" || true
fi
```

---

## 3. Auto-Correção da Sessão

Ao localizar um artefato disperso, a função exporta o caminho resolvido para o ambiente corrente, eliminando penalidade de descoberta em subprocessos posteriores:

```sh
export PERSONAL_SERVER_KEY="${_resolved_key}"
```

---

## 4. Encaminhamento Total e Zero Falha Cega

- Se a chave física não estiver acessível, não injete argumentos vazios que quebrem o utilitário. Verifique agentes de autenticação em memória ou invoque a ferramenta sem a flag restritiva.
- Propague todos os argumentos variáveis recebidos (`"$@"` no Shell POSIX, `$args` no PowerShell, `...rest` no NuShell).

---

## 5. Invariante Out-of-the-Box de Clonagem

- **Permissões no Git Index:** Modos octais canônicos mantidos no versionamento (`0755` para scripts executáveis, `0644` para configurações e `0600` para chaves).
- **Auto-Cura Pós-Clone:** Scripts de entrada inspecionam o sistema de arquivos hospedeiro e corrigem bits de execução se o filesystem subjacente não suportar metadados POSIX.
- **Diretórios Pré-Requisito:** Assegure caminhos de trabalho via `mkdir -p` antes de operações de escrita.

---

## 6. Elevação Antifrágil de Privilégios

Em scripts com `set -eu`, substituições ternárias diretas como `ELEVATE="$( [ "$(id -u)" -ne 0 ] && ... )"` quebram a execução sob conta root. Empregue blocos condicionais explícitos:

```sh
ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi
```

---

## 7. Deslocamento Seguro de Argumentos

No POSIX, o utilitário especial `shift` encerra o shell incondicionalmente sob `set -e` quando executado com menos argumentos que o parâmetro numérico informado. Sempre valide a contagem:

Deslocamento unitário defensivo:

```sh
[ "$#" -ge 1 ] && shift
```

Deslocamento múltiplo defensivo:

```sh
if [ "$#" -ge 2 ]; then
	shift 2
	comments="$*"
else
	comments=""
fi
```

---

## 8. Sincronização Reentrante Multi-Shell

Rotinas de recarga de shell inspecionam outros shells instalados e atualizam atomicamente seus perfis, validando se o arquivo destino já constitui um link simbólico para impedir auto-sobrescrita:

```powershell
if ($env:APPDATA) {
	$appNu = Join-Path $env:APPDATA "nushell"
	$nuSrc = Join-Path $target "target\windows\nushell"
	if ((Test-Path $appNu) -and (Test-Path $nuSrc)) {
		foreach ($f in @("config.nu", "env.nu")) {
			$srcF = Join-Path $nuSrc $f
			$dstF = Join-Path $appNu $f
			if (Test-Path $srcF) {
				$isLink = $false
				if (Test-Path $dstF) {
					$item = Get-Item $dstF -Force -ErrorAction SilentlyContinue
					if ($item -and ($item.LinkType -or ($item.FullName -eq (Get-Item $srcF -Force).FullName))) {
						$isLink = $true
					}
				}
				if (-not $isLink) {
					Copy-Item $srcF $dstF -Force -ErrorAction SilentlyContinue
				}
			}
		}
	}
}
```
