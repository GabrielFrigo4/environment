.POSIX:
.SILENT:

MAKEFLAGS += --no-print-directory -s

# ----------------------------------------------------------------
# Makefile: Universal Environment
# ----------------------------------------------------------------

.PHONY: help status audit sync-docs sync-template scaffold pull update test fix-banners ci doctor clone hooks format prettier lint-format bench uped upgit strip install deploy bootstrap main clean

REPOS     = Setup Shell Vault Profile
EDITORS   = Editor/Emacs Editor/Helix Editor/NeoVim Editor/Vim
ALL_REPOS = $(REPOS) $(EDITORS)

### ================================
### HELP & DOCUMENTATION
### ================================
help:
	_e=$$'\e'; \
	cmd() { printf "    $${_e}[36mmake %-22s$${_e}[0m %s\n" "$$1" "$$2"; }; \
	sec() { printf "\n  $${_e}[1;33m%s$${_e}[0m\n" "$$1"; }; \
	sub() { printf "  $${_e}[1;34m  ── %s ──$${_e}[0m\n" "$$1"; }; \
	printf "\n  $${_e}[1;37mUniversal Environment — Orquestrador Global do Ecossistema$${_e}[0m\n"; \
	printf "  ============================================================\n"; \
	sec "Sincronização & Soberania:"; \
	cmd "clone"          "Inicializa submódulos públicos e clona o Vault defensivamente"; \
	cmd "main"           "Alterna todos os submódulos e repositórios clonados para a branch main"; \
	cmd "pull"           "Atualiza todos os submódulos e repositórios com o GitHub"; \
	cmd "install"        "Clona e instala todos os repositórios em suas posições canônicas no SO"; \
	cmd "update"         "Atualiza todas as instalações soberanas no SO (Shell, Profile, Vault, Editores)"; \
	cmd "sync-docs"      "Propaga ENVIRONMENT.md para os submódulos e executa sync-template"; \
	cmd "sync-template"  "Propaga Template estático, githooks e auditoria a todos os repositórios"; \
	cmd "scaffold"       "Gera novo repositório a partir de Template (DIR=... NAME=... DESC=...)"; \
	cmd "uped"           "Atualiza os 4 repositórios da Suíte de Editores com o upstream"; \
	cmd "upgit"          "Atualiza todos os repositórios Git encontrados recursivamente"; \
	cmd "strip"          "Purga metadados (.git*, .agents, *.md) para modo Zero-Bloat (TARGET=<dir>)"; \
	sec "Diagnóstico & Status:"; \
	cmd "status"         "Exibe status Git resumido de todo o ecossistema (Core + Editores)"; \
	cmd "hooks"          "Configura e aplica permissões canônicas em .githooks em todos os repos"; \
	cmd "bench"          "Mede latência de inicialização de shells e módulos (alvo binário <64ms)"; \
	cmd "doctor"         "Executa diagnóstico de saúde e sanity check pós-boot do sistema"; \
	sec "Qualidade, Testes & CI:"; \
	cmd "test"           "Valida sintaxe Zsh, Bash e POSIX em todos os scripts do ecossistema"; \
	cmd "audit"          "Executa suítes de auditoria estática e conformidade em todos os repos"; \
	cmd "format"         "Formata recursivamente arquivos (MD, JSON, YAML, HTML, CSS) com Prettier"; \
	cmd "prettier"       "Formata recursivamente arquivos com Prettier"; \
	cmd "lint-format"    "Valida formatação recursiva com Prettier sem alterar arquivos"; \
	cmd "ci"             "Executa pipeline completa de testes, auditoria e pre-commit"; \
	sec "Manutenção & Limpeza:"; \
	cmd "clean"          "Remove artefatos temporários, caches e ambientes virtuais (.venv)"; \
	echo ""

### ================================
### REPOSITORIES ORCHESTRATION
### ================================
PRIVATE_REPOS := \
	"Vault:GabrielFrigo4/vault"

