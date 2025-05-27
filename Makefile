.PHONY: build up down restart logs shell

build:
	docker-compose build

up:
	docker-compose up -d

start: build up
	@echo "Sistema iniciado em background. Acesse http://localhost:3000"

down:
	docker-compose down

restart: down up

logs:
	docker-compose logs -f

shell:
	docker-compose exec web bash
