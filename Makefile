# Make commands. Ex: make build; make dev; make run; etc.
build:
		docker-compose build

dev:
		docker-compose -f docker-compose.yml -f docker-compose.test.yml up -d

run:
		docker-compose up -d

# Run pending migrations
migrate:
		docker-compose exec web bundle exec rails db:migrate

# Rollback DB
rollback:
		docker-compose exec web bundle exec rails db:rollback

logs:
		docker-compose logs -t --tail 2000 web

# Stop containers
stop:
		docker-compose stop

status:
		docker-compose ps

connect:
		docker-compose exec web sh