clone:
	echo "📦 Inicializando submódulos públicos (Core + Editores)..."
	git submodule update --init --recursive
	echo "✅ Submódulos públicos inicializados!\n"
	echo "🔐 Verificando repositórios privados..."
	for entry in $(PRIVATE_REPOS); do \
		dir=$${entry%%:*}; \
		repo=$${entry##*:}; \
		if [ -e "$$dir/.git" ]; then \
			echo "  ℹ️  $$dir já clonado."; \
		elif git clone "git@github.com:$$repo.git" "$$dir" 2>/dev/null; then \
			echo "  ✅ $$dir clonado com sucesso via SSH!"; \
		elif gh repo clone "$$repo" "$$dir" 2>/dev/null; then \
			echo "  ✅ $$dir clonado com sucesso via gh CLI!"; \
		else \
			echo "  ⚠️  $$dir: clone falhou (verifique SSH ou login no gh)."; \
		fi; \
	done
	echo ""
	$(MAKE) main
	$(MAKE) hooks
	echo "🎉 Ecossistema pronto!"

main:
	echo "🌿 Alternando todos os repositórios clonados para a branch main..."
	for r in $(ALL_REPOS); do \
		if [ -e "$$r/.git" ]; then \
			echo "  🌿 $$r -> main"; \
			git -C "$$r" checkout main 2> "/dev/null" || git -C "$$r" switch main 2> "/dev/null" || echo "  ⚠️  $$r: falha ao alternar para main."; \
		else \
			echo "  ⏭️  $$r: não clonado, pulando."; \
		fi; \
	done
	echo "✅ Repositórios ativos configurados na branch main!\n"

status:
	echo "=== 🏛️ O Quarteto de Infraestrutura ==="
	for r in $(REPOS); do \
		if [ -e "$$r/.git" ]; then \
			echo "[$$(git -C $$r branch --show-current 2> "/dev/null" || echo "detached")] $$r:"; \
			git -C $$r status -s; \
			echo ""; \
		else \
			echo "[não clonado] $$r"; \
			echo ""; \
		fi; \
	done
	echo "=== 📝 A Suíte de Editores ==="
	for ed in $(EDITORS); do \
		if [ -e "$$ed/.git" ]; then \
			echo "[$$(git -C $$ed branch --show-current 2> "/dev/null" || echo "detached")] $$ed:"; \
			git -C $$ed status -s; \
			echo ""; \
		else \
			echo "[não clonado] $$ed"; \
			echo ""; \
		fi; \
	done

pull: main
	echo "⬇️  Atualizando submódulos públicos..."
	git submodule update --remote --merge
	for r in $(ALL_REPOS); do \
		if [ -e "$$r/.git" ]; then \
			echo "⬇️  Pulling $$r..."; \
			git -C $$r pull --ff-only || echo "⚠️  $$r: pull falhou."; \
		fi; \
	done
	if [ -d "$${OSH:-$$HOME/.oh-my-bash}" ]; then \
		echo "⬇️  Pulling Oh-My-Bash..."; \
		git -C "$${OSH:-$$HOME/.oh-my-bash}" pull --ff-only 2> "/dev/null" || true; \
	fi
	if [ -d "$${ZSH:-$$HOME/.oh-my-zsh}" ]; then \
		echo "⬇️  Pulling Oh-My-Zsh..."; \
		git -C "$${ZSH:-$$HOME/.oh-my-zsh}" pull --ff-only 2> "/dev/null" || true; \
	fi

### ================================
### GIT HOOKS & STATUS
### ================================
hooks:
	echo "🪝 Configurando ganchos Git (.githooks) em todos os repositórios..."
	chmod 0755 .githooks/* Template/.githooks/* Setup/.githooks/* Profile/.githooks/* Shell/.githooks/* Editor/*/.githooks/* 2> "/dev/null" || true
	chmod 0700 Vault/.githooks/* 2> "/dev/null" || true
	git config core.hooksPath .githooks 2> "/dev/null" || true
	echo "  ✅ Environment: core.hooksPath -> .githooks"
	for r in $(ALL_REPOS); do \
		[ -e "$$r/.git" ] && git -C $$r config core.hooksPath .githooks && echo "  ✅ $$r: core.hooksPath -> .githooks"; \
	done

### ================================
### SYNCHRONIZATION & UPDATES
### ================================
uped:
	echo "⬇️  Atualizando a Suíte de Editores (git pull --ff-only)..."
	for ed in $(EDITORS); do \
		if [ -e "$$ed/.git" ]; then \
			echo "⬇️  Pulling $$ed..."; \
			git -C $$ed pull --ff-only || echo "⚠️  $$ed: git pull falhou."; \
		else \
			echo "⏭️  $$ed: não inicializado, pulando."; \
		fi; \
	done
	echo "✅ Suíte de Editores atualizada!"

upgit:
	echo "🔄 Atualizando repositórios Git..."
	find . \( -type d -name ".git" -print -prune \) -o \( -type f -name ".git" -print \) 2> "/dev/null" | awk '{ n=split($$0, a, "/"); print n, $$0 }' | sort -n -k1,1 | cut -d' ' -f2- | while read -r g; do \
		d="$$(dirname "$$g")"; \
		echo "# ----------------------------------------------------------------"; \
		echo "# $$d"; \
		echo "# ----------------------------------------------------------------"; \
		git -C "$$d" pull --ff-only 2> "/dev/null" || git -C "$$d" pull || echo "⚠️  Falha ao atualizar $$d"; \
		echo ""; \
	done
	echo "✅ Repositórios Git atualizados!"

sync-template:
	echo "🔄 Sincronizando arquétipo Template em todos os repositórios Git..."
	_docs_root="$${DOCS_ROOT:-$$(cd .. && pwd)}"; \
	find "$${_docs_root}" \
		\( -name "OSS" -o -name "usr" -o -name "elpaca" -o -name "node_modules" -o -name ".venv" -o -name "var" -o -name "tmp" \) -prune \
		-o \( -name ".git" \) -print | while read -r git_entry; do \
		repo_dir="$$(dirname "$$git_entry")"; \
		repo_name="$$(basename "$$repo_dir")"; \
		echo "  📦 Sincronizando: $$repo_name ($$repo_dir)"; \
		mkdir -p "$$repo_dir/.githooks"; \
		cp Template/.githooks/pre-commit "$$repo_dir/.githooks/pre-commit"; \
		cp Template/.githooks/commit-msg "$$repo_dir/.githooks/commit-msg"; \
		cp Template/.editorconfig "$$repo_dir/.editorconfig"; \
		if [ "$$repo_name" != "Environment" ]; then \
			cp Template/PRINCIPLES.md "$$repo_dir/PRINCIPLES.md"; \
			cp Template/AGENTS.md "$$repo_dir/AGENTS.md"; \
			cp Template/CONTRIBUTING.md "$$repo_dir/CONTRIBUTING.md"; \
			cp Template/LICENSE "$$repo_dir/LICENSE"; \
		fi; \
		if [ -f "$$repo_dir/.prettierrc" ] && grep -q "svelte" "$$repo_dir/.prettierrc" 2> "/dev/null"; then \
			: ; \
		else \
			cp Template/.prettierrc "$$repo_dir/.prettierrc"; \
		fi; \
		if [ -f "$$repo_dir/.gitattributes" ] && grep -E -q "(git-crypt|dataset)" "$$repo_dir/.gitattributes" 2> "/dev/null"; then \
			: ; \
		else \
			cp Template/.gitattributes "$$repo_dir/.gitattributes"; \
		fi; \
		if [ -d "$$repo_dir/.scripts/audit" ]; then \
			cp Template/.scripts/audit/* "$$repo_dir/.scripts/audit/"; \
			chmod 0755 "$$repo_dir"/.scripts/audit/*.py 2> "/dev/null" || true; \
		fi; \
		if [ "$$repo_name" = "Vault" ]; then \
			chmod 0700 "$$repo_dir"/.githooks/* 2> "/dev/null" || true; \
			chmod 0600 "$$repo_dir"/*.md "$$repo_dir"/.editorconfig "$$repo_dir"/.gitattributes "$$repo_dir"/.prettierrc "$$repo_dir"/LICENSE 2> "/dev/null" || true; \
		else \
			chmod 0755 "$$repo_dir"/.githooks/* 2> "/dev/null" || true; \
			chmod 0644 "$$repo_dir"/*.md "$$repo_dir"/.editorconfig "$$repo_dir"/.gitattributes "$$repo_dir"/.prettierrc "$$repo_dir"/LICENSE 2> "/dev/null" || true; \
		fi; \
		git -C "$$repo_dir" config core.hooksPath .githooks 2> "/dev/null" || true; \
	done
	echo "✅ Todos os repositórios foram sincronizados com o Template!"

sync-docs: sync-template
	echo "📖 Sincronizando documentação canônica do hub (ENVIRONMENT.md)..."
	for r in $(ALL_REPOS); do \
		if [ -d "$$r" ]; then \
			cp ENVIRONMENT.md "$$r/ENVIRONMENT.md"; \
			chmod 0644 "$$r/ENVIRONMENT.md" 2> "/dev/null" || true; \
			echo "  ✅ $$r: ENVIRONMENT.md sincronizado"; \
		fi; \
	done
	echo "🎉 Documentação do ecossistema sincronizada com sucesso!"

scaffold:
	if [ -z "$${DIR}" ]; then \
		echo "Uso: make scaffold DIR=<caminho> [NAME=<nome>] [DESC=<descrição>] [APP=<app>]"; \
		echo "Exemplo: make scaffold DIR=\"../Personal/Labs/NovoProjeto\" NAME=\"NovoProjeto\" DESC=\"Descrição do projeto\""; \
		exit 1; \
	fi; \
	_target="$${DIR}"; \
	_name="$${NAME:-$$(basename "$${_target}")}"; \
	_desc="$${DESC:-Repositório soberano $${_name}}"; \
	_app="$${APP:-$$(echo "$${_name}" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')}"; \
	echo "🏗️  Scaffolding novo repositório em $${_target}..."; \
	mkdir -p "$${_target}"; \
	cp -R Template/. "$${_target}/"; \
	(cd "$${_target}" && \
		git init > "/dev/null" 2>&1 || true; \
		if [ -f "./init.sh" ]; then \
			sh ./init.sh "$${_name}" "$${_desc}" "$${_app}" > "/dev/null" 2>&1 || true; \
			rm -f ./init.sh; \
		fi; \
		chmod 0755 .githooks/* .scripts/audit/*.py 2> "/dev/null" || true; \
		chmod 0644 *.md .editorconfig .gitattributes .prettierrc LICENSE 2> "/dev/null" || true; \
		git config core.hooksPath .githooks > "/dev/null" 2>&1 || true \
	); \
	echo "✅ Repositório $${_name} scaffolded com sucesso em $${_target}!"

install:
	echo "🚀 Instalando ecossistema nas posições canônicas do sistema operacional..."
	sh ./environment.sh install

update:
	echo "🔄 Atualizando ecossistema soberano no sistema operacional..."
	sh ./environment.sh update

bootstrap: install
deploy: install

strip:
	if [ -z "$${TARGET}" ]; then \
		echo "Uso: make strip TARGET=<diretorio>"; \
		echo "Exemplo: make strip TARGET=~/.emacs.d"; \
		exit 1; \
	fi; \
	if [ ! -d "$${TARGET}" ]; then \
		echo "❌ Diretório '$${TARGET}' não encontrado."; \
		exit 1; \
	fi; \
	echo "🧹 Aplicando purga Zero-Bloat em $${TARGET}..."; \
	rm -rf "$${TARGET}/.git"* "$${TARGET}/.agents" "$${TARGET}/docs"; \
	find "$${TARGET}" -maxdepth 1 -name "*.md" -delete 2> "/dev/null" || true; \
	echo "✅ $${TARGET} purgado para modo Standalone Limpo (Zero-Bloat)!"

### ================================
### CODE QUALITY & AUDITING
### ================================
prettier: format

format:
	echo "🎨 Formatando arquivos (MD, JSON, YAML, HTML, CSS) com Prettier recursivamente..."
	if command -v prettier > "/dev/null" 2>&1; then \
		find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
			-not -path "*/OSS/*" -not -path "*/.git/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" \
			-not -path "*/var/*" -not -path "*/tmp/*" -not -path "*/build/*" -not -path "*/dist/*" \
			-not -path "*/target/*" -not -path "*/.cache/*" -not -path "./Vault/*" \
			-exec prettier --write {} +; \
		if [ -d "Vault" ]; then \
			(cd Vault && find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
				-not -path "*/.git/*" -exec prettier --write {} + 2> "/dev/null" || true); \
		fi; \
		echo "✅ Todos os arquivos foram formatados recursivamente!"; \
	elif command -v npx > "/dev/null" 2>&1; then \
		find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
			-not -path "*/OSS/*" -not -path "*/.git/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" \
			-not -path "*/var/*" -not -path "*/tmp/*" -not -path "*/build/*" -not -path "*/dist/*" \
			-not -path "*/target/*" -not -path "*/.cache/*" -not -path "./Vault/*" \
			-exec npx --yes prettier --write {} +; \
		echo "✅ Todos os arquivos foram formatados recursivamente!"; \
	else \
		echo "⚠️ Prettier não encontrado no PATH."; \
	fi

lint-format:
	echo "🔍 Validando formatação (MD, JSON, YAML, HTML, CSS) com Prettier..."
	if command -v prettier > "/dev/null" 2>&1; then \
		find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
			-not -path "*/OSS/*" -not -path "*/.git/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" \
			-not -path "*/var/*" -not -path "*/tmp/*" -not -path "*/build/*" -not -path "*/dist/*" \
			-not -path "*/target/*" -not -path "*/.cache/*" -not -path "./Vault/*" \
			-exec prettier --check {} +; \
		if [ -d "Vault" ]; then \
			(cd Vault && find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
				-not -path "*/.git/*" -exec prettier --check {} + 2> "/dev/null" || true); \
		fi; \
		echo "✅ Formatação 100% em conformidade!"; \
	elif command -v npx > "/dev/null" 2>&1; then \
		find . -type f \( -name "*.md" -o -name "*.json" -o -name "*.jsonc" -o -name "*.yml" -o -name "*.yaml" -o -name "*.html" -o -name "*.css" \) \
			-not -path "*/OSS/*" -not -path "*/.git/*" -not -path "*/.venv/*" -not -path "*/node_modules/*" \
			-not -path "*/var/*" -not -path "*/tmp/*" -not -path "*/build/*" -not -path "*/dist/*" \
			-not -path "*/target/*" -not -path "*/.cache/*" -not -path "./Vault/*" \
			-exec npx --yes prettier --check {} +; \
		echo "✅ Formatação 100% em conformidade!"; \
	else \
		echo "ℹ️ Prettier não instalado; pulando validação."; \
	fi

audit:
	echo "🔍 [1/6] Auditando Setup..."
	python3 Setup/.scripts/audit/all.py
	echo "🔍 [2/6] Auditando Profile..."
	python3 Profile/.scripts/audit/all.py
	echo "🔍 [3/6] Validando sintaxe do Shell..."
	_sh=$$(command -v bash 2> "/dev/null" || command -v zsh 2> "/dev/null" || echo sh); \
	find Shell -name "*.sh" -not -path "*/.git/*" -exec "$$_sh" -n {} +
	echo "🔍 [4/6] Validando sintaxe do Vault..."
	_sh=$$(command -v bash 2> "/dev/null" || command -v zsh 2> "/dev/null" || echo sh); \
	"$$_sh" -n Vault/vault.sh
	echo "🔍 [5/6] Validando a Suíte de Editores (Sintaxe & Headless)..."
	(cd Editor/Helix && $(MAKE) test)
	_sh=$$(command -v bash 2> "/dev/null" || command -v zsh 2> "/dev/null" || echo sh); \
	find Editor -name "*.sh" -not -path "*/.git/*" -exec "$$_sh" -n {} + && echo "  ✅ Editor Shell Scripts: sintaxe POSIX OK"
	(cd Editor/NeoVim && $(MAKE) test)
	(cd Editor/Vim && $(MAKE) test)
	(cd Editor/Emacs && $(MAKE) test)
	echo "🔍 [6/6] Auditando Template..."
	python3 Template/.scripts/audit/all.py
	echo "🎉 Todas as auditorias estáticas foram aprovadas com sucesso!"

test:
	echo "🧪 Testando sintaxe de scripts do ecossistema..."
	_sh=$$(command -v bash 2> "/dev/null" || command -v zsh 2> "/dev/null" || echo sh); \
	for dir in Setup Vault Profile Editor; do \
		[ -d "$$dir" ] && find "$$dir" -name "*.sh" -not -path "*/.git/*" -exec "$$_sh" -n {} +; \
	done
	[ -d "Shell" ] && (cd Shell && $(MAKE) test)
	echo "✅ Sintaxe de todos os scripts está perfeita!"

fix-banners:
	echo "📏 Normalizando réguas de banners em Setup e Profile..."
	python3 Setup/.scripts/audit/banners.py --fix
	python3 Profile/.scripts/audit/banners.py --fix
	echo "✅ Réguas de banners normalizadas com sucesso!"

bench:
	sh Shell/benchmark.sh

doctor:
	sh Setup/.scripts/audit/doctor.sh

ci: test audit lint-format
	echo "⚡ Medindo benchmark de inicialização do Shell..."
	(cd Shell && sh .githooks/pre-commit)
	echo "🚀 Ecossistema 100% pronto para produção e commits!"

### ================================
### CLEANUP
### ================================
clean:
	echo "🧹 Limpando artefatos, caches e ambientes virtuais no Environment..."
	for r in $(ALL_REPOS); do \
		if [ -e "$$r/Makefile" ]; then \
			(cd "$$r" && $(MAKE) clean) 2> "/dev/null" || true; \
		fi; \
	done
	rm -rf .venv
	find . -type d -name "__pycache__" -exec rm -rf {} + 2> "/dev/null" || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2> "/dev/null" || true
	find . -type d -name ".ruff_cache" -exec rm -rf {} + 2> "/dev/null" || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2> "/dev/null" || true
	echo "✅ Limpeza do Environment concluída!"
