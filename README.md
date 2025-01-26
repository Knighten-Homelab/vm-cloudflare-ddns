# Homelab - Cloudflare DDNS

This repository contains Terraform and Ansible code to deploy a Cloudflare Dynamic DNS (DDNS) solution in my homelab. It provisions a Proxmox VM running a container that updates Cloudflare DNS records when my homelab's external IP address changes.

> [!Important]
> This repository reflects my personal approach and preferences. While it can serve as a guide, it is not designed to be cloned and used without significant modifications unless your setup matches mine.

## Table of Contents

* Overview
* Required Tools & Devcontainer
* Infrastructure Deployment
  * Deployment Example
    * Example - Partial Backend Config
    * Example - Tfvars File
    * Expected Hashicorp Vault Secrets
* Application Deployment (TODO)
* CI/CD (TODO)

## Overview

Terraform is used to deploy a set of resources needed for the Cloudflare DDNS solution. Using Terraform we will:

1. Create a VM that uses a [customized Debian Cloud-Init image](https://github.com/Johnny-Knighten/ansible-homelab-proxmox-cloud-init-templates-playbooks/tree/main) on a Proxmox cluster
2. Create a DNS A-Record on a local PowerDNS server

After the above resources are created, we then use AWX to run a Ansible playbook on our new VM that will:

1. Sets the hostname for the VM
2. Register the VM with FreeIPA
3. Install Python and Docker
4. Create a Docker Compose file with the required Cloudflare DDNS image then launch it

## Required Tools & Devcontainer

The two primary tools used in this project are: Terraform and Ansible.

Feel free to install Terraform (1.9.8 or higher) and Ansible (core 2.17.5 or higher) on your own system. Or use the devcontainer supplied in this repo that has all required tools ready to go. I highly recommend checking [them](https://containers.dev/) out and using them!

On a side note, I have the devcontainer configured to mount your home ssh directory `~/.ssh` to `/home/vscode/.ssh` inside the container. I found this to be the easiest way to pass SSH credentials when using WSL on Windows. Check [here](https://stackoverflow.com/a/73728247) for a better long-term solution for those who use WSL.

## Infrastructure Deployment

Terraform is used to deploy all infrastructure for this project. I use my [terraform-homelab-pve-vm](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm) module which handles all of the following:

1. Pulls required secrets from Hashicorp Vault
2. Creates the VM on Proxmox
3. Creates the A-Record on PowerDNS

### Deployment Example

Below are the commands to launch the infrastructure deployment using terraform. A Hashicorp Vault Token with proper permissions to access your secrets will need to be provided. All other secrets are pulled from Hashicorp Vault. You will also need to provide a partial backend configuration file and a set of tfvars.

```bash
export TF_VAR_vault_token=VAULT_ACCESS_TOKEN
terraform init -backend-config=backend-example.hcl
terraform apply -var-file=envs/example.tfvars
```

#### Example - Partial Backend Config

For this project I chose to use a [partial backend configuration](https://developer.hashicorp.com/terraform/language/backend#partial-configuration) to configure my remote S3 backend. This allows you to create a partially complete backend config (see [infra/terraform.tf](infra/terraform.tf) for example), and complete the rest of the config in a partial config file.

Here are some alternative options worth considering:

* Make a module per environment
  * Quickly leads to non-DRY code
  * Easy for one environment to drift apart from others, when ideally we deploy almost identical stacks per environments
* Use Terragrunt to generate a backend per environment
  * Wanted to avoid an additional tool when I would not be using any of its other features
* v1.8.0 of OpenTofu supports variables in backends
        * I haven't made the plunge to migrate to OpenTofu, Still waiting to see how TF and OpenTofu will diverge

The partial backend config below is similar to the one I use in my homelab, which uses [Minio](https://min.io/) as a S3 remote backend.

```hcl
bucket = "terraform-state"
access_key="terraform-service-account"
secret_key="PASSWORD"
endpoints = {
  s3 = "https://minio.local:9000"
}
```

#### Example - Tfvars File

Below is an example of the tfvars file required to apply the Terraform code. You could alternatively use Terraform Workspaces for the heavy lifting instead of multiple tfvar files.

```tfvars
/* Vault Vars */
vault_url="https://vault.local:8200"
vault_skip_tls_verify=false
vault_pve_secrets_path="kv/pve-secrets"
vault_pdns_secrets_path="kv/pdns-secrets"
vault_ansible_service_account_secrets_path="kv/ansible-service-account-secrets"

/* Proxmox/VM Vars */
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

/* PDNS Vars */
pdns_url="http://dns.local:8080/"
dns_record_name="test"
dns_zone="example.com
```

#### Expected Hashicorp Vault Secrets

Here are the expected secrets under each path variable.

| **Vault Path Variable**                | **Expected Secret Key**      | **Usage**                                     | **Provider/Module**          |
|----------------------------------------|------------------------------|-----------------------------------------------|--------------------------------|
| `var.vault_pve_secrets_path`           | `username`                   | Proxmox API username                          | Proxmox                       |
|                                        | `password`                   | Proxmox API password                          | Proxmox                       |
| `var.vault_pdns_secrets_path`          | `terraform_api_key`          | API key for PowerDNS                          | PowerDNS                      |
| `var.vault_ansible_service_account_secrets_path` | `ssh-key-private`           | Private SSH key for the Ansible service account | Proxmox Cloud Init      |
|                                        | `ssh-key-public`             | Public SSH key for the Ansible service account | Proxmox Cloud Init            |

## Application Deployment

The deployment of the Cloudflare DDNS solution is handled with AWX and Ansible. There are 3 major Ansible artifacts:

1. AWX resource creation playbook
2. The cloudflare-ddns role
3. A deployment playbook

The cloudflare-ddns role creates a service account and a docker-compose file that uses a container to handle Cloudflare DDNS. A deployment playbook is designed to apply multiple roles including the cloudflare-ddns and other dependency roles (docker, freeipa client, ...). Finally AWX is used to launch the deployment playbook.

### Running AWX Resource Creation Playbook

Before running this playbook you need to install the required Ansible dependencies. You have two ways to do this:

```bash
# Install just the awx.awx collection thats required to run the playbook
ansible-galaxy collection install awx.awx

# To install all of the project's Ansible dependencies
ansible-galaxy collection install -r ./collections/requirements.yml
```

Here is an example command for running the playbook that creates all AWX resources:

```bash
# From within the ansible directory
ansible-playbook -i localhost create-awx-cloudflare-ddns-deployment-resources.yml \
  -e awx_target_org="Homelab" \
  -e awx_target_inv="Homelab" \
  -e awx_git_credential="Github - AWX SSH Key" \
  -e project_branch="main" \
  -e target_host_fqdn="cloudflare-ddns.knighten.io" \
  -e host_groups='["proxmox-hosts", "ipa-managed-clients"]' \
  -e cloudflare_ddns_records='[{"zone":"knighten.io","subdomain":"game","proxied":false}]'
```

If prefered you can create variable file like so:

```yml
awx_target_org: "Homelab"
awx_target_inv: "Homelab"
awx_git_credential: "Github - AWX SSH Key"
project_branch: "main"
target_host_fqdn: "cloudflare-ddns.knighten.io"
host_groups:
  - "proxmox-hosts"
  - "ipa-managed-clients"
cloudflare_ddns_records:
  - zone: "knighten.io"
    subdomain: "game"
    proxied: false
```

Then run the playbook like this:

```bash
# From inside the ansible directory
ansible-playbook -i localhost create-awx-cloudflare-ddns-deployment-resources.yml -e @vars.yml
```

### Deployment Without AWX

The first step to execute the deployment without AWX is to install all required Ansible roles and collections. This can be done like so:

```bash
ansible-galaxy collection install -r ./collections/requirements.yml
ansible-galaxy install -r ./roles/requirements.yml
```

Then to launch the ansible-playbook you would run the following command:

``` bash
# From inside the ansible directory

```
