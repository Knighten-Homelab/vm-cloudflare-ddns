# Terraform

Terraform is used to create the VM on Proxmox that is used to run the Arr stack.

## Performing Init

The backend for this project is designed to be local. It is configured using the `-backend-config` flag. 

Here is an example of configuring the path where the local backend will store the state file:
```hcl
path = "dev-terraform.tfstate"
```

With the above saved as `backend-dev.hcl` to initialize the backend, run the following command:

```bash
terraform init -backend-config=backend-dev.hcl
```

## Applying the Configuration

Below is an example of `tfvars` file required to supply the variables to the terraform configuration:

```tfvars
vault_url="https://vault.local:8200"
vault_skip_tls_verify=false
vault_pve_secrets_path="kv/pve-secrets"
vault_pdns_secrets_path="kv/pdns-secrets"
vault_awx_secrets_path="kv/awx-secrets"
vault_ansible_service_account_secrets_path="kv/ansible-service-account-secrets"

pve_url="https://proxmox.local/api2/json"
pve_node="alpha"
vm_name="test"
vm_id=350
vm_ip_address="192.168.90.5"
vm_cidr_prefix_length=24
vm_gateway_address="192.168.90.1"
vm_dns_servers="192.168.90.100 192.168.90.101 192.168.90.1"
vm_vlan=20
vm_ci_store_pool="local-lvm"
vm_disk_store_pool="local-lvm"

pdns_url="http://dns.local:8080/"
dns_record_name="test"

awx_url="http://awx.local/"
awx_host_name="test"
awx_host_description="Test VM"
```

With the above stored as `dev.tfvars` to apply the configuration, run the following command:

```bash
terraform apply -var-file=dev.tfvars
```

## Destroying the Configuration

To destroy the configuration, run the following command:

```bash
terraform destroy -var-file=dev.tfvars
```