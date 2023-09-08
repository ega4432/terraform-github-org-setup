output "repo_urls" {
  value = [for v in module.organization.repositories : v.html_url]
}
