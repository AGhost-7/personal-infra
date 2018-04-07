FROM firehol/netdata

ENV DOCKER_CLI_SHA256 "7dcd87ba776743b3cdf584fb54b85318ac4e4671e1c1afc24e24697f9e101a2d"
ENV DOCKER_CLI_VERSION "17.09.0"

# Download only the docker client as the host already has the daemon.
RUN apt-get update && \
	apt-get install -y debsums && \
	curl -o /tmp/docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION-ce.tgz" && \
	tar xvf /tmp/docker.tgz -C /tmp && \
	mv /tmp/docker/docker /usr/local/bin/docker && \
	rm -rf /tmp/docker* && \
	[ "$(sha256sum /usr/local/bin/docker | awk '{print $1}')" = "$DOCKER_CLI_SHA256" ] && \
	apt-get remove -y debsums

COPY ./netdata.conf /etc/netdata/netdata.conf
