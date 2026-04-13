# Environment Setup
To replicate this infrastructure from scratch, you need to prepare the host environment and the configuration layer.

Prerequisites
-OS: Linux (Debian/Ubuntu recommended) or a compatible VM.
-Tools: make, docker-engine, and docker-compose.
-Network: Add the local domain to your /etc/hosts: echo "127.0.0.1 ltcherep.42.fr" | sudo tee -a /etc/hosts

Configuration & Secrets
The project relies on an .env file at the root to store sensitive data (DB names, user passwords, etc.).
-Secrets Management: These variables are injected into the containers as environment variables or handled via Docker Secrets for enhanced security.
-SSL Certificates: The NGINX container requires a TLS certificate (.crt) and a private key (.key) located in the specified secrets directory defined in the Dockerfile.


# Build and Launch
The project is entirely managed via a Makefile to automate the Docker orchestration.

- make
- make down   # stops and removes containers
- make clean
- make fclean


# Container Management
Check Logs: Monitor real-time output from all services:
 - docker-compose logs -f
Interactive Shell: Access a specific container (e.g., WordPress) to run commands:
 - docker exec -it wordpress sh
Network Inspection: Verify that containers are correctly isolated on the inception bridge:
 - docker network inspect inception


# Data Persistence & Volumes
Volume Mapping : We use Docker Volumes to ensure data survives even if a container is deleted:
 - db_data: Persists the MariaDB - database files.
 - wp_data: Persists the WordPress source code and user uploads.

Physical Storage : On the host machine, these volumes are mapped to specific directories (e.g., /home/ltcherep/data/).
Destruction: Only make fclean (or an explicit docker volume rm) will delete the physical data on the host.
