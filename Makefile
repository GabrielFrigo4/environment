.POSIX:
.SILENT:

MAKEFLAGS += --no-print-directory -s

# ----------------------------------------------------------------
# Makefile: Universal Environment
# ----------------------------------------------------------------

.PHONY: help status audit sync-docs pull update test fix-banners ci doctor clone hooks format lint-md bench uped upgit strip install deploy bootstrap

REPOS     = Setup Shell Vault Profile
EDITORS   = Editor/Emacs Editor/Helix Editor/NeoVim Editor/Vim
ALL_REPOS = $(REPOS) $(EDITORS)

### ================================
### HELP & DOCUMENTATION
### ================================
help:
	cmd() { printf "    \033[36mmake %-22s\033[0m %s\n" "$$1" "$$2"; }; \
	sec() { printf "\n  \033[1;33m%s\033[0m\n" "$$1"; }; \
	sub() { printf "  \033[1;34m  ── %s ──\033[0m\n" "$$1"; }; \
	printf "\n  \033[1;37mUniversal Environment — Orquestrador Global do Ecossistema\033[0m\n"; \
	printf "  ============================================================\n"; \
	sec "Sincronização & Soberania:"; \
	cmd "clone"          "Inicializa submódulos públicos e clona o Vault defensivamente"; \
	cmd "pull"           "Atualiza todos os submódulos e repositórios com o GitHub"; \
	cmd "install"        "Clona e instala todos os repositórios em suas posições canônicas no SO"; \
	cmd "update"         "Atualiza todas as instalações soberanas no SO (Shell, Profile, Vault, Editores)"; \
	cmd "sync-docs"      "Propaga ENVIRONMENT.md e PRINCIPLES.md para todos os repositórios"; \
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
	cmd "format"         "Formata todos os arquivos Markdown com Prettier"; \
	cmd "lint-md"        "Valida formatação de Markdown sem alterar arquivos"; \
	cmd "ci"             "Executa pipeline completa de testes, auditoria e pre-commit"; \
	echo ""

### ================================
### BOOTSTRAP & SUBMODULES
### ================================
clone:
	echo "📦 Inicializando submódulos públicos (Core + Editores)..."
	git submodule update --init --recursive
	echo "✅ Submódulos públicos inicializados!"
	echo ""
	echo "🔐 Tentando clonar o Vault (repositório privado via SSH)..."
	if [ -e "Vault/.git" ]; then \
		echo "  ℹ️  Vault já clonado."; \
	elif git clone "git@github.com:GabrielFrigo4/vault.git" Vault 2> "/dev/null"; then \
		echo "  ✅ Vault clonado com sucesso!"; \
	else \
		echo "  ⚠️  Vault: clone via SSH falhou (configure sua chave SSH para clonar Vault)."; \
	fi
	echo ""
	echo "🎉 Ecossistema pronto!"

