#!/usr/bin/env sh
# ----------------------------------------------------------------
# Interface: Universal Environment Global Orchestrator
# ----------------------------------------------------------------
set -eu

_ENV_ROOT="$(cd "$(dirname "$0")" && pwd)"

_env_help() {
	cat <<- EOF
		Universal Environment — Orquestrador Global do Ecossistema

		Uso:
		  environment.sh [comando]

		Comandos:
		  update       Atualiza todos os repositorios e submodulos do ecossistema
		  test         Valida a sintaxe POSIX e integridade de todos os componentes
		  audit        Executa as suites de auditoria estatica em todos os projetos
		  doctor       Executa sanity check e diagnostico de saude do sistema
		  clone        Realiza o bootstrap clonando cada repositorio em seu destino soberano
		  status       Exibe o estado Git de todo o ecossistema
		  help         Exibe esta mensagem de ajuda
	EOF
}

_env_status() {
	if command -v make > "/dev/null" 2>&1; then
		make -C "${_ENV_ROOT}" status
	else
		echo "=== Status do Ecossistema ==="
		for _d in Setup Shell Profile Vault Editor/*; do
			if [ -d "${_ENV_ROOT}/${_d}/.git" ] || [ -f "${_ENV_ROOT}/${_d}/.git" ]; then
				echo "[$(_d)]:"
				git -C "${_ENV_ROOT}/${_d}" status -s
				echo ""
			fi
		done
	fi
}

_env_test() {
	echo "🧪 [Environment] Executando validação de testes em todo o ecossistema..."
	if command -v make > "/dev/null" 2>&1; then
		make -C "${_ENV_ROOT}" test
	else
		for _script in Setup/setup.sh Shell/shell.sh Profile/profile.sh Vault/vault.sh Editor/*/*.sh; do
			if [ -f "${_ENV_ROOT}/${_script}" ]; then
				sh "${_ENV_ROOT}/${_script}" test || true
			fi
		done
	fi
	echo "✅ [Environment] Todos os testes concluídos!"
}

_env_audit() {
	echo "🔍 [Environment] Executando auditoria estática global..."
	if command -v make > "/dev/null" 2>&1; then
		make -C "${_ENV_ROOT}" audit
	fi
}

_env_doctor() {
	if [ -f "${_ENV_ROOT}/Setup/scripts/audit/doctor.sh" ]; then
		sh "${_ENV_ROOT}/Setup/scripts/audit/doctor.sh"
	fi
}

_env_update() {
	echo "🔄 [Environment] Atualizando todos os componentes do ecossistema..."
	if command -v make > "/dev/null" 2>&1; then
		make -C "${_ENV_ROOT}" pull
	fi
}

_env_install_sovereign() {
	echo "🚀 [Environment] Instalando ecossistema nas posições canônicas do sistema..."
	echo ""

	_shell_target="/usr/local/share/shell"
	if [ ! -d "${_shell_target}/.git" ]; then
		if [ -w "/usr/local/share" ] || [ "$(id -u)" -eq 0 ]; then
			echo "📦 Clonando Universal Shell em ${_shell_target}..."
			git clone "https://github.com/GabrielFrigo4/shell.git" "${_shell_target}"
		else
			_shell_target="${HOME}/.local/share/shell"
			if [ ! -d "${_shell_target}/.git" ]; then
				echo "📦 Clonando Universal Shell em ${_shell_target} (rootless)..."
				mkdir -p "${HOME}/.local/share"
				git clone "https://github.com/GabrielFrigo4/shell.git" "${_shell_target}"
			else
				echo "  ℹ️  Shell já presente em ${_shell_target}."
			fi
		fi
	else
		echo "  ℹ️  Shell já presente em ${_shell_target}."
	fi

	if [ -f "${_shell_target}/install.sh" ]; then
		echo "🐚 Executando instalador soberano do Shell..."
		sh "${_shell_target}/install.sh" --pure
	fi

	_profile_target="${HOME}/.config/profile"
	if [ ! -d "${_profile_target}/.git" ]; then
		echo "📦 Clonando Profile em ${_profile_target}..."
		git clone "https://github.com/GabrielFrigo4/profile.git" "${_profile_target}"
	else
		echo "  ℹ️  Profile já presente em ${_profile_target}."
	fi

	_vault_target="${HOME}/.vault"
	if [ ! -d "${_vault_target}/.git" ]; then
		echo "🔐 Clonando Vault (via SSH) em ${_vault_target}..."
		git clone "git@github.com:GabrielFrigo4/vault.git" "${_vault_target}" 2> "/dev/null" || echo "  ⚠️ Vault clone SSH falhou. Configure sua chave SSH."
	else
		echo "  ℹ️  Vault já presente em ${_vault_target}."
	fi

	for _repo_name in emacs helix nvim vim; do
		case "${_repo_name}" in
			emacs) _dest="${HOME}/.emacs.d";  _url="https://github.com/GabrielFrigo4/.emacs.d.git" ;;
			helix) _dest="${HOME}/.config/helix"; _url="https://github.com/GabrielFrigo4/helix.git" ;;
			nvim)  _dest="${HOME}/.config/nvim";  _url="https://github.com/GabrielFrigo4/nvim.git" ;;
			vim)   _dest="${HOME}/.vim";          _url="https://github.com/GabrielFrigo4/vim.git" ;;
		esac
		if [ ! -d "${_dest}/.git" ]; then
			echo "📝 Clonando ${_repo_name} em ${_dest}..."
			git clone "${_url}" "${_dest}" || true
		else
			echo "  ℹ️  ${_repo_name} já presente em ${_dest}."
		fi
	done

	if [ -f "${_profile_target}/profile.sh" ]; then
		echo ""
		echo "🎨 Disparando sincronização a partir do clone soberano do Profile..."
		sh "${_profile_target}/profile.sh" sync
	fi

	echo ""
	echo "🎉 Instalação e clones soberanos configurados com sucesso!"
}

_cmd="${1:-help}"
shift 2> "/dev/null" || true

case "${_cmd}" in
	update) _env_update "$@" ;;
	test)   _env_test ;;
	audit)  _env_audit ;;
	doctor) _env_doctor ;;
	install|bootstrap|clone) _env_install_sovereign ;;
	status) _env_status ;;
	help|-h|--help) _env_help ;;
	*)
		echo "❌ Comando desconhecido: ${_cmd}" >&2
		_env_help >&2
		exit 1
		;;
esac
