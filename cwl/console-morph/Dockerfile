FROM debian:buster

USER root


RUN apt-get update
RUN apt-get install -y wine --no-install-recommends --no-install-suggests
WORKDIR /morph

COPY script.sh /morph/
COPY console-morph/ /morph/

ENTRYPOINT [ "bash", "/morph/script.sh"]