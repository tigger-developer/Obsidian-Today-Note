.PHONY: build install lint release sync


build:
	./scripts/build.sh

install:
	./scripts/install.sh

lint:
	oxlint main.js

# VERSION=x.y.z releases that exact version instead of the next patch.
release: lint
	./scripts/release.sh

sync:
	git add -A
	@if git diff --cached --quiet; then \
		:; \
	else \
		git commit -m "$${COMMIT_MESSAGE:-chore: sync}"; \
	fi
	git pull
	git push
