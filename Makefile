NAME        = Inception
DOCKER_COMPOSE_FILE = srcs/docker-compose.yaml

# Colors
DEF_COLOR = \033[0;39m
GRAY = \033[0;90m
RED = \033[0;91m
GREEN = \033[0;92m
YELLOW = \033[0;93m
BLUE = \033[0;94m
MAGENTA = \033[0;95m
CYAN = \033[0;96m
WHITE = \033[0;97m

all: up

up:
			@docker-compose -f $(DOCKER_COMPOSE_FILE) up --build
			@echo "$(GREEN)Docker Compose up and running!$(DEF_COLOR)"

down:
			@docker-compose -f $(DOCKER_COMPOSE_FILE) down
			@echo "$(CYAN)Docker Compose stopped!$(DEF_COLOR)"

ps:
			@docker-compose -f $(DOCKER_COMPOSE_FILE) ps

logs:
			@docker-compose -f $(DOCKER_COMPOSE_FILE) logs -f

clean:
			@docker-compose -f $(DOCKER_COMPOSE_FILE) down -v --rmi all --remove-orphans
			@echo "$(BLUE)Cleaned up Docker containers, volumes, and images!$(DEF_COLOR)"

re:         clean up
			@echo "$(GREEN)Cleaned and rebuilt Docker Compose setup for $(NAME)!$(DEF_COLOR)"


test:		up
			@docker-compose -f $(DOCKER_COMPOSE_FILE) exec $(NAME) sh -c "./$(NAME)"

.PHONY:     all up down logs clean re n r e test
