package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraform(t *testing.T) {
	exampleDir := "../examples/organization"
	varFiles := []string{"terraform.tfvars"}

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: exampleDir,
		VarFiles:     varFiles,
	})

	destroyOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: exampleDir,
		VarFiles:     varFiles,
		Targets:      []string{"module.organization.github_repository_collaborator.this"},
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, destroyOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables and check they have the expected values.
	output := terraform.Output(t, terraformOptions, "repo_urls")
	expected := "[https://github.com/github-organization-example/test-san]"
	assert.Equal(t, expected, output)
}
