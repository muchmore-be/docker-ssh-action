FROM docker:stable

LABEL "name"="Remote Docker Command"
LABEL "maintainer"="Guus De Graeve <guus@muchmore.be>"

LABEL "com.github.actions.name"="Remote Docker Command (ssh)"
LABEL "com.github.actions.description"="Run docker commands on a remote docker host (ssh)."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="blue"

RUN apk --no-cache add openssh-client

RUN mkdir -p ~/.ssh
ADD ssh-config ~/.ssh/config

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]