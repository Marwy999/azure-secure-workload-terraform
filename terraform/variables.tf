# Resource naming prefix
variable "prefix" {
  type        = string
  default     = "secapp"
  description = "Prefix applied to all created resources."
}

# Azure target region
variable "location" {
  type        = string
  default     = "westeurope"
  description = "Primary Azure region for deployment."
}

# Environment environment name
variable "environment" {
  type        = string
  default     = "dev"
  description = "Target deployment environment."
}
