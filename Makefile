# Variables
DOCKER_COMPOSE = docker compose

.PHONY: help build up down logs logs-app logs-tunnel restart clean install stop status shell dev prod

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build the Docker images
	$(DOCKER_COMPOSE) build

install: build ## Build the Docker image (alias for build)

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
