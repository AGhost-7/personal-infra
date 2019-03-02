
FROM certbot/dns-digitalocean

# {{{ install tini for collecting zombie processes
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
# }}}

# {{{ install cron job runner
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.4/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=3a631023f9f9dd155cfa0d1bb517a063d375055a

RUN apk add --no-cache curl && \
        curl -fsSLO "$SUPERCRONIC_URL"  && \
        echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - && \
        chmod +x "$SUPERCRONIC" && \
        mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" && \
        ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic
# }}}

# {{{ install docker for reloading config
ENV DOCKER_CLI_SHA256 "7ceb584cedba158b335fa2df11556cd70c6c528c7c93ceb3bf9aa13903e824cd"
ENV DOCKER_CLI_VERSION "18.06.0"

RUN apk add --no-cache outils-sha256 && \
	curl -o /tmp/docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION-ce.tgz" && \
	tar xvf /tmp/docker.tgz -C /tmp && \
	mv /tmp/docker/docker /usr/local/bin/docker && \
	rm -rf /tmp/docker* && \
	[ "$(sha256sum /usr/local/bin/docker | awk '{print $1}')" = "$DOCKER_CLI_SHA256" ] && \
	apk del outils-sha256
# }}}

# {{{ job

RUN apk add --no-cache bash

ENV LOAD_BALANCER_CONTAINER=load_balancer

COPY ./crontab /etc/crontab
COPY ./renew-hook.sh /renew-hook.sh

RUN chmod +x /renew-hook.sh
# }}}

VOLUME /etc/certbot/secrets

CMD ["/usr/local/bin/supercronic", "/etc/crontab"]
