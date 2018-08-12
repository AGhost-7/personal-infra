
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

resource "digitalocean_tag" "ci" {
	name = "ci"
}

# }}}

# {{{ machines

resource "digitalocean_droplet" "ci" {
	name = "ci"
	image = "${var.image}"
	region = "${var.region}"
	size = "${var.size}"
	private_networking = true
	ssh_keys = ["${digitalocean_ssh_key.default.id}"]
	tags = ["${digitalocean_tag.default.id}", "ci"]

	provisioner "remote-exec" {
		inline = [
			"sed -i 's/Port 22/Port 2222/' /etc/ssh/sshd_config",
			"systemctl restart ssh"
		]
	}

	# add the host key
	provisioner "local-exec" {
		command =
			"(ssh-keyscan -p 2222 ${digitalocean_droplet.ci.ipv4_address}; cat ~/.ssh/known_hosts) | sort -u > ~/.ssh/known_hosts"
	}
}

# }}}

# {{{ dns

resource "digitalocean_record" "private_ci" {
	domain = "jonathan-boudreau.com"
	name = "private"
	type = "A"
	value = "${digitalocean_droplet.ci.ipv4_address_private}"
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

# }}}
