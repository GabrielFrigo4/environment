.PHONY: help status audit sync pull test ci doctor clone hooks format lint-md bench uped editors-status editors-hooks

REPOS := Setup Shell Vault Profile
EDITORS := Editor/Emacs Editor/Helix Editor/NeoVim Editor/Vim
ALL_REPOS := $(REPOS) $(EDITORS)

help:
	@echo "🏛️  O Quarteto de Produtividade & Suíte de Editores — Orquestrador Global"
	@echo ""
	@echo "Comandos disponíveis:"
	@echo "  make clone    - Inicializa submódulos e clona o Vault (defensivo)"
	@echo "  make hooks    - Configura e torna executáveis os ganchos .githooks em todos os repos"
	@echo "  make status   - Exibe status Git resumido de todo o ecossistema (Core + Editores)"
	@echo "  make uped     - Atualiza os 4 repositórios da Suíte de Editores com o GitHub"
	@echo "  make audit    - Executa suites de auditoria estática e validação em todos os repos"
	@echo "  make format   - Formata todos os arquivos Markdown com Prettier"
	@echo "  make lint-md  - Valida formatação de Markdown com Prettier"
	@echo "  make sync     - Sincroniza dotfiles, editores e skills de IA no sistema"
	@echo "  make pull     - Atualiza submódulos e repositórios com o GitHub"
	@echo "  make bench    - Mede latência de inicialização de shells e módulos"
	@echo "  make test     - Valida sintaxe POSIX e Zsh em todos os scripts"
	@echo "  make ci       - Executa auditoria completa e quality gates locais"
	@echo "  make doctor   - Executa diagnóstico pós-boot do sistema"
	@echo ""

clone:
	@echo "📦 Inicializando submódulos públicos (Core + Editores)..."
	@git submodule update --init --recursive
	@echo "✅ Submódulos públicos inicializados!"
	@echo ""
	@echo "🔐 Tentando clonar o Vault (repositório privado via SSH)..."
	@if [ -e "Vault/.git" ]; then \
		echo "  ℹ️  Vault já clonado."; \
	elif git clone "git@github.com:GabrielFrigo4/vault.git" Vault 2> "/dev/null"; then \
		echo "  ✅ Vault clonado com sucesso!"; \
	else \
		echo "  ⚠️  Vault: clone via SSH falhou (chave SSH não autorizada ou repositório privado)."; \
		echo "      Se você é o mantenedor, configure sua chave SSH e execute:"; \
		echo "      git clone \"git@github.com:GabrielFrigo4/vault.git\" Vault"; \
	fi
	@echo ""
	@echo "🎉 Ecossistema pronto!"

