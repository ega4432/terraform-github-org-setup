locals {
  admins      = { for admin in var.admins : admin.user => "admin" }
  members     = { for member in var.members : member.user => "member" }
  all_members = merge(local.admins, local.members)
}

resource "github_organization_settings" "this" {
  count = length(var.org_settings) > 0 ? 1 : 0

  billing_email = var.org_settings.billing_email

  company                                                      = lookup(var.org_settings, "company", null)
  blog                                                         = lookup(var.org_settings, "blog", null)
  email                                                        = lookup(var.org_settings, "email", null)
  twitter_username                                             = lookup(var.org_settings, "twitter_username", null)
  location                                                     = lookup(var.org_settings, "location", null)
  name                                                         = lookup(var.org_settings, "name", null)
  description                                                  = lookup(var.org_settings, "description", null)
  has_organization_projects                                    = lookup(var.org_settings, "has_organization_projects", true)
  has_repository_projects                                      = lookup(var.org_settings, "has_repository_projects", true)
  default_repository_permission                                = lookup(var.org_settings, "default_repository_permission", "read")
  members_can_create_repositories                              = lookup(var.org_settings, "members_can_create_repositories", false)
  members_can_create_public_repositories                       = lookup(var.org_settings, "members_can_create_public_repositories", false)
  members_can_create_private_repositories                      = lookup(var.org_settings, "members_can_create_private_repositories", false)
  members_can_create_internal_repositories                     = lookup(var.org_settings, "members_can_create_internal_repositories", false)
  members_can_create_pages                                     = lookup(var.org_settings, "members_can_create_pages", false)
  members_can_create_public_pages                              = lookup(var.org_settings, "members_can_create_public_pages", false)
  members_can_create_private_pages                             = lookup(var.org_settings, "members_can_create_private_pages", false)
  members_can_fork_private_repositories                        = lookup(var.org_settings, "members_can_fork_private_repositories", false)
  web_commit_signoff_required                                  = lookup(var.org_settings, "web_commit_signoff_required", false)
  advanced_security_enabled_for_new_repositories               = lookup(var.org_settings, "advanced_security_enabled_for_new_repositories", false)
  dependabot_alerts_enabled_for_new_repositories               = lookup(var.org_settings, "dependabot_alerts_enabled_for_new_repositories", false)
  dependabot_security_updates_enabled_for_new_repositories     = lookup(var.org_settings, "advanced_security_enabled_for_new_repositories", false)
  dependency_graph_enabled_for_new_repositories                = lookup(var.org_settings, "dependency_graph_enabled_for_new_repositories", false)
  secret_scanning_enabled_for_new_repositories                 = lookup(var.org_settings, "secret_scanning_enabled_for_new_repositories", false)
  secret_scanning_push_protection_enabled_for_new_repositories = lookup(var.org_settings, "secret_scanning_push_protection_enabled_for_new_repositories", false)
}

resource "github_membership" "this" {
  for_each = merge(local.admins, local.members)

  username = each.key
  role     = each.value
}

resource "github_repository" "this" {
  for_each = { for k, v in var.members : k => v if try(v.create_repo, false) }

  name = replace(lower(each.value.fullname), " ", "-")

  description                 = "Created by terraform"
  homepage_url                = lookup(var.repo_settings, "homepage_url", null)
  visibility                  = lookup(var.repo_settings, "visibility", "private")
  has_issues                  = lookup(var.repo_settings, "has_issues", true)
  has_projects                = lookup(var.repo_settings, "has_projects", true)
  has_wiki                    = lookup(var.repo_settings, "has_wiki", false)
  has_discussions             = lookup(var.repo_settings, "has_discussions", false)
  is_template                 = lookup(var.repo_settings, "is_template", false)
  allow_merge_commit          = lookup(var.repo_settings, "allow_merge_commit", true)
  allow_squash_merge          = lookup(var.repo_settings, "allow_squash_merge", true)
  allow_rebase_merge          = lookup(var.repo_settings, "allow_rebase_merge", true)
  allow_auto_merge            = lookup(var.repo_settings, "allow_auto_merge", false)
  squash_merge_commit_title   = lookup(var.repo_settings, "squash_merge_commit_title", "COMMIT_OR_PR_TITLE")
  squash_merge_commit_message = lookup(var.repo_settings, "squash_merge_commit_message", "COMMIT_MESSAGES")
  delete_branch_on_merge      = lookup(var.repo_settings, "delete_branch_on_merge", false)
  auto_init                   = lookup(var.repo_settings, "auto_init", false)
  gitignore_template          = lookup(var.repo_settings, "gitignore_template", null)
  license_template            = lookup(var.repo_settings, "license_template", null)
  archived                    = lookup(var.repo_settings, "archived", false)

  dynamic "template" {
    for_each = try(var.repo_settings.use_template, [])

    content {
      owner      = lookup(var.repo_settings.template, "owner", null)
      repository = lookup(var.repo_settings.template, "repository", null)
    }
  }

  dynamic "pages" {
    for_each = try(var.repo_settings.use_pages, [])

    content {
      source {
        branch = lookup(var.repo_settings.pages, "branch", "gh-pages")
        path   = lookup(var.repo_settings.pages, "path", "/")
      }
    }
  }

  lifecycle {
    ignore_changes = [ description ]
  }
}

resource "github_repository_collaborator" "this" {
  for_each = { for k, v in var.members : k => v if try(v.create_repo, false) }

  repository = replace(lower(each.value.fullname), " ", "-")
  username   = each.value.user
  permission = lookup(each.value, "permission", "push")

  depends_on = [github_membership.this, github_repository.this]
}
