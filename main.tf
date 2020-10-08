
# {{{ misc variables

# https://developers.digitalocean.com/documentation/v2/#list-all-sizes
variable "size" {
	default = "s-1vcpu-1gb"
}

variable "region" {
	default = "tor1"
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
	value = "k3s.jonathan-boudreau.com."
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

resource "digitalocean_record" "prom" {
	domain = "jonathan-boudreau.com"
	name = "prom"
	type = "CNAME"
	value = "k3s.jonathan-boudreau.com."
}

# }}}

