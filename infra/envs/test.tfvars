vault_url="https://vault.knighten.io"
vault_skip_tls_verify=false
vault_pve_secrets_path="kv/homelab-pve-terraform-agent"
vault_pdns_secrets_path="kv/pdns"
vault_ansible_service_account_secrets_path="kv/homelab-ansible-sa"

pve_url="https://primary.pve.knighten.io:8006/api2/json"
pve_node="primary"
vm_name="cloudflare-ddns-test"
vm_id=251
vm_ip_address="192.168.25.213"
vm_cidr_prefix_length=24
vm_gateway_address="192.168.25.1"
vm_dns_servers="192.168.25.100 192.168.25.101 192.168.25.1"
vm_vlan=6
vm_ci_store_pool="local-zfs"
vm_disk_store_pool="local-zfs"

pdns_url="http://dns.knighten.io:8080/"
dns_record_name="test.cloudflare-ddns"
dns_zone="knighten.io"
