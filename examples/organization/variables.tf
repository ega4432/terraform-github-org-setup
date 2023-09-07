variable "github_pat" {
  type = string
}

variable "org_name" {
  type = string
}

variable "billing_email" {
  type = string
}

variable "default_repository_permission" {
  type    = string
  default = "read"
  validation {
    condition     = contains(["admin", "write", "read", "none"], var.default_repository_permission)
    error_message = "Invalid input value."
  }
}

variable "members" {
  type    = list(map(string))
  default = []
}

variable "admins" {
  type    = list(map(string))
  default = []
}
