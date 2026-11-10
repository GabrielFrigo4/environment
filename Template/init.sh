#!/usr/bin/env sh
# ----------------------------------------------------------------
# Scaffolding: Universal Project Initializer
# ----------------------------------------------------------------

set -eu

_dir="$(cd "$(dirname "$0")" && pwd)"
. "${_dir}/.scripts/ui.sh"

_rm=0
_name="${NAME:-}"
_desc="${DESC:-}"
_app="${APP:-}"

_pos_idx=0
for _arg in "$@"; do
	if [ "${_arg}" = "--rm" ]; then
		_rm=1
	else
		_pos_idx=$((_pos_idx + 1))
		case "${_pos_idx}" in
			1) _name="${_arg}" ;;
			2) _desc="${_arg}" ;;
			3) _app="${_arg}" ;;
		esac
	fi
done

if [ -z "${_name}" ]; then
	_ui_banner "Universal Project Archetype Initializer"
	printf "Nome do Projeto (ex: MeuProjeto): "
	read -r _name
fi

if [ -z "${_desc}" ]; then
	printf "Descrição do Projeto: "
	read -r _desc
fi

[ -z "${_app}" ] && _app="$(printf "%s" "${_name}" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"

_ui_step "Inicializando projeto '${_name}' (${_app})..."

_ui_sub "Substituindo marcadores declarativos..."
for _file in "${_dir}/README.md" "${_dir}/TODO.md" "${_dir}/Makefile" "${_dir}/AGENTS.md"; do
	if [ -f "${_file}" ]; then
		sed -i "s/{{PROJECT_NAME}}/${_name}/g" "${_file}"
		sed -i "s/{{PROJECT_DESCRIPTION}}/${_desc}/g" "${_file}"
		sed -i "s/{{APP_NAME}}/${_app}/g" "${_file}"
		sed -i "s/{{APP}}/${_app}/g" "${_file}"
	fi
done

_ui_sub "Inicializando e configurando Git..."
if [ ! -d "${_dir}/.git" ]; then
	git init -b main "${_dir}" > "/dev/null" 2>&1 || git init "${_dir}" > "/dev/null" 2>&1
fi
git -C "${_dir}" config core.hooksPath .githooks > "/dev/null" 2>&1 || true

_ui_sub "Aplicando permissões canônicas..."
find "${_dir}" -maxdepth 1 -type f \( -name "*.md" -o -name "Makefile" -o -name "VERSION" -o -name ".gitignore" \) -exec chmod 0644 {} + > "/dev/null" 2>&1 || true
if [ -d "${_dir}/.githooks" ]; then
	find "${_dir}/.githooks" -type f -exec chmod 0755 {} + > "/dev/null" 2>&1 || true
fi
if [ -d "${_dir}/.scripts" ]; then
	find "${_dir}/.scripts" -type f -name "*.sh" -exec chmod 0755 {} + > "/dev/null" 2>&1 || true
fi
if [ -d "${_dir}/.scripts/audit" ]; then
	find "${_dir}/.scripts/audit" -type f -name "*.py" -exec chmod 0755 {} + > "/dev/null" 2>&1 || true
	find "${_dir}/.scripts/audit" -type f -name "*.md" -exec chmod 0644 {} + > "/dev/null" 2>&1 || true
fi

_ui_ok "Projeto '${_name}' inicializado com sucesso!"
_ui_info "Execute 'make help' para explorar o catálogo de comandos."

if [ "${_rm}" -eq 1 ]; then
	_ui_sub "Removendo script de inicialização (--rm)..."
	rm -f "$0"
fi
