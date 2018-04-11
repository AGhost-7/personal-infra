
# {{{ variables

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
	default = "33359148"
}

variable "namespace" {
	default = "tf"
}

variable "ssh_pub_key" {
	default = "~/.ssh/do.pub"
}

# Maybe use:
# openssl rand -hex 20
variable "init_token" {
}

# }}}

# {{{ providers

provider "digitalocean" {
	token = "${var.do_token}"
}

# }}}

resource "digitalocean_ssh_key" "default" {
	name = "${var.namespace}-default-key"
	public_key = "${file(var.ssh_pub_key)}"
}

resource "digitalocean_droplet" "master" {
	name = "${var.namespace}-master"
	image = "${var.image}"
	region = "${var.region}"
	size = "${var.size}"
	private_networking = true
	ssh_keys = ["${digitalocean_ssh_key.default.id}"]

	provisioner "file" {
		source = "files/10-kubadm.conf"
		destination = "/etc/systemd/kubelet.service.d/10-kubeadm.conf"
	}

	provisioner "remote-exec" {
		inline = [
			"kubeadm init --ignore-preflight-errors Swap --pod-network-cidr=10.244.0.0/16 --token ${var.init_token}",
			"KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml"
		]
	}
}

resource "digitalocean_droplet" "front" {
	name = "${var.namespace}-front"
	image = "${var.image}"
	region = "${var.region}"
	size = "${var.size}"
	private_networking = true
	ssh_keys = ["${digitalocean_ssh_key.default.id}"]

	provisioner "remote-exec" {
		inline = [
		]
	}
}

resource "digitalocean_droplet" "metric" {
	name = "${var.namespace}-metric"
	image = "${var.image}"
	region = "${var.region}"
	size = "${var.size}"
	private_networking = true
	ssh_keys = ["${digitalocean_ssh_key.default.id}"]
	
	provisioner "remote-exec" {
		inline = [
		]
	}
}
