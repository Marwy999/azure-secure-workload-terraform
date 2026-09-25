# Azure 3-Tier Infrastructure with Terraform

An automated, zero-cost Azure setup built with Terraform and GitHub Actions. The infrastructure state is saved remotely in Azure Blob Storage so that GitHub Actions can manage the full lifecycle, including automated teardowns.

## Architecture

```text
Internet ---> [App Service (Linux / Node 18)]
                     │ (User-Assigned Managed Identity)
                     ▼
              [Key Vault (Secrets)]
                     │
                     ▼
    [VNet: 10.0.0.0/16] ──► Frontend Subnet (10.0.1.0/24) + NSG
                        └──► Backend Subnet  (10.0.2.0/24) + NSG


Resources

Compute
Azure Linux Web App running on the free F1 tier with Node 18 LTS.
Networking
Virtual Network (10.0.0.0/16) split into Frontend and Backend subnets, each protected by a dedicated Network Security Group.
Security
Azure Key Vault with soft-delete enabled, using a User-Assigned Managed Identity to avoid saving credentials in the code.
State Management
Azure Storage Account configured as a remote backend in the rg-tfstate-dev resource group.


Project Structure

.github/workflows/
├── terraform-ci.yml      # Validates code and builds plan on PRs
├── terraform-cd.yml      # Applies changes on merge to main
└── terraform-destroy.yml # Manual workflow to destroy resources

terraform/
├── main.tf               # Provider definition and remote backend
├── network.tf            # VNet, subnets, and NSG rules
├── security.tf           # Managed identity and Key Vault policies
├── compute.tf            # Web App and App Service Plan
├── variables.tf          # Input parameters and region config
└── outputs.tf            # Exported resource details


How It Works
Pull requests to main run terraform fmt, terraform validate, and terraform plan.
Merging into main runs terraform apply to update Azure resources.
Running the manual Terraform Destroy workflow reads the state from Blob Storage and deletes all resources.



GitHub Secrets
To run the workflows, add these credentials to your repository secrets:
AZURE_CLIENT_ID
AZURE_CLIENT_SECRET
AZURE_SUBSCRIPTION_ID
AZURE_TENANT_ID
