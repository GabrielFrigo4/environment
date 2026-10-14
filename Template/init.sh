#!/usr/bin/env sh
# ----------------------------------------------------------------
# Scaffolding: Universal Project Initializer
# ----------------------------------------------------------------

set -eu

_dir="$(cd "$(dirname "$0")" && pwd)"
. "${_dir}/scripts/ui.sh"

_name="${1:-}"
_desc="${2:-}"
_app="${3:-}"

if [ -z "${_name}" ]; then
	_ui_banner "Universal Project Archetype Initializer"
	printf "Nome do Projeto (ex: MeuProjeto): "
	read -r _name
fi

if [ -z "${_desc}" ]; then
	printf "Descrição do Projeto: "
	read -r _desc
fi

[ -z "${_app}" ] && _app="$(echo "${_name}" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"

_ui_step "Inicializando projeto '${_name}' (${_app})..."

_ui_sub "Substituindo marcadores declarativos..."
for _file in "${_dir}/README.md" "${_dir}/Makefile" "${_dir}/AGENTS.md"; do
	if [ -f "${_file}" ]; then
		sed -i "s/{{PROJECT_NAME}}/${_name}/g" "${_file}"
		sed -i "s/{{PROJECT_DESCRIPTION}}/${_desc}/g" "${_file}"
		sed -i "s/{{APP}}/${_app}/g" "${_file}"
	fi
done

_ui_sub "Configurando ganchos Git..."
make -C "${_dir}" hooks > "/dev/null" 2>&1 || true

_ui_ok "Projeto '${_name}' inicializado com sucesso!"
_ui_info "Execute 'make help' para explorar o catálogo de comandos."
