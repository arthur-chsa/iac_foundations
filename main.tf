terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  credentials = var.google_credentials
}

# Enable Required APIs
resource "google_project_service" "enabled_apis" {
  for_each = toset([
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com"
  ])

  project             = var.project_id
  service             = each.key
  disable_on_destroy  = false
}

# Service Accounts Creation
resource "google_service_account" "service_accounts" {
  for_each = var.service_accounts

  account_id   = each.key
  display_name = each.value.display_name

  depends_on = [google_project_service.enabled_apis]
}

# Flatten SA ↔ Role Combinations
locals {
  sa_role_pairs = flatten([
    for sa_name, sa_data in var.service_accounts : [
      for role in sa_data.roles : {
        sa_key   = sa_name
        sa_email = google_service_account.service_accounts[sa_name].email
        role     = role
      }
    ]
  ])
}

# Assign IAM Roles to Each Service Account
resource "google_project_iam_member" "sa_roles" {
  for_each = {
    for pair in local.sa_role_pairs :
    "${pair.sa_key}-${replace(pair.role, "/", "_")}" => pair
  }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${each.value.sa_email}"

  depends_on = [google_service_account.service_accounts]
}