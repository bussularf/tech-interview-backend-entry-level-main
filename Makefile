.PHONY: bash down build up test

bash:
	docker exec -it --user root web bash

down:
	docker compose down

build:
	docker compose build

up:
	docker compose up

test:
	docker compose run test
