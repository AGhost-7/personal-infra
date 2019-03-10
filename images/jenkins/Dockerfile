FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
	apt-get install -y python-pip && \
	pip install ansible requests && \
	apt-get purge -y build-essential python-all-dev --auto-remove && \
	apt-get clean -y && \
	rm -rf /var/lib/apt/lists/*

# docker is needed for some of the more advanced docker features.
ENV DOCKER_CLI_SHA256 "918372dd8cc56616b32b0f67432e2f6b4b27541728d6f9529543a5d73d955100"
ENV DOCKER_CLI_VERSION "18.09.3"

RUN apt-get update && \
	apt-get install -y debsums && \
	curl -L -o /tmp/docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION.tgz" && \
	tar xzf /tmp/docker.tgz -C /tmp && \
	mv /tmp/docker/docker /usr/local/bin/docker && \
	rm -rf /tmp/docker* && \
	[ "$(sha256sum /usr/local/bin/docker | awk '{print $1}')" = "$DOCKER_CLI_SHA256" ] && \
	apt-get remove -y debsums

USER jenkins
