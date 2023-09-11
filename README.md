# terraform-github-org-setup

## Usage

`main.tf`

```tf
module "organization" {
  source = "git@github.com:ega4432/terraform-github-org-setup.git"

  org_settings = {
    billing_email                 = var.billing_email
    default_repository_permission = var.default_repository_permission
  }

  admins  = var.admins
  members = var.members
}
```

`*.tfvars`

```tf
github_pat = "YOUR_GITHUB_PERSONAL_ACCESS_TOKEN"

billing_email                 = "YOUR_ORGANIZATION_USER_EMAIL"
default_repository_permission = "none" # Repository permissions for members (default to "read only")
org_name                      = "YOUR_ORGANIZATION_NAME"

admins = []  # YOUR_ORGANIZATION_ADMIN_USERS
members = [  # YOUR_ORGANIZATION_MEMBERS
  {
    user        = "xxx"
    fullname    = "xxx xxx"
  }
  {
    user        = "yyy"
    fullname    = "yyy yyy"
  }
]
```

Once you have prepared the necessary files as described above, execute the following command.

```sh
$ terraform init

$ terraform plan -var-file <YOUR_VARS_FILE_NAME>.tfvars -out=tfplan

$ terraform apply tfplan
```

See [example](https://github.com/ega4432/terraform-github-org-setup/tree/main/examples/organization) for more information.

## Test

The Go library called [Terratest](https://github.com/gruntwork-io/terratest) is used for testing.

```sh
$ cd test/

$ go test -timeout 1m
```