### ================================
### GIT HOOKS & STATUS
### ================================
hooks:
	echo "🪝 Configurando ganchos Git (.githooks) em todos os repositórios..."
	chmod 0755 .githooks/pre-commit Setup/.githooks/pre-commit Profile/.githooks/pre-commit Shell/.githooks/pre-commit Editor/*/.githooks/pre-commit 2> "/dev/null" || true
	chmod 0700 Vault/.githooks/pre-commit 2> "/dev/null" || true
	git config core.hooksPath .githooks 2> "/dev/null" || true
	echo "  ✅ Environment: core.hooksPath -> .githooks"
	for r in $(ALL_REPOS); do \
		[ -e "$$r/.git" ] && git -C $$r config core.hooksPath .githooks && echo "  ✅ $$r: core.hooksPath -> .githooks"; \
	done

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
	find . -maxdepth 3 -name ".git" 2> "/dev/null" | while read -r g; do \
		d="$$(dirname "$$g")"; \
		echo "# ----------------------------------------------------------------"; \
		echo "# $$d"; \
		echo "# ----------------------------------------------------------------"; \
		git -C "$$d" pull --ff-only 2> "/dev/null" || git -C "$$d" pull || echo "⚠️  Falha ao atualizar $$d"; \
		echo ""; \
	done
	echo "✅ Repositórios Git atualizados!"

pull:
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

sync-docs:
	echo "📖 Sincronizando documentação canônica (ENVIRONMENT.md & PRINCIPLES.md)..."
	for r in $(ALL_REPOS); do \
		if [ -d "$$r" ]; then \
			cp ENVIRONMENT.md "$$r/ENVIRONMENT.md"; \
			cp PRINCIPLES.md "$$r/PRINCIPLES.md"; \
			echo "  ✅ $$r: documentação sincronizada"; \
		fi; \
	done
	if [ -d "Vault" ]; then \
		cp ENVIRONMENT.md Vault/ENVIRONMENT.md; \
		cp PRINCIPLES.md Vault/PRINCIPLES.md; \
		echo "  ✅ Vault: documentação sincronizada"; \
	fi
	echo "🎉 Documentação canônica propagada para todos os repositórios!"

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
format:
	echo "🎨 Formatando arquivos Markdown com Prettier..."
	if command -v prettier > "/dev/null" 2>&1; then \
		find . -name "*.md" -not -path "*/.git/*" -not -path "*/var/*" -not -path "./Vault/*" -exec prettier --write {} +; \
		if [ -d "Vault" ]; then \
			(cd Vault && find . -name "*.md" -not -path "*/.git/*" -exec prettier --write {} + 2> "/dev/null" || true); \
		fi; \
		echo "✅ Todos os arquivos Markdown foram formatados!"; \
	else \
		echo "⚠️ Prettier não encontrado no PATH."; \
	fi

lint-md:
	echo "🔍 Validando formatação de Markdown com Prettier..."
	if command -v prettier > "/dev/null" 2>&1; then \
		find . -name "*.md" -not -path "*/.git/*" -not -path "*/var/*" -not -path "./Vault/*" -exec prettier --check {} +; \
		if [ -d "Vault" ]; then \
			(cd Vault && find . -name "*.md" -not -path "*/.git/*" -exec prettier --check {} + 2> "/dev/null" || true); \
		fi; \
		echo "✅ Formatação de Markdown 100% em conformidade!"; \
	else \
		echo "ℹ️ Prettier não instalado; pulando validação de Markdown."; \
	fi

audit:
	echo "🔍 [1/5] Auditando Setup..."
	python3 Setup/scripts/audit/all.py
	echo "🔍 [2/5] Auditando Profile..."
	python3 Profile/audit/all.py
	echo "🔍 [3/5] Validando sintaxe do Shell..."
	find Shell -name "*.sh" -not -path "*/.git/*" -exec sh -n {} +
	echo "🔍 [4/5] Validando sintaxe do Vault..."
	sh -n Vault/vault.sh
	echo "🔍 [5/5] Validando a Suíte de Editores (Sintaxe & Headless)..."
	$(MAKE) -C Editor/Helix test
	find Editor -name "*.sh" -not -path "*/.git/*" -exec sh -n {} + && echo "  ✅ Editor Shell Scripts: sintaxe POSIX OK"
	$(MAKE) -C Editor/NeoVim test
	$(MAKE) -C Editor/Vim test
	$(MAKE) -C Editor/Emacs test
	echo "🎉 Todas as auditorias estáticas foram aprovadas com sucesso!"

test:
	echo "🧪 Testando sintaxe de scripts do ecossistema..."
	for dir in Setup Vault Profile Editor; do \
		[ -d "$$dir" ] && find "$$dir" -name "*.sh" -not -path "*/.git/*" -exec sh -n {} +; \
	done
	[ -d "Shell" ] && $(MAKE) -C Shell test
	echo "✅ Sintaxe de todos os scripts está perfeita!"

fix-banners:
	echo "📏 Normalizando réguas de banners em Setup e Profile..."
	python3 Setup/scripts/audit/banners.py --fix
	python3 Profile/audit/banners.py --fix
	echo "✅ Réguas de banners normalizadas com sucesso!"

bench:
	sh Shell/benchmark.sh

doctor:
	sh Setup/scripts/audit/doctor.sh

ci: test audit lint-md
	echo "⚡ Medindo benchmark de inicialização do Shell..."
	(cd Shell && sh .githooks/pre-commit)
	echo "🚀 Ecossistema 100% pronto para produção e commits!"
