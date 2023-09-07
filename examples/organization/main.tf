module "organization" {
  source = "../.."

  org_settings = {
    billing_email                 = var.billing_email
    default_repository_permission = var.default_repository_permission
  }

  admins  = var.admins
  members = var.members
}

output "repo_urls" {
  value = [for v in module.organization.repositories : v.html_url]
}
