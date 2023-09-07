variable "org_settings" {
  type    = any
  default = {}
}
variable "repo_settings" {
  type    = any
  default = {}
}
variable "members" {
  type    = list(map(string))
  default = []
}
variable "admins" {
  type    = list(map(string))
  default = []
}
