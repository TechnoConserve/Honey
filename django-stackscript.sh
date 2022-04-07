#!/bin/bash

set -x

# UDF variables passed in by calling script
# <UDF name="DJANGO_SECRET_KEY" label="Secret key needed for django docker container" example="iasdfkjljsadf" />
# <UDF name="POSTGRES_PASSWORD" label="Superuser password for postgres docker container" example="iuelvlkxjv" />
# <UDF name="POSTGRES_USER" label="Ya know, it's the user for the postgres database in the container" example="honey-postgres-user" />
# <UDF name="POSTGRES_DB" label="Postgres database name" example="honey-postgres-db" />

# Variables exported for consuption by docker-compose
export IPADDR=$(/sbin/ifconfig eth0 | awk '/inet / { print $2 }' | sed 's/addr://')
export DJANGO_SECRET_KEY=${DJANGO_SECRET_KEY}
export POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
export POSTGRES_USER=${POSTGRES_USER}
export POSTGRES_DB=${POSTGRES_DB}

source <ssinclude StackScriptID=1>

get_started

# Docker
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Docker-Compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Clone this repo
git clone https://github.com/TechnoConserve/Honey /opt/Honey
cd /opt/Honey

# Run the containers
docker-compose pull
docker-compose up -d --build

stackscript_cleanup