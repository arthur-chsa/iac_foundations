output "service_accounts" {
  description = "List of created service accounts and their emails"
  value = {
    for name, sa in google_service_account.service_accounts :
    name => sa.email
  }
}