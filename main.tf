
# {{{ misc variables

# https://developers.digitalocean.com/documentation/v2/#list-all-sizes
variable "size" {
	default = "s-1vcpu-1gb"
}

variable "region" {
	default = "tor1"
}

# https://github.com/AGhost-7/digitalocean-images
# this should be the image's ID returned in the output when packer finishes
# building.
variable "image" {
	default = "33359121"
}

variable "image_ufw" {
	default = "37337493"
}

# }}}

# {{{ auth

provider "digitalocean" {}

# }}}


# {{{ namespace

variable "namespace" {
	default = "tf"
}

# }}}

# {{{ ssh

variable "ssh_pub_key" {
	default = "~/.ssh/do.pub"
}

resource "digitalocean_ssh_key" "default" {
	name = "${var.namespace}-default-key"
	public_key = file(var.ssh_pub_key)
}

# }}}

# {{{ tags

resource "digitalocean_tag" "default" {
	name = var.namespace
}

resource "digitalocean_tag" "ci" {
	name = "ci"
}

resource "digitalocean_tag" "data" {
	name = "data"
}

resource "digitalocean_tag" "es" {
	name = "es"
}

# }}}

# {{{ machines

resource "digitalocean_droplet" "data" {
	name = "data"
	image = var.image_ufw
	region = var.region
	size = var.size
	private_networking = true
	ssh_keys = [digitalocean_ssh_key.default.id]
	tags = [digitalocean_tag.default.id, "data"]
}

resource "digitalocean_droplet" "ci" {
	name = "ci"
	image = var.image
	region = var.region
	size = var.size
	private_networking = true
	ssh_keys = [digitalocean_ssh_key.default.id]
	tags = [digitalocean_tag.default.id, "ci"]

	# TODO: implement own backup solution
	backups = true

	provisioner "remote-exec" {
		inline = [
			"ufw allow 2222",
			"ufw reload",
			"sed -i 's/Port 22/Port 2222/' /etc/ssh/sshd_config",
			"systemctl restart ssh"
		]
	}
}

resource "digitalocean_droplet" "es" {
	name = "es"
	image = var.image
	region = var.region
	size = var.size
	private_networking = true
	ssh_keys = [digitalocean_ssh_key.default.id]
	tags = [digitalocean_tag.default.id, "es"]
}

# }}}

# {{{ modules
module "k3s" {
	source = "./modules/k3s"
	nodes = 1
	size = var.size
	region = var.region
	ssh_keys = [digitalocean_ssh_key.default.id]
}
# }}}

# {{{ dns

resource "digitalocean_record" "private_es" {
	domain = "jonathan-boudreau.com"
	name = "es.private"
	type = "A"
	value = digitalocean_droplet.es.ipv4_address_private
}

resource "digitalocean_record" "private_ci" {
	domain = "jonathan-boudreau.com"
	name = "ci.private"
	type = "A"
	value = digitalocean_droplet.ci.ipv4_address_private
}

resource "digitalocean_record" "private_data" {
	domain = "jonathan-boudreau.com"
	name = "data.private"
	type = "A"
	value = digitalocean_droplet.data.ipv4_address_private
}

resource "digitalocean_record" "private_front" {
	domain = "jonathan-boudreau.com"
	name = "front.private"
	type = "A"
	value = "138.197.153.75"
}

resource "digitalocean_record" "git" {
	domain = "jonathan-boudreau.com"
	name = "git"
	type = "A"
	value = digitalocean_droplet.ci.ipv4_address
}

resource "digitalocean_record" "fingerboard" {
	domain = "jonathan-boudreau.com"
	name = "fingerboard"
	type = "CNAME"
	value = "k3s.jonathan-boudreau.com."
}

resource "digitalocean_record" "jenkins" {
	domain = "jonathan-boudreau.com"
	name = "jenkins"
	type = "CNAME"
	value = "jonathan-boudreau.com."
}

resource "digitalocean_record" "jokes" {
	domain = "jonathan-boudreau.com"
	name = "jokes"
	type = "CNAME"
	value = "k3s.jonathan-boudreau.com."
}

resource "digitalocean_record" "alerts" {
  domain = "jonathan-boudreau.com"
  name = "alerts"
  type = "TXT"
  value = "v=spf1 include:mailgun.org ~all"
}

resource "digitalocean_record" "alerts_domainkey" {
  domain = "jonathan-boudreau.com"
  name = "smtp._domainkey.alerts"
  type = "TXT"
  value = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCbOF+x85W0I7UIHR23K+YuwmwRHj3nBAKfmUqdBgZXjLUvokQSSd9Yb4Qq8hWBfQbgvTU90+P9LE0anA1GAK/VdHn2icun8xtzylGwxq6PRrdJJ/JI1WhJmvecvNjvqulhH1H9aW3ym2hao56ge9kjAN4eqVHlgBzUxtO564SyoQIDAQAB"
}

resource "digitalocean_record" "alerts_mxa" {
  domain = "jonathan-boudreau.com"
  type = "MX"
  name = "alerts"
  value = "mxa.mailgun.org."
  priority = 10
}

resource "digitalocean_record" "alerts_mxb" {
  domain = "jonathan-boudreau.com"
  type = "MX"
  name = "alerts"
  value = "mxb.mailgun.org."
  priority = 10
}

resource "digitalocean_record" "k3s" {
	domain = "jonathan-boudreau.com"
	name = "k3s"
	type = "A"
	value = module.k3s.master_ip
}
# }}}

