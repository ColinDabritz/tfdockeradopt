
Write-Output "Removing test docker resources (container, volume, network)..."
# note this may take a moment as resources are released and confirmed
docker container stop testservice
docker container rm testservice
docker volume rm testservicevol
docker network rm testservicenetwork
