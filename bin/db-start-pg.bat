@echo off

Echo create pod, and start postgre
podman pod create --name postgre-sql -p 9876:80 -p 5432:5432

podman run --name db --pod=postgre-sql -d ^
  -e POSTGRES_DB=raw ^
  -e POSTGRES_USER=admin ^
  -e POSTGRES_PASSWORD=Passw0rd ^
  -v .:/tmp ^
  postgres


@echo on
