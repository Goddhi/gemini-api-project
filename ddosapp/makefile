SHELL = bash

# exit on failure
.SHELLFLAGS := -eu -o pipefail -c

# run make recipes in a single shell rather than a new shell per line
.ONESHELL:

# delete target file if make rule fails
.DELETE_ON_ERROR:

MAKEFLAGS += --warn-undefined-variables
# don't do anything unless told, make!
MAKEFLAGS += --no-builtin-rules

# use ">" as block character to prevent tab v spaces misrep in editors from messing with cmds
ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >


compose = ./local.docker-compose.yml

up: $(compose)
> docker compose -f $(compose)  up -d $(args)
.PHONY: up

down:
> docker compose -f $(compose) down $(args)
.PHONY: down

build: $(compose)
> docker compose -f $(compose) build $(args)
.PHONY: build

pull: $(compose)
> docker compose -f $(compose) pull $(args)
.PHONY: pull

ps:
> docker compose -f $(compose) ps
.PHONY: ps

exec:
> docker compose -f $(compose) exec portal_app $(args)
.PHONY: exec

logs:
> docker compose -f $(compose) logs $(args) -f
.PHONY: logs
	
mm:
> docker compose -f $(compose) exec portal_app alembic revision --autogenerate -m $(args)
.PHONY: mm

migrate:
> docker compose -f $(compose) exec portal_app alembic upgrade head

downgrade:
> docker compose -f $(compose) exec portal_app alembic downgrade $(args)
.PHONY: downgrade

ruff:
> docker compose -f $(compose) exec portal_app ruff check $(args) app
> docker compose -f $(compose) exec portal_app ruff format src
.PHONY: ruff

lint:
> docker compose -f $(compose) exec portal_app ruff check src --fix
.PHONY: lint

backup:
> docker compose -f $(compose) exec portal_app scripts/backup
.PHONY: backup

mount-docker-backup:
> docker cp portal_db$:/backups/$(args) ./$(args)
.PHONY: mount-docker-backup

restore:
> docker compose exec -f $(compose) portal_db scripts/restore $(args)
.PHONY: restore

.DEFAULT_GOAL := help
help: Makefile
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
