FROM ubuntu

USER root

RUN apt-get update && apt-get install -y unzip

ADD start.sh /opt

ENTRYPOINT ["sh", "/opt/start.sh"]