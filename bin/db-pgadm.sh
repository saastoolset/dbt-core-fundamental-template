#!/usr/bin/env bash

podman run --pod postgre-sql \
-e 'PGADMIN_DEFAULT_EMAIL=admin@cloudspinx.com' \
-e 'PGADMIN_DEFAULT_PASSWORD=StrongPassw0rd'  \
--name pgadmin \
 -d docker.io/dpage/pgadmin4:latest