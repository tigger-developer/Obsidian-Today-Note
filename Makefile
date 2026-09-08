.PHONY: build install lint test sync

build:
	npm run build

install: build
	./scripts/install.sh

lint:
	oxlint src/main.ts
	biome check src/main.ts esbuild.config.mjs

test:
	npm run typecheck

sync:
	git add -A
	@if git diff --cached --quiet; then \
		:; \
	else \
		git commit -m "$${COMMIT_MESSAGE:-chore: sync}"; \
	fi
	git pull
	git push
