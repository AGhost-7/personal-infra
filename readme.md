This repo houses all of the containers for my portfolio site.

The host uses the following packer build to run on digital ocean:

https://github.com/AGhost-7/digitalocean-image-docker

## Terraform
To bring up the virtual machines, run the following:
```sh
export TF_VAR_do_token=<your digitalocean API token>
export TF_VAR_init_token=<some random token for kubernetes>
export TF_VAR_ssh_pub_key=~/.ssh/id_rsa
terraform apply
```
