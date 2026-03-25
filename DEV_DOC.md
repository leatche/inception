# Developer Documentation

## Environment Setup From Scratch
Prerequisites:
- Linux VM
- Docker Engine + Docker Compose plugin
- `make`

Project files:
- Compose file: `srcs/docker-compose.yml`
- Environment file: `srcs/.env`
- Secrets files:
  - `secrets/db_root_password.txt`
  - `secrets/db_password.txt`
  - `secrets/admin_password.txt`

Host directories used for persistent data:
- `/home/ltcherep/data/mariadb`
- `/home/ltcherep/data/wordpress`

The Makefile creates these directories automatically in `make up`.

## Build And Launch
Standard workflow from repository root:

```bash
make          # build + up
make down     # stop and remove containers/network
make re       # full rebuild
```

Equivalent Compose command:

```bash
docker compose -f srcs/docker-compose.yml --env-file srcs/.env up -d --build
```

## Container And Volume Management
Useful commands:

```bash
make ps
make logs
make stop
make start
docker compose -f srcs/docker-compose.yml --env-file srcs/.env exec -T wordpress sh
docker compose -f srcs/docker-compose.yml --env-file srcs/.env exec -T mariadb sh
```

Cleanup commands:

```bash
make clean    # removes containers, volumes, images for the stack
make fclean   # clean + removes /home/ltcherep/data
```

## Data Persistence
Persistence is provided by Docker named volumes:
- `mariadb_data` -> `/var/lib/mysql`
- `wordpress_data` -> `/var/www/wordpress`

These named volumes are configured with `local` driver options so data is stored on host under:
- `/home/ltcherep/data/mariadb`
- `/home/ltcherep/data/wordpress`

Data survives container recreation and image rebuilds.
