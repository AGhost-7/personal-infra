
# https://developers.digitalocean.com/documentation/v2/#list-all-sizes
variable "size" {
	default = "s-1vcpu-1gb"
}

variable "region" {
	default = "tor1"
}

variable "do_token" {}

# https://github.com/AGhost-7/digitalocean-images
# this should be the kubernetes image's ID returned in the output
# when packer finishes building.
variable "image" {
	default = "33359121"
}

variable "namespace" {
	default = "tf"
}

variable "ssh_pub_key" {
	default = "~/.ssh/do.pub"
}

provider "digitalocean" {
	token = "${var.do_token}"
}

resource "digitalocean_tag" "default" {
	name = "${var.namespace}"
}

resource "digitalocean_ssh_key" "default" {
	name = "${var.namespace}-default-key"
	public_key = "${file(var.ssh_pub_key)}"
}

resource "digitalocean_droplet" "gitlab" {
	name = "${var.namespace}-gitlab"
	image = "${var.image}"
	region = "${var.region}"
	size = "${var.size}"
	private_networking = true
	ssh_keys = ["${digitalocean_ssh_key.default.id}"]
	tags = ["${digitalocean_tag.default.id}", "gitlab"]
}
