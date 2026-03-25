*This project has been created as part of the 42 curriculum by ltcherep.*

## Description

Inception is a system administration project that sets up a small web infrastructure using Docker. The stack runs NGINX, WordPress (with php-fpm), and MariaDB — each in its own container, orchestrated via Docker Compose. All traffic enters through NGINX on port 443 with TLS encryption.

### Design Choices

- **Base image**: Debian Bookworm (penultimate stable) for all three services, chosen for its package availability and stability.
- **Secrets management**: Docker secrets are used for all passwords. No credentials are hardcoded in Dockerfiles or committed to Git.
- **Entrypoint scripts**: Each service uses a shell script that reads secrets, performs first-run initialization, then `exec`s the main process as PID 1.

### Virtual Machines vs Docker

Virtual machines emulate entire hardware stacks and run a full guest OS, consuming significant memory and disk. Docker containers share the host kernel, isolating processes via cgroups and namespaces. This makes containers far lighter and faster to start, at the cost of weaker isolation (no separate kernel). In Inception, Docker is used to run each service as a lightweight, reproducible unit without the overhead of multiple OS instances.

### Secrets vs Environment Variables

Environment variables are visible via `docker inspect`, in `/proc/<pid>/environ`, and can leak into logs. Docker secrets mount sensitive data as files under `/run/secrets/` inside containers, readable only by the target service, and never stored in image layers. This project uses Docker secrets for all passwords and credentials.

### Docker Network vs Host Network

Host networking removes isolation — containers share the host's network stack, which creates port conflicts and security risks. A bridge network (used here as `inception`) gives each container its own IP, enables DNS-based service discovery (e.g., `mariadb` hostname), and restricts external access to only explicitly published ports (443).

### Docker Volumes vs Bind Mounts

Bind mounts map a specific host path into the container, tightly coupling the container to the host filesystem layout. Named volumes are managed by Docker, portable, and can use different storage drivers. This project uses named volumes with `local` driver and `device` options to store data at `/home/ltcherep/data/` as required by the subject.

## Instructions

### Prerequisites

- A Linux VM with Docker and Docker Compose installed
- `/etc/hosts` must contain: `127.0.0.1 ltcherep.42.fr`

### Build and run

```bash
make        # builds images and starts containers
make down   # stops and removes containers
make clean  # removes containers, volumes, and images
make fclean # clean + removes host data directories
make re     # full rebuild from scratch
```

### Access

- Website: `https://ltcherep.42.fr`
- WP Admin: `https://ltcherep.42.fr/wp-admin`

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/compose-file/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress CLI handbook](https://make.wordpress.org/cli/handbook/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)
- [Docker secrets documentation](https://docs.docker.com/engine/swarm/secrets/)

### AI Usage

AI was used as a collaborative tool for reviewing configuration syntax (NGINX TLS directives, php-fpm pool configuration), debugging entrypoint script logic, and drafting documentation. All generated content was reviewed, tested, and adapted to the project's specific requirements.
