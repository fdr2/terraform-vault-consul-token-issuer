package basicconsultokenissuer

import (
	"crypto/tls"
	"encoding/json"
	"fmt"
	"gotest.tools/v3/assert"
	"io"
	"net/http"
	"os"
	"os/user"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

type VaultConsulSecretsEngineConfig struct {
	RequestId     string `json:"request_id"`
	LeaseId       string `json:"lease_id"`
	Renewable     bool   `json:"renewable"`
	LeaseDuration int    `json:"lease_duration"`
	Data          struct {
		Address string `json:"address"`
		Scheme  string `json:"scheme"`
	} `json:"data"`
	WrapInfo interface{} `json:"wrap_info"`
	Warnings interface{} `json:"warnings"`
	Auth     interface{} `json:"auth"`
}

type VaultConsulSecretsAuthRole struct {
	RequestId     string `json:"request_id"`
	LeaseId       string `json:"lease_id"`
	Renewable     bool   `json:"renewable"`
	LeaseDuration int    `json:"lease_duration"`
	Data          struct {
		ConsulNamespace string   `json:"consul_namespace"`
		ConsulRoles     []string `json:"consul_roles"`
		Lease           int      `json:"lease"`
		Local           bool     `json:"local"`
		MaxTtl          int      `json:"max_ttl"`
		Partition       string   `json:"partition"`
		TokenType       string   `json:"token_type"`
		Ttl             int      `json:"ttl"`
	} `json:"data"`
	WrapInfo interface{} `json:"wrap_info"`
	Warnings interface{} `json:"warnings"`
	Auth     interface{} `json:"auth"`
}

func TestBasicConsulTokenIssuer(t *testing.T) {
	t.Parallel()

	fmt.Println("Executing")

	vaultToken := os.Getenv("VAULT_TOKEN")
	if vaultToken == "" {
		fmt.Println("Did not find VAULT_TOKEN environment variable, reverting to user file token.")
		currentUser, err := user.Current()
		if err != nil {
			fmt.Println(err.Error())
			t.Error(err.Error())
		}
		fullpath, err := filepath.Abs(fmt.Sprintf("/Users/%s/.vault-token", currentUser.Username))
		if err != nil {
			fmt.Println(err.Error())
			t.Fatalf("Unable to resolve absolute path of file")
		}
		fileBytes, err := os.ReadFile(fullpath)
		if err != nil {
			fmt.Println(err.Error())
			t.Error(err.Error())
		} else {
			fmt.Println(fmt.Sprintf("Found User: %s Vault Token", currentUser.Username))
			vaultToken = string(fileBytes)
		}
	}
	vaultAddr := os.Getenv("VAULT_ADDR")
	fmt.Println(fmt.Sprintf("Using Vault Address: %s", vaultAddr))

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../examples/basic_consul_token_issuer",
	})

	// Cleanup resources after end of test with "terraform destroy"
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	fmt.Println("Testing API")

	// Inspect Vault Consul Secrets Config
	url := fmt.Sprintf("%s/v1/__test_consul/config/access", vaultAddr)
	body := GetAPI(url, vaultToken)
	//fmt.Println(string(body))
	var config VaultConsulSecretsEngineConfig
	err := json.Unmarshal(body, &config)
	if err != nil {
		fmt.Println(err.Error())
	}

	assert.Equal(t, config.LeaseDuration, 0)
	assert.Equal(t, config.Renewable, false)
	assert.Equal(t, config.Data.Address, "http://127.0.0.1:8500")
	assert.Equal(t, config.Data.Scheme, "http")

	// Inspect Vault Consul Token Role
	url = fmt.Sprintf("%s/v1/__test_consul/roles/__test_consul", vaultAddr)
	body = GetAPI(url, vaultToken)
	//fmt.Println(string(body))
	var role VaultConsulSecretsAuthRole
	err = json.Unmarshal(body, &role)
	if err != nil {
		fmt.Println(err.Error())
	}

	assert.Equal(t, role.Renewable, false)
	assert.DeepEqual(t, role.Data.ConsulRoles, []string{"__test_consul_policy"})
}

// Helper method to get Vault API for validation
func GetAPI(url string, vaultToken string) []byte {
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		fmt.Println(err.Error())
	}
	req.Header.Add("X-Vault-Token", vaultToken)

	//res, err := http.DefaultClient.Do(req)
	// Skip Verify on API calls in tests
	tr := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
	}
	client := &http.Client{Transport: tr}
	res, err := client.Do(req)
	if err != nil {
		fmt.Print(err.Error())
	}

	defer func(Body io.ReadCloser) {
		err := Body.Close()
		if err != nil {
			fmt.Println("Failed to close API request handler!")
		}
	}(res.Body)
	body, readErr := io.ReadAll(res.Body)
	if readErr != nil {
		fmt.Print(err.Error())
	}
	//fmt.Println(string(body))

	return body
}
