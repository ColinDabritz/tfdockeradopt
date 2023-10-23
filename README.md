# Terraform Docker Adoption

This repo has tools and support for addopting existing resources present in Docker into Terraform. This process will have manual steps for safety given the sensitive and complex nature of the import and state management processes in terraform.


## Warning - LAST RESORT ONLY

This process is not recommended unless absolutely needed. Letting Terraform manage and create the desired resources natively is much safer. Data, files, and other continous persistance needs can potentially be handled by migrating them into managed resources, redirecting requests and similar processes. These should be explored before attempting this process.

If proceeding, it can be helpful to consult the guideance around potential issues with Import, and state management.

[https://developer.hashicorp.com/terraform/cli/import](Terraform Import documentation)
[https://developer.hashicorp.com/terraform/cli/import/importability](Terraform Importability)

## Requirements

* Confirm that there is no way to re-create, replace, or migrate the resources without using the Terraform Import process.
* Access to the docker instances required, usually on the machine in question
* Environment
    * Powershell core
    * Terraform
    * Docker
* Tested on Windows
* Permission or access to run Terraform, particularly exclusive access if shared state is used.

# Future work
* Fully parameterize the types and names of resources to addopt
* More robust handling
* Test on additional platforms, adjust if needed (Linux Bash, MacOS)
* Isolate the imported resources at first - Seprate state file, workspace maybe, then integrate after tf resoruce file is complete
* Consider end-to-end fully automated testing, further robustness, could run in pipeline

# Steps

WIP

1. Run `terraform plan` to ensure the current state is "clean" and there are no pending changes to make. If there are, handle these changes before beginning.
2. Run the script to enumerate resources (auto?), and show import commands
3. Import resources individually, using this process:
  1. Run the import command provided by the script for that specific resource (only!)
  2. Run `terraform plan` to confirm the resource was added, and what fields it is expecting
  3. Add the resource, and expected fields and info to your terraform file (TODO: Consider exporting as an approach?)
3. Put imported docker resources into terraform file, in the terraform definition
4. Confirm that the `terraform plan` runs with no expected changes, and all resources are present
5. Check the terraform changes into source control, ensure the state is tracked as expected, either local or shared

The resources should be imported into terraform without changes or restarts.

# Testing

The test directory contains scripts to support the visiblity of the process

1. Ensure you are in the appropriate directory in powershell core
2. to set up the resources, run `new-dockerSample.ps1`
3. for a listing of test resources run `get-dockerSample.ps1`, or inspect them using docker commands as desired
4. Execute the import process as above under 'steps'
5. Confirm the resources are imported as expected in terraform, and the resource listing hasn't been affected

# Changelog
* 2023-10-23 3:18 PM - Added base test scripts
