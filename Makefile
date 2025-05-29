.PHONY: build up down restart logs shell

build:
	docker-compose build

up:
	docker-compose up -d

start: bundle-docker build up
	@echo "Sistema iniciado em background. Acesse http://localhost:3000"

down:
	docker-compose down

restart: down up

logs:
	docker-compose logs -f

shell:
	docker-compose exec web bash

bundle-docker:
	docker run --rm -v "$(shell pwd)":/app -w /app ruby:3.2.8 bash -c "apt-get update && apt-get install -y build-essential git libpq-dev pkg-config libyaml-dev && gem install bundler && bundle config set frozen false && bundle install"

check:
	docker-compose run --rm web bundle exec rspec
