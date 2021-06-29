
resource "digitalocean_vpc" "k3s" {
	name = "k3s"
	region = var.region
}

resource "digitalocean_droplet" "master" {
	name = "k3s-master"
	image = var.image
	region = var.region
	size = var.size
	vpc_uuid = digitalocean_vpc.k3s.id
	tags = ["k3s", "k3s_master"]
	ssh_keys = var.ssh_keys
}

resource "digitalocean_droplet" "node" {
	name = "k3s-node-${count.index}"
	image = var.image
	region = var.region
	size = var.size
	vpc_uuid = digitalocean_vpc.k3s.id
	tags = ["k3s", "k3s_node"]
	ssh_keys = var.ssh_keys
	count = var.nodes
}

resource "digitalocean_droplet" "node-md" {
  name = "k3s-node-md-${count.index}"
  image = var.image
  region = var.region
	size = var.size_medium
	vpc_uuid = digitalocean_vpc.k3s.id
	tags = ["k3s", "k3s_node"]
	ssh_keys = var.ssh_keys
	count = var.nodes_medium
}
