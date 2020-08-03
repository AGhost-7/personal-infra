variable "nodes" {
	type = number
}

variable "size" {
	type = string
}

variable "region" {
	type = string
}

variable "ssh_keys" {
	type = list(string)
}

variable "image" {
	default = "ubuntu-20-04-x64"
}
