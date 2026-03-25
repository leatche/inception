LOGIN		:= ltcherep
DATA_DIR	:= /home/$(LOGIN)/data
COMPOSE		:= docker compose -f srcs/docker-compose.yml --env-file srcs/.env

all: up

up: create_dirs
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

restart:
	$(COMPOSE) restart

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

create_dirs:
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress

clean:
	$(COMPOSE) down --volumes --rmi all

fclean: clean
	@sudo rm -rf $(DATA_DIR)
	@docker system prune -af --volumes

re: fclean all

.PHONY: all up down stop start restart logs ps create_dirs clean fclean re
