# Makefile

# The Docker compose command
DC=docker-compose

# The Docker command
D=docker

# The pytest command
PYTEST=pytest -v

# The name of the Docker container
CONTAINER=RAG_BOT_FASTAPI


########################
### Primary Commands ###
########################

# The build command
.PHONY: build
build: check-key ## Build the Docker images
	$(DC) build

# The run command
.PHONY: run
start up run: check-key ## Run the application
	$(DC) up

# The test command
.PHONY: test
test: ## Run the tests
	$(D) exec -t $(CONTAINER) $(PYTEST)

# The stop command
.PHONY: down
down stop: ## Stop the application
	$(DC) down

#################
### Utilities ###
#################

# The check-key command
.PHONY: check-key
check-key: ## Check if key.env file exists and contains the required keys
	@if [ ! -f key.env ]; then echo "key.env file does not exist"; exit 1; fi
	@if ! grep -q "OPENAI_API_KEY=" key.env; then echo "OPENAI_API_KEY not found in key.env"; exit 1; fi
	@if ! grep -q "SERPAPI_API_KEY=" key.env; then echo "SERPAPI_API_KEY not found in key.env"; exit 1; fi

# The clean command
.PHONY: clean
clean: ## Clean up the Docker environment
	$(D) system prune -a --volumes

# The cli command
.PHONY: cli
cli: ## Connect to the running API container
	$(D) exec $(CONTAINER) /bin/sh

# The help command
.PHONY: help
help: ## Display this help message
	@echo "Usage: make [TARGET] ..."
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)