# gets sample resources and relevant information

Write-Output "Volume:"
docker volume inspect testservicevol
Write-Output "Network:"
docker network inspect testservicenetwork
Write-Output "Container:"
$containerInfo =  $(docker container inspect testservice | ConvertFrom-Json) 
Write-Output "name: $($containerInfo.Name) - ID: $($containerInfo.Id)"
Write-Output "-----------------------"
Write-Output "Container Mounts: $($containerInfo.Mounts)"
Write-Output "Container Networks Info: $($containerInfo.NetworkSettings)"
Write-Output "-----------------------"
Write-Output "Loopback page response (Nginix welcome page):"
$(Invoke-WebRequest 127.0.0.1:8080).Content
Write-Output "(Expected: nginx welcome page HTML, no errors) or open in a browser: http://127.0.0.1:8080"
Write-Output "-----------------------"
Write-Output "Listing volume mount contend via container exect:"
docker exec testservice sh -c "ls -d /testdata/testfile"
Write-Output "(Expected to list '/testdata/testfile' which is created by the new-dockerSample script, no output is an error)"
