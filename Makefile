# Variables
DOCKER_COMPOSE = docker compose

.PHONY: help build up down logs logs-app logs-tunnel restart clean install stop status shell dev prod setup-env

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup-env: ## Setup environment files from examples
	@echo "Setting up environment files..."
	@if [ ! -f .env.app ]; then \
		cp .env.app.example .env.app && echo "Created .env.app from example"; \
	else \
		echo ".env.app already exists, skipping"; \
	fi
	@if [ ! -f .env.cloudflare ]; then \
		cp .env.cloudflare.example .env.cloudflare && echo "Created .env.cloudflare from example"; \
	else \
		echo ".env.cloudflare already exists, skipping"; \
	fi
	@echo "Environment setup complete. Please update the files with your actual values."

build: ## Build the Docker images
	$(DOCKER_COMPOSE) build

install: setup-env build ## Setup environment and build the Docker image

up: ## Start all services in detached mode
	$(DOCKER_COMPOSE) up -d

down: ## Stop all services
	$(DOCKER_COMPOSE) down

stop: down ## Stop all services (alias for down)

logs: ## Show logs for all services
	$(DOCKER_COMPOSE) logs -f

logs-app: ## Show logs for app service only
	$(DOCKER_COMPOSE) logs -f app

logs-tunnel: ## Show logs for cloudflared service only
	$(DOCKER_COMPOSE) logs -f cloudflared

restart: down up ## Restart all services

status: ## Show running services status
	$(DOCKER_COMPOSE) ps

shell: ## Open shell in app container
	$(DOCKER_COMPOSE) run app sh

clean: ## Clean up containers, networks, and images
	$(DOCKER_COMPOSE) down -v --remove-orphans
	docker system prune -f

dev: build ## Development: build and start with logs
	$(DOCKER_COMPOSE) up

prod: ## Production: start services in background
	$(DOCKER_COMPOSE) up -d
	@echo "Services started. Check logs with 'make logs'"
