.PHONY: install lint sync


install:
	./scripts/install.sh

lint:
	oxlint main.js

sync:
	git add -A
	@if git diff --cached --quiet; then \
		:; \
	else \
		git commit -m "$${COMMIT_MESSAGE:-chore: sync}"; \
	fi
	git pull
	git push
