@echo off

Echo Exec %1 ...
Echo .
podman exec -it db psql -d postgres -U admin  -f /tmp/%1
Echo .
Echo End exec %1

@echo on