
# {{{ misc variables

# https://developers.digitalocean.com/documentation/v2/#list-all-sizes
variable "size" {
	default = "s-1vcpu-1gb"
}

variable "region" {
	default = "tor1"
}

# https://github.com/AGhost-7/digitalocean-images
# this should be the kubernetes image's ID returned in the output
# when packer finishes building.
variable "image" {
	default = "33359121"
}

# }}}

# {{{ auth

variable "do_token" {}

provider "digitalocean" {
	token = "${var.do_token}"
}

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
	public_key = "${file(var.ssh_pub_key)}"
}

# }}}

# {{{ tags

resource "digitalocean_tag" "default" {
	name = "${var.namespace}"
}

# }}}

# {{{ machines

resource "digitalocean_droplet" "gitlab" {
	name = "${var.namespace}-gitlab"
	image = "${var.image}"
	region = "${var.region}"
	size = "${var.size}"
	private_networking = true
	ssh_keys = ["${digitalocean_ssh_key.default.id}"]
	tags = ["${digitalocean_tag.default.id}", "gitlab"]
}

# }}}

# {{{ dns

resource "digitalocean_record" "private_gitlab" {
	domain = "jonathan-boudreau.com"
	name = "private"
	type = "A"
	value = "${digitalocean_droplet.gitlab.ipv4_address_private}"
}

resource "digitalocean_record" "gitlab" {
	domain = "jonathan-boudreau.com"
	name = "gitlab"
	type = "CNAME"
	value = "jonathan-boudreau.com."
}

resource "digitalocean_record" "fingerboard" {
	domain = "jonathan-boudreau.com"
	name = "fingerboard"
	type = "CNAME"
	value = "jonathan-boudreau.com."
}

# }}}
