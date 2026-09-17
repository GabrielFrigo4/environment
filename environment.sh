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
		  install      Clona e instala todos os repositorios em suas posicoes canonicas no SO
		  update       Atualiza todas as instalacoes soberanas no SO (Shell, Profile, Vault, Editores)
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
	echo "🔄 [Environment] Atualizando ecossistema soberano no sistema operacional..."
	echo ""

	_shell_target=""
	if [ -d "/usr/local/share/shell/.git" ]; then
		_shell_target="/usr/local/share/shell"
	elif [ -d "${HOME}/.local/share/shell/.git" ]; then
		_shell_target="${HOME}/.local/share/shell"
	elif [ -d "${HOME}/.config/shell/.git" ]; then
		_shell_target="${HOME}/.config/shell"
	elif [ -d "${HOME}/.shell/.git" ]; then
		_shell_target="${HOME}/.shell"
	fi

	if [ -n "${_shell_target}" ]; then
		echo "🐚 Atualizando Universal Shell em ${_shell_target}..."
		git -C "${_shell_target}" pull --ff-only 2> "/dev/null" || git -C "${_shell_target}" pull || echo "  ⚠️  Shell: git pull falhou."
	else
		echo "  ℹ️  Shell: nenhum clone soberano encontrado."
	fi

	_profile_target=""
	if [ -d "${HOME}/.local/share/profile/.git" ]; then
		_profile_target="${HOME}/.local/share/profile"
	elif [ -d "${HOME}/.config/profile/.git" ]; then
		_profile_target="${HOME}/.config/profile"
	elif [ -d "${HOME}/.profile/.git" ]; then
		_profile_target="${HOME}/.profile"
	fi

	if [ -n "${_profile_target}" ]; then
		echo "🎨 Atualizando Universal Profile em ${_profile_target}..."
		git -C "${_profile_target}" pull --ff-only 2> "/dev/null" || git -C "${_profile_target}" pull || echo "  ⚠️  Profile: git pull falhou."
		if [ -f "${_profile_target}/profile.sh" ]; then
			echo "   Sincronizando dotfiles e skills via profile.sh..."
			sh "${_profile_target}/profile.sh" sync 2> "/dev/null" || true
		fi
	else
		echo "  ℹ️  Profile: nenhum clone soberano encontrado."
	fi

	_vault_target=""
	if [ -d "${HOME}/.local/share/vault/.git" ]; then
		_vault_target="${HOME}/.local/share/vault"
	elif [ -d "${HOME}/.config/vault/.git" ]; then
		_vault_target="${HOME}/.config/vault"
	elif [ -d "${HOME}/.vault/.git" ]; then
		_vault_target="${HOME}/.vault"
	elif [ -d "/usr/local/share/vault/.git" ]; then
		_vault_target="/usr/local/share/vault"
	fi

	if [ -n "${_vault_target}" ]; then
		echo "🔐 Atualizando Universal Vault em ${_vault_target}..."
		git -C "${_vault_target}" pull --ff-only 2> "/dev/null" || git -C "${_vault_target}" pull || echo "  ⚠️  Vault: git pull falhou."
	else
		echo "  ℹ️  Vault: nenhum clone soberano encontrado."
	fi

	for _repo_name in emacs helix nvim vim; do
		case "${_repo_name}" in
			emacs) _dest="${HOME}/.emacs.d" ;;
			helix) _dest="${HOME}/.config/helix" ;;
			nvim)  _dest="${HOME}/.config/nvim" ;;
			vim)   _dest="${HOME}/.vim" ;;
		esac
		if [ -d "${_dest}/.git" ]; then
			echo "📝 Atualizando ${_repo_name} em ${_dest}..."
			git -C "${_dest}" pull --ff-only 2> "/dev/null" || git -C "${_dest}" pull || echo "  ⚠️  ${_repo_name}: git pull falhou."
		fi
	done

	echo ""
	echo "🎉 Ecossistema soberano atualizado com sucesso!"
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

	_profile_target="${HOME}/.local/share/profile"
	if [ ! -d "${_profile_target}/.git" ]; then
		echo "📦 Clonando Profile em ${_profile_target}..."
		mkdir -p "${HOME}/.local/share"
		git clone "https://github.com/GabrielFrigo4/profile.git" "${_profile_target}"
	else
		echo "  ℹ️  Profile já presente em ${_profile_target}."
	fi

	_vault_target="${HOME}/.local/share/vault"
	if [ ! -d "${_vault_target}/.git" ]; then
		echo "🔐 Clonando Vault (via SSH) em ${_vault_target}..."
		mkdir -p "${HOME}/.local/share"
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
