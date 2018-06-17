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

RUN apk --no-cache add --virtual build-dependencies gcc g++ musl-dev go \
    && go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login \
    && cp /home/jenkins/go/bin/docker-credential-ecr-login /usr/local/bin/docker-credential-ecr-login \
    && apk del --purge -r build-dependencies \
    && rm -rf ~/go

COPY docker-config.json /home/jenkins/.docker/config.json

RUN groupadd -g ${DOCKER_GID} -r docker \
    && usermod -G docker jenkins

USER jenkins
