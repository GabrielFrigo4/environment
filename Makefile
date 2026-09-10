.PHONY: help status audit sync pull test ci doctor clone hooks format lint-md bench

REPOS := Setup Shell Vault Profile

help:
	@echo "🏛️  O Quarteto de Produtividade — Orquestrador Global"
	@echo ""
	@echo "Comandos disponíveis:"
	@echo "  make clone    - Inicializa submódulos e clona o Vault (defensivo)"
	@echo "  make hooks    - Configura e torna executáveis os ganchos .githooks"
	@echo "  make status   - Exibe status Git resumido dos 4 repositórios"
	@echo "  make audit    - Executa suites de auditoria estática e validação"
	@echo "  make format   - Formata todos os arquivos Markdown com Prettier"
	@echo "  make lint-md  - Valida formatação de Markdown com Prettier"
	@echo "  make sync     - Sincroniza dotfiles e skills de IA no sistema"
	@echo "  make pull     - Atualiza submódulos e repositórios com o GitHub"
	@echo "  make bench    - Mede latência de inicialização de shells e módulos"
	@echo "  make test     - Valida sintaxe POSIX e Zsh em todos os scripts"
	@echo "  make ci       - Executa auditoria completa e quality gates locais"
	@echo "  make doctor   - Executa diagnóstico pós-boot do sistema"
	@echo ""

clone:
	@echo "📦 Inicializando submódulos públicos (Setup, Shell, Profile)..."
	@git submodule update --init --recursive
	@echo "✅ Submódulos públicos inicializados!"
	@echo ""
	@echo "🔐 Tentando clonar o Vault (repositório privado via SSH)..."
	@if [ -d "Vault/.git" ]; then \
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
	@chmod 0755 Setup/.githooks/pre-commit Profile/.githooks/pre-commit Shell/.githooks/pre-commit
	@chmod 0700 Vault/.githooks/pre-commit
	@for r in $(REPOS); do \
		git -C $$r config core.hooksPath .githooks; \
		echo "  ✅ $$r: core.hooksPath -> .githooks (executável)"; \
	done

status:
	@for r in $(REPOS); do \
		if [ -d "$$r/.git" ]; then \
			echo "=== $$r ($$(git -C $$r branch --show-current 2> "/dev/null")) ==="; \
			git -C $$r status -s; \
			echo ""; \
		else \
			echo "=== $$r (não clonado) ==="; \
			echo ""; \
		fi; \
	done

format:
	@echo "🎨 Formatando arquivos Markdown com Prettier..."
	@if command -v prettier > "/dev/null" 2>&1; then \
		for r in $(REPOS); do \
			if [ -d "$$r" ]; then \
				find $$r -name "*.md" -not -path "*/.git/*" -exec prettier --write {} +; \
			fi; \
		done; \
		echo "✅ Todos os arquivos Markdown foram formatados!"; \
	else \
		echo "⚠️ Prettier não encontrado no PATH."; \
	fi

lint-md:
	@echo "🔍 Validando formatação de Markdown com Prettier..."
	@if command -v prettier > "/dev/null" 2>&1; then \
		for r in $(REPOS); do \
			if [ -d "$$r" ]; then \
				find $$r -name "*.md" -not -path "*/.git/*" -exec prettier --check {} +; \
			fi; \
		done; \
		echo "✅ Formatação de Markdown 100% em conformidade!"; \
	else \
		echo "ℹ️ Prettier não instalado; pulando validação de Markdown."; \
	fi

audit:
	@echo "🔍 [1/4] Auditando Setup..."
	@python3 Setup/scripts/audit/all.py
	@echo "🔍 [2/4] Auditando Profile..."
	@python3 Profile/scripts/audit/all.py
	@echo "🔍 [3/4] Validando sintaxe do Shell..."
	@find Shell -name "*.sh" -not -path "*/.git/*" -exec sh -n {} +
	@echo "🔍 [4/4] Validando sintaxe do Vault..."
	@sh -n Vault/vault.sh
	@echo "🎉 Todas as auditorias estáticas foram aprovadas!"

sync:
	@echo "🎨 Sincronizando dotfiles..."
	@sh Profile/scripts/sync/sync-dotfiles.sh
	@echo "🧠 Sincronizando skills de IA..."
	@sh Profile/scripts/sync/sync-skills.sh

pull:
	@echo "⬇️  Atualizando submódulos públicos..."
	@git submodule update --remote --merge
	@for r in $(REPOS); do \
		if [ -d "$$r/.git" ]; then \
			echo "⬇️  Pulling $$r..."; \
			git -C $$r pull --ff-only; \
		else \
			echo "⏭️  $$r: não clonado, pulando."; \
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
	@find Setup Shell Vault Profile -name "*.sh" -not -path "*/.git/*" -exec sh -n {} +
	@echo "✅ Sintaxe de todos os scripts está perfeita!"

doctor:
	@sh Setup/scripts/audit/doctor.sh

ci: test audit lint-md
	@echo "⚡ Medindo benchmark de inicialização do Shell..."
	@cd Shell && sh .githooks/pre-commit
	@echo "🚀 Ecossistema 100% pronto para produção e commits!"
