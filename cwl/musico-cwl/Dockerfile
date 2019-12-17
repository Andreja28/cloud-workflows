FROM alpine:latest

USER root

RUN apk add curl
RUN apk add jq
RUN apk add --no-cache --upgrade bash
RUN apk add coreutils

WORKDIR /musico

COPY script.sh /opt/musico/
ENTRYPOINT ["bash", "/opt/musico/script.sh"]