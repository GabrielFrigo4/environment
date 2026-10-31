#!/usr/bin/env sh
# ----------------------------------------------------------------
# Interface: Universal Environment Global Orchestrator
# ----------------------------------------------------------------
set -eu

### ================================
### ELEVATION & SELF-HEALING
### ================================
ELEVATE=""
if [ "$(id -u)" -ne 0 ]; then
	if command -v doas > "/dev/null" 2>&1; then
		ELEVATE="doas"
	elif command -v sudo > "/dev/null" 2>&1; then
		ELEVATE="sudo"
	fi
fi

_ENV_ROOT="$(cd "$(dirname "$0")" && pwd)"

_self_heal_perms() {
	[ -d "${_ENV_ROOT}/.git" ] && command -v git > "/dev/null" 2>&1 && git -C "${_ENV_ROOT}" config core.hooksPath .githooks 2> "/dev/null" || true
	[ -d "${_ENV_ROOT}/.githooks" ] && chmod 0755 "${_ENV_ROOT}/.githooks/"* 2> "/dev/null" || true
	[ -f "${_ENV_ROOT}/environment.sh" ] && chmod 0755 "${_ENV_ROOT}/environment.sh" 2> "/dev/null" || true
}
_self_heal_perms

### ================================
### SEMANTIC UI EMISSION
### ================================
_e=$'\e'
_ui_reset="${_e}[0m"
_ui_cyan="${_e}[1;36m"
_ui_green="${_e}[1;32m"
_ui_yellow="${_e}[1;33m"
_ui_red="${_e}[1;31m"
_ui_magenta="${_e}[1;35m"

_ui_has_color() { [ -t 1 ] && [ "${TERM:-}" != "dumb" ] && [ -n "${TERM:-}" ]; }
_ui_step() { _ui_has_color && printf "%s==>%s %s\n" "${_ui_cyan}" "${_ui_reset}" "$*" || printf "==> %s\n" "$*"; }
_ui_sub()  { _ui_has_color && printf "%s  ↳%s %s\n" "${_ui_cyan}" "${_ui_reset}" "$*" || printf "  -> %s\n" "$*"; }
_ui_ok()   { _ui_has_color && printf "%s  ✅%s %s\n" "${_ui_green}" "${_ui_reset}" "$*" || printf "  OK %s\n" "$*"; }
_ui_warn() { _ui_has_color && printf "%s  ⚠️ %s %s\n" "${_ui_yellow}" "${_ui_reset}" "$*" || printf "  WARN %s\n" "$*"; }
_ui_err()  { [ -t 2 ] && printf "%s  ❌%s %s\n" "${_ui_red}" "${_ui_reset}" "$*" >&2 || printf "  FAIL %s\n" "$*" >&2; }
_ui_info() { _ui_has_color && printf "%s  ℹ️ %s %s\n" "${_ui_magenta}" "${_ui_reset}" "$*" || printf "  INFO %s\n" "$*"; }

### ================================
### PERMISSION RECOVERY
### ================================
_fix_shell_perms() {
	_target="/usr/local/share/shell"
	[ -d "${_target}" ] || return 0
	_u="${SUDO_USER:-${DOAS_USER:-$(id -un)}}"
	_g="$(id -gn "${_u}" 2> "/dev/null" || id -gn)"
	_owner="$(stat -c '%u' "${_target}/.git/objects" 2> "/dev/null" || stat -f '%u' "${_target}/.git/objects" 2> "/dev/null" || echo "")"
	if [ "${_owner}" = "0" ] || [ "$(id -u)" -eq 0 ]; then
		[ -n "${ELEVATE}" ] && ${ELEVATE} chown -R "${_u}:${_g}" "${_target}" 2> "/dev/null" || true
		[ "$(id -u)" -eq 0 ] && chown -R "${_u}:${_g}" "${_target}" 2> "/dev/null" || true
	fi
	git config --global --add safe.directory "${_target}" 2> "/dev/null" || true
	[ -n "${ELEVATE}" ] && ${ELEVATE} git config --system --add safe.directory "${_target}" 2> "/dev/null" || true
}

_find_repo() {
	for _p in "$@"; do
		[ -d "${_p}/.git" ] && echo "${_p}" && return 0
	done
	return 1
}

