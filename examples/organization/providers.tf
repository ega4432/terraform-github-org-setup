provider "github" {
  token = var.github_pat
  owner = var.org_name
}

terraform {
  required_version = "~> 1.0"

  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}
