*This project has been created as part of the 42 curriculum by ltcherep.*

# Description #

Inception is a system administration project designed to deploy a secure, multi-container web infrastructure using Docker. The stack runs NGINX, WordPress (with PHP-FPM), and MariaDB—each isolated in its own container and orchestrated via Docker Compose.


The architecture is built on the principle of service isolation:
- Entry Point: All traffic is routed through NGINX on port 443 with TLS v1.2/v1.3 encryption.
- Processing: PHP-FPM acts as an independent backend service, communicating with NGINX via the FastCGI protocol (port 9000).
- Security: all sensitive credentials are managed via Docker secrets (or environment files), ensuring no passwords are hardcoded in Dockerfiles or committed to the repository.


To meet the project requirements, several architectural choices were made based on the following comparisons:

1. Docker vs. Virtual Machines (VMs)
The Difference: A VM is like a standalone house with its own walls, roof, and plumbing (a full operating system), which is very heavy. Docker is like an apartment in a building: it shares common resources (the system kernel) while remaining private and isolated.

The Choice: Docker was chosen for its light footprint, near-instant boot times, and its ability to run identically on any computer.

AI Usage: AI was used here as a learning tool to understand the fundamental concepts behind containerization and virtualization. It helped define specific vocabulary to system administration that was previously unknown.

2. Bridge Network vs. Host Network
The Difference: In "Host" mode, all containers share the computer's phone line at the same time. In "Bridge" mode, every container gets its own private internal extension.

The Choice: The Bridge network allows containers to talk to each other (e.g., WordPress calling MariaDB) without outside interference. Only the web server (NGINX) is authorized to answer "calls" from the public.

AI Usage: AI was used to understand Docker networking concepts from scratch, including terms like bridge, network driver, and port binding. It helped clarify why containers on the same custom bridge network can reach each other by service name, and why exposing only NGINX to the outside is a security best practice. 

3. Docker Secrets vs. Environment Variables
The Difference: Environment variables are like sticky notes left on a screen—anyone passing by can read them. Secrets are like a digital vault: the password only exists in the container's memory at the exact moment it is needed.

The Choice: This is the most secure method. No passwords are ever written in plain text in the code or committed to GitHub.

4. Docker Volumes vs. Bind Mounts
The Difference: A "Bind Mount" depends on a specific folder on your computer (if you move the folder, everything breaks). A Volume is a dedicated storage space managed entirely by Docker.

The Choice: Volumes are faster and "cleaner." They ensure that your WordPress posts and database remain safe even if you stop or delete the containers.

AI Usage: AI was used to understand the concept of data persistence in Docker and to learn the differences between storage strategies.

# Instructions #

Before starting, ensure your environment meets the following requirements:

System: A Linux VM with Docker and Docker Compose installed.

Local DNS: To access the site via the required domain, add the following entry to your /etc/hosts file: 127.0.0.1  ltcherep.42.fr

The project is entirely managed via a Makefile to automate the Docker orchestration.

- make
- make down   # stops and removes containers
- make clean
- make fclean
- make re

Once the containers are up and running, you can reach the infrastructure through your browser:

- Website: `https://ltcherep.42.fr`
- WP Admin: `https://ltcherep.42.fr/wp-admin`

Note: Since we use self-signed SSL certificates, your browser will display a security warning. You can safely bypass it by clicking "Advanced" and "Proceed".

# Resources #

To build this infrastructure, the following official documentations were used:

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/compose-file/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress CLI handbook](https://make.wordpress.org/cli/handbook/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)
- [Docker secrets documentation](https://docs.docker.com/engine/swarm/secrets/)

In the spirit of transparency, AI was used as a collaborative partner during the development of this project.

Logic & Debugging: Assisted in refining entrypoint scripts and debugging PHP-FPM pool configurations.

Optimization: Aided in drafting NGINX TLS directives and streamlining the Docker Compose architecture.

Documentation: Helped in structuring and polishing this README for better clarity.
