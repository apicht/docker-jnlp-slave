FROM jenkins/jnlp-slave:3.19-1-alpine

ARG DOCKER_GID=497

USER root

ENV VERSION "18.03.1-ce"
RUN apk add --no-cache curl shadow \
    && curl -L -o /tmp/docker-$VERSION.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$VERSION.tgz \
    && tar -xz -C /tmp -f /tmp/docker-$VERSION.tgz \
    && mv /tmp/docker/docker /usr/bin \
    && rm -rf /tmp/docker-$VERSION /tmp/docker \
    && apk del curl

RUN groupadd -g ${DOCKER_GID} -r docker \
    && usermod -G docker jenkins

USER jenkins
