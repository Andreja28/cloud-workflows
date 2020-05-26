FROM ubuntu:20.04

USER root


RUN apt-get update
RUN apt-get install -y wine --no-install-recommends --no-install-suggests

WORKDIR /ventricles

COPY script.sh /ventricles/
COPY ventricles.exe /ventricles/
#COPY inputFile.txt /ventricles/
ENTRYPOINT ["bash", "/ventricles/script.sh", "/ventricles/ventricles.exe"]