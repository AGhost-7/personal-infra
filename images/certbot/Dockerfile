
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

# {{{ job

RUN apk add --no-cache bash

COPY ./crontab /etc/crontab
COPY ./renew-hook.sh /renew-hook.sh

RUN chmod +x /renew-hook.sh
# }}}

VOLUME /etc/certbot/secrets

CMD ["/usr/local/bin/supercronic", "/etc/crontab"]
