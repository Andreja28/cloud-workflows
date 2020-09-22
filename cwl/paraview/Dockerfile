FROM ubuntu:18.04

RUN apt-get update -y && apt-get install -y paraview

WORKDIR /ensi/

ADD main.py /ensi/

ENTRYPOINT [ "pvpython", "/ensi/main.py" ]