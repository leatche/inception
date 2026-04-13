# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tcherepoff <tcherepoff@student.42.fr>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/09 14:26:10 by tcherepoff        #+#    #+#              #
#    Updated: 2026/04/09 14:26:11 by tcherepoff       ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

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
	@sudo mkdir -p $(DATA_DIR)/mariadb
	@sudo mkdir -p $(DATA_DIR)/wordpress
	@sudo chown -R $(USER):$(USER) $(DATA_DIR)

clean:
	$(COMPOSE) down --volumes --rmi all

fclean: clean
	@sudo rm -rf $(DATA_DIR)
	@docker system prune -af --volumes

re: fclean all

.PHONY: all up down stop start restart logs ps create_dirs clean fclean re
