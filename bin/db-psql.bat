@echo off

Echo Exec %1 -- %2 ...
Echo .
podman exec -it db psql -d %1 -U admin  -f /tmp/%2
Echo .
Echo End exec %1 -- %2 

@echo on