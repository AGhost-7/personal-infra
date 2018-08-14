FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
	apt-get install -y python-pip && \
	pip install ansible requests && \
	apt-get purge -y build-essential python-all-dev --auto-remove && \
	apt-get clean -y && \
	rm -rf /var/lib/apt/lists/*

USER jenkins
