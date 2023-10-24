# Terraform Docker Adoption

This repo has tools and support for addopting existing resources present in Docker into Terraform. This process will have manual steps for safety given the sensitive and complex nature of the import and state management processes in terraform.

## Warning - LAST RESORT ONLY

This process is not recommended unless absolutely needed. Letting Terraform manage and create the desired resources natively is much safer. Data, files, and other continous persistance needs can potentially be handled by migrating them into managed resources, redirecting requests and similar processes. These should be explored before attempting this process.

If proceeding, it can be helpful to consult the guideance around potential issues with Import, and state management.

https://developer.hashicorp.com/terraform/cli/import
https://developer.hashicorp.com/terraform/cli/import/importability

## Requirements

* Confirm that there is no way to re-create, replace, or migrate the resources without using the Terraform Import process.
* Access to the docker instances required, usually on the machine in question
* Environment
  * Powershell core
  * Terraform
  * Docker
* Tested on Windows
* Permission to run Terraform, particularly shared state if needed

## Future work

* Test on additional platforms, adjust if needed (Linux+Bash, MacOS)
* Fully parameterize the types and names of resources to adopt
* handle 0 or multiple volume and mount cases
* better handle locating terraform directory vs script location
* Consider end-to-end fully automated testing, further robustness, could run in pipeline

## Steps

1. Ensure you are in the appropriate terraform directory, and have access to the script.
2. Run `terraform init` and `terraform plan` to ensure the current state is "clean" and there are no pending changes to make. If there are, handle these changes before begining.
3. Run the script to inspect the target container
4. Import resources individually, using this process:
  1. Add at least the minimum resource outline for the resource to the terrform file
  2. Run the import command provided by the script for that specific resource (only!) Note you may need to change the default names, which come from the Docker resource names.
  3. Handle any errors
  4. Add additional fields as desired. The `terraform plan` and `terraform show` commands make the state and differences more visible
5. After each resource is added your plan should be running, but may continue to have differences, and may still plan to restart the container. Refer to the "show" contents, and reconcile desired fields, particularly any marked as requiring restart
6. If there are any changes you wish to apply (minor differences may be acceptable in some cases) verify the plan impacts will be as expected, especially around re-creating or restarting any resources, and run the `terrform apply`
7. Verify the `terraform plan` now shows `no changes`

The resources should now be controlled by terraform.

## Testing

The test directory contains scripts to support the visiblity of the process

1. Ensure you are in the test directory
2. to set up the resources, run `new-dockerSample.ps1`
3. for a listing of test resources run `get-dockerSample.ps1`, or inspect them using docker commands as desired
4. Execute the import process as above under 'steps' from the test directory `../Get-DockerTerraformImportCommands.ps1 -DockerContainerName 'testservice'`
5. Follow along with the process, using the commented out fields from `main.tf`.
6. check the resource listing again, and verify nothing has changed. Check the container age to ensure it did not restart.

## Changelog

* 2023-10-23 3:18 PM - Added base test scripts
* 2023-10-23 6:05 PM - Added test infrastructure and core script
