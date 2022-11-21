bash:
	docker-compose run --rm --service-ports web /bin/bash

bash-container:
	docker exec -it taskmanager-web-1 /bin/bash

run:
	docker-compose up

eslint:
	docker-compose run --rm web bash -c "yarn lint"

eslint!:
	docker-compose run --rm web bash -c "yarn lint --fix"

rubocop:
	docker-compose run --rm web bash -c "bundle exec rubocop"

rubocop!:
	docker-compose run --rm web bash -c "bundle exec rubocop -A"