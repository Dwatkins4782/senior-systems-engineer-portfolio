package test

import (
	"fmt"
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformNetworkingModule(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/networking",
		Vars: map[string]interface{}{
			"prefix":             "test",
			"location":           "eastus",
			"vnet_address_space": []string{"10.0.0.0/16"},
			"subnets": map[string]interface{}{
				"test": map[string]interface{}{
					"address_prefix": "10.0.1.0/24",
				},
			},
			"common_tags": map[string]string{
				"Environment": "test",
				"ManagedBy":   "Terratest",
			},
		},
		NoColor: true,
	})

	defer terraform.Destroy(t, terraformOptions)

	// Run terraform init and apply
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	vnetName := terraform.Output(t, terraformOptions, "vnet_name")
	assert.Contains(t, vnetName, "test-vnet")

	vnetID := terraform.Output(t, terraformOptions, "vnet_id")
	assert.NotEmpty(t, vnetID)

	fmt.Printf("VNet Name: %s\n", vnetName)
	fmt.Printf("VNet ID: %s\n", vnetID)
}

func TestTerraformAKSModule(t *testing.T) {
	t.Parallel()

	// This test requires networking to be deployed first
	// In practice, you'd use a dependency or pre-deployed resources
	t.Skip("Skipping AKS test - requires pre-existing networking resources")

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/aks",
		Vars: map[string]interface{}{
			"prefix":             "test",
			"location":           "eastus",
			"kubernetes_version": "1.28",
			"aks_subnet_id":      "/subscriptions/.../subnets/test",
			"vnet_id":            "/subscriptions/.../vnets/test",
			"default_node_pool": map[string]interface{}{
				"name":       "system",
				"node_count": 1,
				"vm_size":    "Standard_D2s_v3",
			},
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	clusterName := terraform.Output(t, terraformOptions, "cluster_name")
	assert.NotEmpty(t, clusterName)
}

func TestTerraformCompleteInfrastructure(t *testing.T) {
	// Integration test for full infrastructure
	t.Skip("Skipping integration test - takes 15-20 minutes to run")

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "..",
		Vars: map[string]interface{}{
			"project_name": "test",
			"environment":  "dev",
			"location":     "eastus",
		},
		NoColor: true,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Validate all outputs
	outputs := terraform.OutputAll(t, terraformOptions)
	assert.NotEmpty(t, outputs["vnet_id"])
	assert.NotEmpty(t, outputs["aks_cluster_name"])
	assert.NotEmpty(t, outputs["key_vault_name"])
	assert.NotEmpty(t, outputs["acr_login_server"])
}
