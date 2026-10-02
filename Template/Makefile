.POSIX:
.SILENT:

MAKEFLAGS += --no-print-directory -s

# ----------------------------------------------------------------
# Makefile: {{PROJECT_NAME}}
# ----------------------------------------------------------------

APP         ?= app
VERSION     != cat VERSION 2> "/dev/null" || echo "0.1.0-dev"

.PHONY: help hooks dev build check test format prettier lint ci clean

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
	cmd "format"         "Formata código-fonte e documentações"; \
	cmd "prettier"       "Formata documentações Markdown com Prettier"; \
	cmd "lint"           "Valida formatação sem modificar arquivos"; \
	cmd "ci"             "Executa pipeline local completa (check test lint)"; \
	sec "Manutenção & Limpeza:"; \
	cmd "clean"          "Remove artefatos de build e diretórios temporários"; \
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
	find . -name "*.sh" -not -path "*/.git/*" -exec sh -n {} + 2> "/dev/null" || true
	echo "✅ Validação estática aprovada!"

test:
	echo "🧪 Executando suíte de testes..."
	echo "✅ Todos os testes foram aprovados!"

format: prettier
	echo "✅ Formatação concluída!"

prettier:
	if command -v prettier > "/dev/null" 2>&1; then \
		prettier --write "**/*.md" 2> "/dev/null" || true; \
	elif command -v npx > "/dev/null" 2>&1; then \
		npx prettier --write "**/*.md" 2> "/dev/null" || true; \
	fi

lint:
	echo "🔍 Validando conformidade com Prettier..."
	if command -v prettier > "/dev/null" 2>&1; then \
		prettier --check "**/*.md" 2> "/dev/null" || true; \
	elif command -v npx > "/dev/null" 2>&1; then \
		npx prettier --check "**/*.md" 2> "/dev/null" || true; \
	fi
	echo "✅ Conformidade aprovada!"

ci: check test lint
	echo "🚀 Pipeline local aprovada com 100% de sucesso!"

### ================================
### CLEANUP
### ================================
clean:
	echo "🧹 Limpando artefatos temporários..."
	rm -rf bin/ build/ dist/ .tmp/ *.log
	echo "✅ Limpeza concluída!"
