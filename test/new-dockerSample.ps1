# creates sample resources to test the import process

# https://docs.docker.com/engine/reference/commandline/run/
# https://docs.docker.com/engine/reference/commandline/network_create/
# https://docs.docker.com/engine/reference/commandline/volume_create/

Write-Output "Creating example docker container, network, volume for testing..."

docker volume create --name testservicevol
docker network create -d bridge --subnet 192.0.0.2/24 testservicenetwork
docker run --name testservice -p "8080:80" --network testservicenetwork --mount source=testservicevol,target=/testdata -d nginx:latest

#create test file in the volume mount via container
Write-Output "createing 'testfile' under volume mount at /testdata/testfile..."
docker exec testservice sh -c "touch /testdata/testfile"

Write-Output "testservice container with volume and network created."
Write-Output "  inspect test resources with script '.\get-dockerSample.ps1'"
Write-Output "  remove test resources with script '.\remove-dockerSample.ps1'"
Write-Output "Test service creation completed, check for errors."
