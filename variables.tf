variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "google_credentials" {
  type        = string
  description = "GCP credentials JSON"
  sensitive   = true
}

variable "enabled_apis" {
  type        = list(string)
  description = "List of Google APIs to enable"
}

variable "service_accounts" {
  type = map(object({
    display_name = string
    roles        = list(string)
  }))
  description = "Service accounts to create with their roles"
}