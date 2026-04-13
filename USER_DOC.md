# Services Overview
The infrastructure provides a complete, secure environment for hosting a website. It is composed of three main services:

- Web Server (NGINX): The secure gateway. It handles all incoming requests and ensures they are encrypted (HTTPS).

- Website Engine (WordPress): The core platform where the content is created and managed.

- Database (MariaDB): The secure "vault" where all your website’s data, posts, and user information are stored.


# Managing the Project
You can control the entire stack using simple commands from the terminal. Make sure you are in the project's root directory.

Launching the Stack : make
Stopping the Stack : make down
Resetting the Project : make fclean


# Accessing the Website
Once the stack is running, you can access the platform via your web browser:
 - Website: `https://ltcherep.42.fr`
 - Admin panel: `https://ltcherep.42.fr/wp-admin`


# Credentials & Security
To maintain high security, passwords and usernames are not written in the code.

- Location: All sensitive information is stored in a hidden environment file (.env) located at the root of the project.
- Management: If you need to change a password, update the .env file and restart the stack with make re.


# Verify Services Health
To verify that everything is running perfectly, you can use terminal
 - docker ps # You should see three services listed (nginx, wordpress, mariadb) with the status "Up".

