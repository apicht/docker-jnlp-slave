FROM jenkins/jnlp-slave:3.19-1-alpine

ARG DOCKER_GID=497

USER root

ENV DOCKER_VERSION "18.03.1-ce"
RUN apk add --no-cache curl shadow \
    && curl -L -o /tmp/docker-$DOCKER_VERSION.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz \
    && tar -xz -C /tmp -f /tmp/docker-$DOCKER_VERSION.tgz \
    && mv /tmp/docker/docker /usr/bin \
    && rm -rf /tmp/docker-$DOCKER_VERSION /tmp/docker \
    && apk del curl

RUN apk --no-cache add \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        && \
    pip install --upgrade --no-cache-dir awscli s3cmd python-magic && \
    apk --purge del py-pip

RUN groupadd -g ${DOCKER_GID} -r docker \
    && usermod -G docker jenkins

USER jenkins
