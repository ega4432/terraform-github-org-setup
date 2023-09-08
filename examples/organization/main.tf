module "organization" {
  source = "git@github.com:ega4432/terraform-github-org-setup.git"

  org_settings = {
    billing_email                 = var.billing_email
    default_repository_permission = var.default_repository_permission
  }

  admins  = var.admins
  members = var.members
}
