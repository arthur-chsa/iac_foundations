variable "google_credentials" {
  description = "GCP service account credentials (JSON)"
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Default region"
  type        = string
}

variable "enabled_apis" {
  description = "List of Google APIs to enable for the project. Override per environment via tfvars."
  type        = list(string)
}

variable "service_accounts" {
  description = "Map of service accounts and their roles"
  type = map(object({
    display_name = string
    roles        = list(string)
  }))
}