### ================================
### COMMAND HANDLERS
### ================================
_env_help() {
	cat <<- EOF
		Universal Environment — Orquestrador Global do Ecossistema
		Uso: environment.sh [comando]

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
		return 0
	fi
	_ui_step "Status do Ecossistema"
	for _d in Setup Shell Profile Vault Editor/*; do
		if [ -d "${_ENV_ROOT}/${_d}/.git" ] || [ -f "${_ENV_ROOT}/${_d}/.git" ]; then
			printf "[%s]:\n" "${_d}"
			git -C "${_ENV_ROOT}/${_d}" status -s
			echo ""
		fi
	done
}

_env_test() {
	_ui_step "Executando validação de testes em todo o ecossistema..."
	if command -v make > "/dev/null" 2>&1; then
		make -C "${_ENV_ROOT}" test
	else
		for _s in Setup/setup.sh Shell/shell.sh Profile/profile.sh Vault/vault.sh Editor/*/*.sh; do
			[ -f "${_ENV_ROOT}/${_s}" ] && sh "${_ENV_ROOT}/${_s}" test || true
		done
	fi
	_ui_ok "Todos os testes concluídos com sucesso!"
}

_env_audit() {
	_ui_step "Executando auditoria estática global..."
	command -v make > "/dev/null" 2>&1 && make -C "${_ENV_ROOT}" audit
}

_env_doctor() {
	[ -f "${_ENV_ROOT}/Setup/.scripts/audit/doctor.sh" ] && sh "${_ENV_ROOT}/Setup/.scripts/audit/doctor.sh"
}

_env_update() {
	_ui_step "Atualizando ecossistema soberano no sistema operacional..."
	_fix_shell_perms

	_st="$(_find_repo "/usr/local/share/shell" "${HOME}/.local/share/shell" "${HOME}/.config/shell" "${HOME}/.shell" || true)"
	if [ -n "${_st}" ]; then
		_ui_step "Atualizando Universal Shell em ${_st}..."
		git -C "${_st}" pull --ff-only 2> "/dev/null" || git -C "${_st}" pull || _ui_warn "Shell: git pull falhou."
		_fix_shell_perms
	else
		_ui_info "Shell: nenhum clone soberano encontrado."
	fi

	_pt="$(_find_repo "${HOME}/.local/share/profile" "${HOME}/.config/profile" "${HOME}/.profile" || true)"
	if [ -n "${_pt}" ]; then
		_ui_step "Atualizando Universal Profile em ${_pt}..."
		git -C "${_pt}" pull --ff-only 2> "/dev/null" || git -C "${_pt}" pull || _ui_warn "Profile: git pull falhou."
		[ -f "${_pt}/profile.sh" ] && _ui_sub "Sincronizando dotfiles..." && sh "${_pt}/profile.sh" sync 2> "/dev/null" || true
	else
		_ui_info "Profile: nenhum clone soberano encontrado."
	fi

	_vt="$(_find_repo "${HOME}/.local/share/vault" "${HOME}/.config/vault" "${HOME}/.vault" "/usr/local/share/vault" || true)"
	if [ -n "${_vt}" ]; then
		_ui_step "Atualizando Universal Vault em ${_vt}..."
		git -C "${_vt}" pull --ff-only 2> "/dev/null" || git -C "${_vt}" pull || _ui_warn "Vault: git pull falhou."
	else
		_ui_info "Vault: nenhum clone soberano encontrado."
	fi

	for _ed in "emacs:${HOME}/.emacs.d" "helix:${HOME}/.config/helix" "nvim:${HOME}/.config/nvim" "vim:${HOME}/.vim"; do
		_repo="${_ed%%:*}"; _dest="${_ed##*:}"
		if [ -d "${_dest}/.git" ]; then
			_ui_step "Atualizando ${_repo} em ${_dest}..."
			git -C "${_dest}" pull --ff-only 2> "/dev/null" || git -C "${_dest}" pull || _ui_warn "${_repo}: git pull falhou."
		fi
	done

	_ui_ok "Ecossistema soberano atualizado com sucesso!"
}

