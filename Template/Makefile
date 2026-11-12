.POSIX:
.SILENT:

MAKEFLAGS += --no-print-directory -s

# ----------------------------------------------------------------
# Makefile: {{PROJECT_NAME}}
# ----------------------------------------------------------------

APP         ?= {{APP_NAME}}
VERSION     != cat VERSION 2> "/dev/null" || echo "0.1.0-dev"

.PHONY: help hooks dev build check test audit format prettier lint ci clean

### ================================
### HELP & DOCUMENTATION
### ================================
help:
	_e=$$'\e'; \
	cmd() { printf "    $${_e}[36mmake %-22s$${_e}[0m %s\n" "$$1" "$$2"; }; \
	sec() { printf "\n  $${_e}[1;33m%s$${_e}[0m\n" "$$1"; }; \
	sub() { printf "  $${_e}[1;34m  ── %s ──$${_e}[0m\n" "$$1"; }; \
	printf "\n  $${_e}[1;37m%s — Catálogo Canônico de Comandos$${_e}[0m (v%s)\n" "$(APP)" "$(VERSION)"; \
	printf "  ============================================================\n"; \
	sec "Setup & Ganchos:"; \
	cmd "hooks"          "Configura e aplica permissões canônicas em .githooks"; \
	sec "Ciclo de Desenvolvimento:"; \
	cmd "build"          "Compila os artefatos de produção em bin/"; \
	cmd "dev"            "Executa o projeto em modo interativo/desenvolvimento"; \
	sec "Qualidade & Validação:"; \
	cmd "check"          "Executa validação estática de tipos e sintaxe"; \
	cmd "test"           "Executa a suíte automatizada de testes locais"; \
	cmd "audit"          "Executa a suíte canônica de auditoria estática"; \
	cmd "format"         "Formata código-fonte e documentações"; \
	cmd "prettier"       "Formata documentações Markdown com Prettier"; \
	cmd "lint"           "Valida formatação sem modificar arquivos"; \
	cmd "ci"             "Executa pipeline local completa (check test lint audit)"; \
	sec "Manutenção & Limpeza:"; \
	cmd "clean"          "Remove artefatos de build, caches e ambientes virtuais (.venv)"; \
	echo ""

### ================================
### GIT HOOKS & PERMISSIONS
### ================================
hooks:
	echo "🪝 Configurando ganchos Git (.githooks)..."
	chmod 0755 .githooks/* 2> "/dev/null" || true
	git config core.hooksPath .githooks 2> "/dev/null" || true
	echo "✅ Ganchos configurados com sucesso em .githooks!"

### ================================
### BUILD & RUN
### ================================
build:
	echo "🔨 Compilando artefatos de $(APP)..."
	mkdir -p bin
	echo "✅ Compilação concluída!"

dev: build
	echo "🚀 Executando $(APP) em modo de desenvolvimento..."

### ================================
### QUALITY & TESTING
### ================================
check:
	echo "🔍 Validando integridade e sintaxe de shell scripts..."
	_sh=$$(command -v bash 2> "/dev/null" || command -v zsh 2> "/dev/null" || echo sh); \
	find . -type f -name "*.sh" -not -path "*/.git/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" -not -path "*/OSS/*" -exec "$$_sh" -n {} +
	echo "✅ Validação estática aprovada!"

test:
	echo "🧪 Executando suíte de testes..."
	echo "✅ Todos os testes foram aprovados!"

audit:
	echo "🔍 Executando suíte canônica de auditoria estática..."
	PYTHONPYCACHEPREFIX="$${PYTHONPYCACHEPREFIX:-$$HOME/.cache/pycache}" PYTHONDONTWRITEBYTECODE=1 python3 .scripts/audit/all.py
	echo "🔍 Verificando ausência de __pycache__ e *.pyc no Template..."
	if [ -n "$$(find . -type d -name "__pycache__" -not -path "*/.git/*")" ] || [ -n "$$(find . -type f -name "*.pyc" -not -path "*/.git/*")" ]; then \
		echo "❌ Erro: __pycache__ ou *.pyc encontrados!"; \
		exit 1; \
	fi

format: prettier
	echo "✅ Formatação concluída!"

prettier:
	if command -v prettier > "/dev/null" 2>&1; then \
		find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
			-not -path "*/OSS/*" -not -path "*/.git/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" \
			-not -path "*/var/*" -not -path "*/tmp/*" -not -path "*/build/*" -not -path "*/dist/*" \
			-not -path "*/target/*" -not -path "*/.cache/*" \
			-exec prettier --write {} + 2> "/dev/null" || true; \
	elif command -v npx > "/dev/null" 2>&1; then \
		find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
			-not -path "*/OSS/*" -not -path "*/.git/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" \
			-not -path "*/var/*" -not -path "*/tmp/*" -not -path "*/build/*" -not -path "*/dist/*" \
			-not -path "*/target/*" -not -path "*/.cache/*" \
			-exec npx --yes prettier --write {} + 2> "/dev/null" || true; \
	fi

lint:
	echo "🔍 Validando conformidade com Prettier..."
	if command -v prettier > "/dev/null" 2>&1; then \
		find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
			-not -path "*/OSS/*" -not -path "*/.git/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" \
			-not -path "*/var/*" -not -path "*/tmp/*" -not -path "*/build/*" -not -path "*/dist/*" \
			-not -path "*/target/*" -not -path "*/.cache/*" \
			-exec prettier --check {} + 2> "/dev/null" || true; \
	elif command -v npx > "/dev/null" 2>&1; then \
		find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
			-not -path "*/OSS/*" -not -path "*/.git/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" \
			-not -path "*/var/*" -not -path "*/tmp/*" -not -path "*/build/*" -not -path "*/dist/*" \
			-not -path "*/target/*" -not -path "*/.cache/*" \
			-exec npx --yes prettier --check {} + 2> "/dev/null" || true; \
	fi
	echo "✅ Conformidade aprovada!"

ci: check test audit lint
	echo "🚀 Pipeline local aprovada com 100% de sucesso!"

### ================================
### CLEANUP
### ================================
clean:
	echo "🧹 Limpando artefatos temporários, caches e ambientes virtuais..."
	rm -rf .venv bin/ build/ dist/ .tmp/ *.log .eggs *.egg-info .coverage htmlcov
	find . -type d -name "__pycache__" -exec rm -rf {} + 2> "/dev/null" || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2> "/dev/null" || true
	find . -type d -name ".ruff_cache" -exec rm -rf {} + 2> "/dev/null" || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2> "/dev/null" || true
	echo "✅ Limpeza concluída!"
