NAME = transcendence
COMPOSE = ${PWD}/docker-compose.yml

ENV_DIRS = ${PWD}/backend \
			${PWD}

all: up

runner:
	@chmod +x ./theJoke.sh
	@./theJoke.sh

# Generate a self-signed SSL certificate in env/nginx
prepare: runner
	@mkdir -p ${PWD}/nginx/ssl
	@mkdir -p ${PWD}/backend/ssl
	@mkdir -p ${PWD}/frontend_ui/ssl
	@openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout ${PWD}/nginx/ssl/localhost.key \
		-out ${PWD}/nginx/ssl/localhost.crt \
		-subj "/C=AT/ST=W/L=W/O=42/OU=42k/CN=trans/UID=trans"
	@for dir in ${ENV_DIRS}; do \
			if [ -d "$$dir" ]; then \
				if [ "$$dir" = "${PWD}/backend" ]; then \
					echo "Special handling for backend directory"; \
					cat ${PWD}/env/backend/.env > ${PWD}/backend/.env; \
					IP_ADDR=$$(hostname -I | awk '{print $$1}'); \
					echo "API_BASE_URL=https://$${IP_ADDR}/api" >> ${PWD}/backend/.env; \
					echo "WSS=wss://$${IP_ADDR}/api" >> ${PWD}/backend/.env; \
					cat ${PWD}/env/backend/.env > ${PWD}/frontend_ui/.env; \
					echo "API_BASE_URL=https://$${IP_ADDR}/api" >> ${PWD}/frontend_ui/.env; \
					echo "WSS=wss://$${IP_ADDR}/api" >> ${PWD}/frontend_ui/.env; \
					cat ${PWD}/nginx/ssl/localhost.key > ${PWD}/backend/ssl/localhost.key; \
					cat ${PWD}/nginx/ssl/localhost.crt > ${PWD}/backend/ssl/localhost.crt; \
					cat ${PWD}/nginx/ssl/localhost.key > ${PWD}/frontend_ui/ssl/localhost.key; \
					cat ${PWD}/nginx/ssl/localhost.crt > ${PWD}/frontend_ui/ssl/localhost.crt; \
				fi; \
				if [ "$$dir" = "${PWD}" ]; then \
					echo "Special handling for root directory"; \
					cat ${PWD}/env/all/.env > ${PWD}/.env; \
					IP_ADDR=$$(hostname -I | awk '{print $$1}'); \
					echo "API_BASE_URL=https://$${IP_ADDR}/api" >> ${PWD}/.env; \
				fi; \
			fi; \
	done

# Start services
up: prepare build
	@docker compose -f $(COMPOSE) up -d --force-recreate --remove-orphans

# Build services
build:
	@docker compose build

# Stop services
down:
	@docker compose down

# View logs
logs:
	docker compose logs -f

# Show running containers
ps:
	docker compose ps

# Remove stopped containers
clean:
	docker compose down --remove-orphans
	docker system prune -f
	
# Remove everything including volumes
fclean:
	@docker compose down -v
	@docker volume prune -f
	@docker system prune -af
	@cat ${PWD}/env/all/.null > ${PWD}/backend/.env
	@cat ${PWD}/env/all/.null > ${PWD}/frontend_ui/.env
	@cat ${PWD}/env/all/.null > ${PWD}/.env
	@rm -rf ${PWD}/nginx/ssl
	@rm -rf ${PWD}/backend/ssl
	@rm -rf ${PWD}/frontend_ui/ssl

# Rebuild everything from scratch
re: fclean all

.PHONY: all clean fclean re up down build logs ps prepare