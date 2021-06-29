output "master_ip" {
	value = digitalocean_droplet.master.ipv4_address
}

output "node_ips" {
  value = digitalocean_droplet.node[*].ipv4_address
}

output "node_md_ips" {
  value = digitalocean_droplet.node-md[*].ipv4_address
}
