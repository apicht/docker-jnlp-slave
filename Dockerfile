FROM jenkins/jnlp-slave:3.19-1-alpine

ARG DOCKER_GID=497

USER root

ENV DOCKER_VERSION "18.03.1-ce"

RUN apk add --no-cache curl shadow \
    && curl -L -o /tmp/docker-$DOCKER_VERSION.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz \
    && tar -xz -C /tmp -f /tmp/docker-$DOCKER_VERSION.tgz \
    && mv /tmp/docker/docker /usr/bin \
    && rm -rf /tmp/docker-$DOCKER_VERSION /tmp/docker \
    && git clone https://github.com/kamatama41/tfenv.git /home/jenkins/tfenv \
    && ln -s /home/jenkins/tfenv/bin/* /usr/local/bin \
    && wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.16.3/terragrunt_linux_amd64 \
    && mv terragrunt_linux_amd64 /usr/local/bin/terragrunt \
    && chmod +x /usr/local/bin/terragrunt \
    && chown -R jenkins:jenkins /home/jenkins/tfenv

RUN apk --no-cache add \
        python \
        python3 \
        py-pip \
        groff \
        less \
        mailcap \
        jq \
        && \
    pip install --upgrade --no-cache-dir awscli s3cmd python-magic ssm-diff && \
    apk --purge del py-pip

RUN groupadd -g ${DOCKER_GID} -r docker \
        && usermod -aG docker jenkins \
        && usermod -aG users jenkins 

USER jenkins

RUN mkdir -p /home/jenkins/.ssh \
    && tfenv install 0.11.7 \
    && tfenv use 0.11.7 

#ENTRYPOINT ["jenkins-slave"]