_env_install_sovereign() {
	_ui_step "Instalando ecossistema nas posições canônicas do sistema..."

	_shell_target="/usr/local/share/shell"
	if [ ! -d "${_shell_target}/.git" ]; then
		if [ -w "/usr/local/share" ] || [ "$(id -u)" -eq 0 ]; then
			mkdir -p "/usr/local/share" 2> "/dev/null" || true
			_ui_step "Clonando Universal Shell em ${_shell_target}..."
			git clone "https://github.com/GabrielFrigo4/shell.git" "${_shell_target}"
		elif [ -n "${ELEVATE}" ]; then
			${ELEVATE} mkdir -p "/usr/local/share" 2> "/dev/null" || true
			_ui_step "Clonando Universal Shell em ${_shell_target} via ${ELEVATE}..."
			${ELEVATE} git clone "https://github.com/GabrielFrigo4/shell.git" "${_shell_target}"
		else
			_shell_target="${HOME}/.local/share/shell"
			if [ ! -d "${_shell_target}/.git" ]; then
				_ui_step "Clonando Universal Shell em ${_shell_target} (rootless)..."
				mkdir -p "${HOME}/.local/share"
				git clone "https://github.com/GabrielFrigo4/shell.git" "${_shell_target}"
			fi
		fi
	fi
	_fix_shell_perms
	[ -d "${_shell_target}/.git" ] && _ui_info "Shell configurado em ${_shell_target}."

	if [ -f "${_shell_target}/install.sh" ]; then
		_ui_step "Executando instalador soberano do Shell..."
		sh "${_shell_target}/install.sh" --pure
	fi

	_profile_target="${HOME}/.local/share/profile"
	if [ ! -d "${_profile_target}/.git" ]; then
		_ui_step "Clonando Profile em ${_profile_target}..."
		mkdir -p "${HOME}/.local/share" && git clone "https://github.com/GabrielFrigo4/profile.git" "${_profile_target}"
	else
		_ui_info "Profile já presente em ${_profile_target}."
	fi

	_vault_target="${HOME}/.local/share/vault"
	if [ ! -d "${_vault_target}/.git" ]; then
		_ui_step "Clonando Vault (via SSH) em ${_vault_target}..."
		mkdir -p "${HOME}/.local/share"
		git clone "git@github.com:GabrielFrigo4/vault.git" "${_vault_target}" 2> "/dev/null" || _ui_warn "Vault clone SSH falhou. Configure sua chave SSH."
	else
		_ui_info "Vault já presente em ${_vault_target}."
	fi

	for _ed in "emacs:${HOME}/.emacs.d:GabrielFrigo4/.emacs.d.git" "helix:${HOME}/.config/helix:GabrielFrigo4/helix.git" "nvim:${HOME}/.config/nvim:GabrielFrigo4/nvim.git" "vim:${HOME}/.vim:GabrielFrigo4/vim.git"; do
		_repo="${_ed%%:*}"; _rest="${_ed#*:}"; _dest="${_rest%%:*}"; _slug="${_rest##*:}"
		if [ ! -d "${_dest}/.git" ]; then
			mkdir -p "$(dirname "${_dest}")"
			_ui_step "Clonando ${_repo} em ${_dest}..."
			git clone "https://github.com/${_slug}" "${_dest}" || true
		else
			_ui_info "${_repo} já presente em ${_dest}."
		fi
	done

	[ -f "${_profile_target}/profile.sh" ] && _ui_step "Disparando sincronização do Profile..." && sh "${_profile_target}/profile.sh" sync

	_ui_ok "Instalação e clones soberanos configurados com sucesso!"
}

### ================================
### DISPATCHER ENTRYPOINT
### ================================
_cmd="${1:-help}"
[ "$#" -ge 1 ] && shift 1

case "${_cmd}" in
	update) _env_update "$@" ;;
	test)   _env_test ;;
	audit)  _env_audit ;;
	doctor) _env_doctor ;;
	install|bootstrap|clone) _env_install_sovereign ;;
	status) _env_status ;;
	help|-h|--help) _env_help ;;
	*)
		_ui_err "Comando desconhecido: ${_cmd}"
		_env_help >&2
		exit 1
		;;
esac