hooks:
	@echo "🪝 Configurando ganchos Git (.githooks) em todos os repositórios..."
	@chmod 0755 .githooks/pre-commit Setup/.githooks/pre-commit Profile/.githooks/pre-commit Shell/.githooks/pre-commit Editor/*/.githooks/pre-commit 2> "/dev/null" || true
	@chmod 0700 Vault/.githooks/pre-commit 2> "/dev/null" || true
	@git config core.hooksPath .githooks 2> "/dev/null" || true
	@echo "  ✅ Environment: core.hooksPath -> .githooks"
	@for r in $(ALL_REPOS); do \
		if [ -e "$$r/.git" ]; then \
			git -C $$r config core.hooksPath .githooks; \
			echo "  ✅ $$r: core.hooksPath -> .githooks"; \
		fi; \
	done

status:
	@echo "=== 🏛️ O Quarteto de Infraestrutura ==="
	@for r in $(REPOS); do \
		if [ -e "$$r/.git" ]; then \
			echo "[$$(git -C $$r branch --show-current 2> "/dev/null" || echo "detached")] $$r:"; \
			git -C $$r status -s; \
			echo ""; \
		else \
			echo "[não clonado] $$r"; \
			echo ""; \
		fi; \
	done
	@echo "=== 📝 A Suíte de Editores ==="
	@for ed in $(EDITORS); do \
		if [ -e "$$ed/.git" ]; then \
			echo "[$$(git -C $$ed branch --show-current 2> "/dev/null" || echo "detached")] $$ed:"; \
			git -C $$ed status -s; \
			echo ""; \
		else \
			echo "[não clonado] $$ed"; \
			echo ""; \
		fi; \
	done

uped:
	@echo "⬇️  Atualizando a Suíte de Editores (git pull --ff-only)..."
	@for ed in $(EDITORS); do \
		if [ -e "$$ed/.git" ]; then \
			echo "⬇️  Pulling $$ed..."; \
			git -C $$ed pull --ff-only || echo "⚠️  $$ed: git pull falhou."; \
		else \
			echo "⏭️  $$ed: não inicializado, pulando."; \
		fi; \
	done
	@echo "✅ Suíte de Editores atualizada!"

format:
	@echo "🎨 Formatando arquivos Markdown com Prettier..."
	@if command -v prettier > "/dev/null" 2>&1; then \
		find . -name "*.md" -not -path "*/.git/*" -exec prettier --write {} +; \
		echo "✅ Todos os arquivos Markdown foram formatados!"; \
	else \
		echo "⚠️ Prettier não encontrado no PATH."; \
	fi

lint-md:
	@echo "🔍 Validando formatação de Markdown com Prettier..."
	@if command -v prettier > "/dev/null" 2>&1; then \
		find . -name "*.md" -not -path "*/.git/*" -exec prettier --check {} +; \
		echo "✅ Formatação de Markdown 100% em conformidade!"; \
	else \
		echo "ℹ️ Prettier não instalado; pulando validação de Markdown."; \
	fi

audit:
	@echo "🔍 [1/5] Auditando Setup..."
	@python3 Setup/scripts/audit/all.py
	@echo "🔍 [2/5] Auditando Profile..."
	@python3 Profile/scripts/audit/all.py
	@echo "🔍 [3/5] Validando sintaxe do Shell..."
	@find Shell -name "*.sh" -not -path "*/.git/*" -exec sh -n {} +
	@echo "🔍 [4/5] Validando sintaxe do Vault..."
	@sh -n Vault/vault.sh
	@echo "🔍 [5/5] Validando a Suíte de Editores (Sintaxe & Headless)..."
	@python3 -c "import tomllib; tomllib.loads(open('Editor/Helix/config.toml').read()); tomllib.loads(open('Editor/Helix/languages.toml').read())" && echo "  ✅ Helix: TOML 100% válido"
	@find Editor -name "*.sh" -not -path "*/.git/*" -exec sh -n {} + && echo "  ✅ Editor Shell Scripts: sintaxe POSIX OK"
	@if command -v nvim > "/dev/null" 2>&1; then nvim --headless -u Editor/NeoVim/init.lua -c "quit" > "/dev/null" 2>&1 && echo "  ✅ NeoVim: headless OK"; fi
	@if command -v vim > "/dev/null" 2>&1; then vim -u Editor/Vim/vimrc -es -c "quit" > "/dev/null" 2>&1 && echo "  ✅ Vim: headless OK"; fi
	@if command -v emacs > "/dev/null" 2>&1; then emacs -Q --batch -l Editor/Emacs/early-init.el -l Editor/Emacs/init.el --eval '(message "OK")' > "/dev/null" 2>&1 && echo "  ✅ Emacs: batch OK"; fi
	@echo "🎉 Todas as auditorias estáticas foram aprovadas com sucesso!"

sync:
	@echo "🎨 Sincronizando dotfiles e editores..."
	@sh Profile/scripts/sync/sync-dotfiles.sh
	@echo "🧠 Sincronizando skills de IA..."
	@sh Profile/scripts/sync/sync-skills.sh

pull:
	@echo "⬇️  Atualizando submódulos públicos..."
	@git submodule update --remote --merge
	@for r in $(ALL_REPOS); do \
		if [ -e "$$r/.git" ]; then \
			echo "⬇️  Pulling $$r..."; \
			git -C $$r pull --ff-only || echo "⚠️  $$r: pull falhou."; \
		fi; \
	done
	@if [ -d "$${OSH:-$$HOME/.oh-my-bash}" ]; then \
		echo "⬇️  Pulling Oh-My-Bash..."; \
		git -C "$${OSH:-$$HOME/.oh-my-bash}" pull --ff-only 2> "/dev/null" || true; \
	fi
	@if [ -d "$${ZSH:-$$HOME/.oh-my-zsh}" ]; then \
		echo "⬇️  Pulling Oh-My-Zsh..."; \
		git -C "$${ZSH:-$$HOME/.oh-my-zsh}" pull --ff-only 2> "/dev/null" || true; \
	fi

bench:
	@sh Shell/scripts/benchmark.sh

test:
	@echo "🧪 Testando sintaxe de scripts do ecossistema..."
	@find Setup Shell Vault Profile Editor -name "*.sh" -not -path "*/.git/*" -exec sh -n {} +
	@echo "✅ Sintaxe de todos os scripts está perfeita!"

doctor:
	@sh Setup/scripts/audit/doctor.sh

ci: test audit lint-md
	@echo "⚡ Medindo benchmark de inicialização do Shell..."
	@cd Shell && sh .githooks/pre-commit
	@echo "🚀 Ecossistema 100% pronto para produção e commits!"
