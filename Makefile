.POSIX:
.SILENT:

MAKEFLAGS += --no-print-directory -s

# ----------------------------------------------------------------
# Makefile: Universal Environment
# ----------------------------------------------------------------

.PHONY: help status audit sync pull test ci doctor clone hooks format lint-md bench uped upgit strip deploy

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
	sec "Sincronização & Submódulos:"; \
	cmd "clone"          "Inicializa submódulos públicos e clona o Vault defensivamente"; \
	cmd "pull"           "Atualiza todos os submódulos e repositórios com o GitHub"; \
	cmd "deploy"         "Implanta links canônicos no sistema (~/.shell, editores, profile)"; \
	cmd "sync"           "Sincroniza dotfiles declarativos e link unificado de skills de IA"; \
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
		echo "  ⚠️  Vault: clone via SSH falhou (chave SSH não autorizada ou repositório privado)."; \
		echo "      Se você é o mantenedor, configure sua chave SSH e execute:"; \
		echo "      git clone \"git@github.com:GabrielFrigo4/vault.git\" Vault"; \
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
		if [ -e "$$r/.git" ]; then \
			git -C $$r config core.hooksPath .githooks; \
			echo "  ✅ $$r: core.hooksPath -> .githooks"; \
		fi; \
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

sync:
	echo "🎨 Sincronizando dotfiles declarativos..."
	sh Profile/scripts/sync/sync-dotfiles.sh
	echo "🧠 Sincronizando skills de IA..."
	sh Profile/scripts/sync/sync-skills.sh

deploy:
	echo "🚀 Implantando o ecossistema nas posições canônicas do sistema..."
	echo ""
	echo "🐚 1. Shell -> ~/.shell..."
	mkdir -p "$${HOME}/.shell"
	ln -sfn "$$(pwd)/Shell" "$${HOME}/.shell"
	echo "  ✅ Shell implantado!"
	echo ""
	echo "📝 2. Suíte de Editores -> ~/.emacs.d, ~/.config/nvim, ~/.config/helix, ~/vimfiles..."
	mkdir -p "$${HOME}/.config"
	ln -sfn "$$(pwd)/Editor/Emacs" "$${HOME}/.emacs.d"
	ln -sfn "$$(pwd)/Editor/NeoVim" "$${HOME}/.config/nvim"
	ln -sfn "$$(pwd)/Editor/Helix" "$${HOME}/.config/helix"
	ln -sfn "$$(pwd)/Editor/Vim" "$${HOME}/vimfiles"
	ln -sfn "$$(pwd)/Editor/Vim" "$${HOME}/.vim"
	ln -sf "$$(pwd)/Editor/Vim/vimrc" "$${HOME}/.vimrc"
	echo "  ✅ Suíte de Editores implantada!"
	echo ""
	echo "🎨 3. Profile -> Dotfiles declarativos e Skills de IA..."
	sh Profile/scripts/sync/sync-dotfiles.sh
	sh Profile/scripts/sync/sync-skills.sh
	echo ""
	if [ -d "Vault/.git" ]; then \
		echo "🔐 4. Vault -> ~/.vault..."; \
		ln -sfn "$$(pwd)/Vault" "$${HOME}/.vault"; \
		echo "  ✅ Vault conectado!"; \
	fi
	echo "🎉 Implantação canônica concluída com sucesso!"

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
		find . -name "*.md" -not -path "*/.git/*" -exec prettier --write {} +; \
		echo "✅ Todos os arquivos Markdown foram formatados!"; \
	else \
		echo "⚠️ Prettier não encontrado no PATH."; \
	fi

lint-md:
	echo "🔍 Validando formatação de Markdown com Prettier..."
	if command -v prettier > "/dev/null" 2>&1; then \
		find . -name "*.md" -not -path "*/.git/*" -exec prettier --check {} +; \
		echo "✅ Formatação de Markdown 100% em conformidade!"; \
	else \
		echo "ℹ️ Prettier não instalado; pulando validação de Markdown."; \
	fi

audit:
	echo "🔍 [1/5] Auditando Setup..."
	python3 Setup/scripts/audit/all.py
	echo "🔍 [2/5] Auditando Profile..."
	python3 Profile/scripts/audit/all.py
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
	find Setup Shell Vault Profile Editor -name "*.sh" -not -path "*/.git/*" -exec sh -n {} +
	echo "✅ Sintaxe de todos os scripts está perfeita!"

bench:
	sh Shell/scripts/benchmark.sh

doctor:
	sh Setup/scripts/audit/doctor.sh

ci: test audit lint-md
	echo "⚡ Medindo benchmark de inicialização do Shell..."
	cd Shell && sh .githooks/pre-commit
	echo "🚀 Ecossistema 100% pronto para produção e commits!"
