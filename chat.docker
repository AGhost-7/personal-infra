# vim: set ft=dockerfile:

FROM 1science/sbt

RUN apk update && \
	apk add git && \
	git clone -b docker --depth 1 https://github.com/AGhost-7/NinjaChat.git /chat && \
	apk del git

WORKDIR /chat

RUN sbt clean compile stage

CMD ["/chat/target/universal/stage/bin/ninja-chat"]
