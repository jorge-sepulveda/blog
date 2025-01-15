+++
title = "Running MySQL in Docker"
date = "2025-01-14T23:33:57-06:00"
tags = ["Dev", "Docker", "MySQL"]
+++

# Let's containerize a database!

I wanted a database in my local machine to try out some queries and thought about setting up a little test environment. I didn't want to go through the process of installing MySQL so let's make some Docker containers instead.

Docker, the very popular container virtualization solution written in Go. Used as the very building blocks for microservices since it works very well with Kubernetes. I need a small database and don't care about data persistence for the environment so this is perfect for small POC's or projects.

## download the MySQL image

Once docker is installed, everything can be done with terminals and text editors. I pulled mysql using

```bash
docker pull mysql
```

This pulls the official MySQL image for your computer to use in other commands. 

You can run docker containers with this but I'm a big fan of compose files, got really used to them in Amex and I'm not turning back.

## Docker compose

To set up compose we need to setup `docker-compose.yaml` with the configuration you want for the image. This is the setup I'm using.

```yaml
# Use root/example as user/password credentials
version: '3.1'

services:

  db:
    image: mysql
    container_name: database
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: playground
```

The container will use the mysql image we pulled earlier and the database will be named... database. I set restart to always so it always tries to restart even if it has issues(what could go wrong?) MySQL provides a lot of environment variables so I will be using `MYSQL_ROOT_PASSWORD` to set the root password for access. I also want to create a database called `playground` so I'm adding that env var as well. 

Once this file is created, you can go to the folder where this file exists and run with `docker compose up`. This will pipe you into the container and it will start up MySQL. This specific command will hold your terminal hostage until you ctrl+c and it will stop the container. I prefer running in detached mode using `-d` at the end so I can keep typing away. 

Another handy command is `docker ps`, which will show you the running containers in your system. If you're following this tutorial you'll see `database` running. 

## Get in the database

Once docker is running, we can access the container and run mysql with.

```bash
docker exec -it database mysql -uroot -pexample playground
```

This will put you in the container and straight to your database! You now have access to a tiny MySQL database which can be used on it's own or with small projects. There are ways to preload a database with tables and keep data persistent which can be found in the docs. 

## Let's put this in a makefile

I'm a big fan of less keystrokes. If I could alias all my terminal commands into one letter, I would(that doesn't mean I should.) I finalized this setup by putting everything in a makefile.

```sh
run:
	docker compose up -d

stop:
	docker compose down --volumes

connect:
  docker exec -it database mysql -uroot -pexample playground
```

Now everything can be ran or stopped with `make run` and `make stop`. I can also connect to the database with `make connect`, shaving valuable seconds of typing. All is good with the world and I have a database container. 

If you haven't used makefiles, use them! I have them in several repos and might make another post about that in the future. 

## Big disclaimer

This is by no means secure. I'm using root, storing those passwords in plain text and the terminal commands have it as well. This works for me because this database will never talk to the outside world and it will never contain data as I delete the volumes. When the time comes to bring something like this to the interwebs, I recommend Vault or Docker Swarm for managing secrets like database passwords.

It's de jure that there's a relevant xkcd for anything and I will share this one about Docker to finish. 

![All services are microservices if you ignore most of their features.](https://imgs.xkcd.com/comics/containers.png)
