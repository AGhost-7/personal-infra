This repo houses all of the containers for my portfolio site.

The host uses the following packer build to run on digital ocean:

https://github.com/AGhost-7/digitalocean-image-docker

## Ramblings
I figure that to fit all of these containers on a 20gb VPS server I'll need to
use customized images. Thanks to docker's image diffing, I should be able to
keep things at a relative minimum size by using the same image base for all
of my containers.
