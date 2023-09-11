output "organization_settings" {
  value = github_organization_settings.this
}

output "repositories" {
  value = github_repository.this
}

output "members" {
  value = github_membership.this
}

output "collaborators" {
  value = github_repository_collaborator.this
}
