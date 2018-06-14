FROM jenkins/jnlp-slave:3.19-1-alpine

USER root
RUN apk add --no-cache curl

ENV VERSION "18.03.1-ce"
RUN curl -L -o /tmp/docker-$VERSION.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$VERSION.tgz \
    && tar -xz -C /tmp -f /tmp/docker-$VERSION.tgz \
    && mv /tmp/docker/docker /usr/bin \
    && rm -rf /tmp/docker-$VERSION /tmp/docker

USER jenkins
