#!/usr/bin/env bash

podman pod create --name postgre-sql -p 9876:80 -p 5432:5432

podman run -d --name db \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=Password \
#  -e POSTGRES_DB=dbt \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  postgres
  

