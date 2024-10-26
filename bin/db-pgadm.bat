@echo off

Echo start pgadmin

podman run --pod postgre-sql ^
-e PGADMIN_DEFAULT_EMAIL=jessewei@tw.ibm.com ^
-e PGADMIN_DEFAULT_PASSWORD=Passw0rd  ^
--name pgadmin ^
-d pgadmin4:latest 

@echo on 