FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
	apt-get install -y python-pip && \
	pip install ansible requests && \
	apt-get purge -y build-essential python-all-dev --auto-remove && \
	apt-get clean -y && \
	rm -rf /var/lib/apt/lists/*

# docker is needed for some of the more advanced docker features.
ENV DOCKER_CLI_SHA256 "7ceb584cedba158b335fa2df11556cd70c6c528c7c93ceb3bf9aa13903e824cd"
ENV DOCKER_CLI_VERSION "18.06.0"

RUN apt-get update && \
	apt-get install -y debsums && \
	curl -o /tmp/docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION-ce.tgz" && \
	tar xvf /tmp/docker.tgz -C /tmp && \
	mv /tmp/docker/docker /usr/local/bin/docker && \
	rm -rf /tmp/docker* && \
	[ "$(sha256sum /usr/local/bin/docker | awk '{print $1}')" = "$DOCKER_CLI_SHA256" ] && \
	apt-get remove -y debsums

USER jenkins
