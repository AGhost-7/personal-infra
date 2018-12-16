
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
	image = "${var.image_ufw}"
	region = "${var.region}"
	size = "${var.size}"
	private_networking = true
	ssh_keys = ["${digitalocean_ssh_key.default.id}"]
	tags = ["${digitalocean_tag.default.id}", "data"]
}

resource "digitalocean_droplet" "ci" {
	name = "ci"
	image = "${var.image}"
	region = "${var.region}"
	size = "${var.size}"
	private_networking = true
	ssh_keys = ["${digitalocean_ssh_key.default.id}"]
	tags = ["${digitalocean_tag.default.id}", "ci"]
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
	image = "${var.image}"
	region = "${var.region}"
	size = "${var.size}"
	private_networking = true
	ssh_keys = ["${digitalocean_ssh_key.default.id}"]
	tags = ["${digitalocean_tag.default.id}", "es"]
}

# }}}

# {{{ dns

resource "digitalocean_record" "private_es" {
	domain = "jonathan-boudreau.com"
	name = "private"
	type = "A"
	value = "${digitalocean_droplet.ci.ipv4_address_private}"
}

resource "digitalocean_record" "private_ci" {
	domain = "jonathan-boudreau.com"
	name = "private"
	type = "A"
	value = "${digitalocean_droplet.ci.ipv4_address_private}"
}

resource "digitalocean_record" "private_data" {
	domain = "jonathan-boudreau.com"
	name = "private"
	type = "A"
	value = "${digitalocean_droplet.data.ipv4_address_private}"
}

resource "digitalocean_record" "git" {
	domain = "jonathan-boudreau.com"
	name = "git"
	type = "A"
	value = "${digitalocean_droplet.ci.ipv4_address}"
}

resource "digitalocean_record" "fingerboard" {
	domain = "jonathan-boudreau.com"
	name = "fingerboard"
	type = "CNAME"
	value = "jonathan-boudreau.com."
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
	value = "jonathan-boudreau.com."
}

# }}}
