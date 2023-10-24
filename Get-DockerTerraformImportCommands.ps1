#requires -version 5
<#
.DESCRIPTION
  Gets a set of commands for getting a single existing docker container including a single attached mount and network
  imported into terraform. Note that this script does NOT execute ANY destructive commands. These are 
  exected to be carefully executed and observed by the operator.

.PARAMETER DockerContainerName
  String, Required, the name of the container to target. Volumes and Networks will be listed for this container.
  
.NOTES
  Note that typically resources are intended to be created by Terraform. Migrating sate at a resource
  level, e.g. a database migration, volume file mirroring, is preferred to 'adopting' existing resources.
  Future Improvements:
    * Allow optional parameter to set terraform target name
    * Name compatibility validation
    * Handle zero or multiple mounts for other scenarios
    * Better help feedback around missing docker command, related issues
    * Consider allowing direct execution tradeoffs further
  
.EXAMPLE
  .\Get-DockerTerraformImportCommands.ps1 -DockerResourceName 'testservice'
#>

param (
    [Parameter(Mandatory=$True)]
    [string]
    $DockerContainerName
)

$ErrorActionPreference = "Stop"

# get container information

$containerInfo = $(docker container inspect $DockerContainerName) | ConvertFrom-Json

$containerId = $containerInfo.Id
$containerImage = $containerInfo.Image


#SINGLE MOUNT HANDLING ONLY!
$mount = $containerInfo.Mounts[0]

$mountName = $mount.Name

# SINGLE NETWORK HANDLING ONLY!
# $network = $containerInfo.NetworkSettings.Networks.psobject.Properties.Value
$networkName = $containerInfo.NetworkSettings.Networks.psobject.Properties.Name

Write-Output @"
Container named '$DockerContainerName' has
ID: $containerId
Image: $containerImage
Network: $networkName
Volume: $mountName

==============================================
Terraform import commands for docker resources
==============================================

terraform import docker_network.$networkName $networkName
terraform import docker_volume.$mountName $mountName
terraform import docker_container.$DockerContainerName $containerId"

===============================================================
Minimum resource definitions (add additional fields as desired)
===============================================================

resource "docker_network" "$networkName" {
  name = "$networkName"
}

resource "docker_volume" "$mountName" {
  name = "$mountName"
}

resource "docker_container" "$DockerContainerName" {
  name = "$DockerContainerName"
  image = "$containerImage"
}

======================================
Terraform test and inspection commands
======================================

# check imported state configuration for guideance - can output to a file if needed
terraform show

# check remaining required fields, and other differences between imported state and definions
teraform plan

==================================================================================================
WARNING - You must address all fields that will require restart to avoid restarting the container!
==================================================================================================

Analysis complete - Use commands listed above to manually migrate resources one at a time

"@
