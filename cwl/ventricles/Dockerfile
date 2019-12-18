FROM debian:buster

USER root


RUN apt-get update
RUN apt-get install -y wine --no-install-recommends --no-install-suggests
WORKDIR /ventricles

COPY script.sh /opt/ventricles/
COPY ventricles.exe /opt/ventricles/
ENTRYPOINT ["bash", "/opt/ventricles/script.sh", "/opt/ventricles/ventricles.exe"]