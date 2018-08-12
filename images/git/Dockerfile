FROM alpine

RUN apk add --no-cache openssh git bash

RUN adduser -D -s /usr/bin/git-shell git && \
	echo git:12345 | chpasswd

COPY ./entrypoint.sh /entrypoint.sh
COPY ./sshd_config /etc/ssh/sshd_config

# https://git-scm.com/docs/git-shell
COPY ./no-interactive-login /home/git/git-shell-commands/no-interactive-login

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /keys

VOLUME /repos

CMD ["/usr/sbin/sshd", "-D"]
