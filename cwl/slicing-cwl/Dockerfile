FROM ubuntu:20.04
ENV TZ=Europe/Belgrade
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update -y && apt-get install -y python3-paraview

WORKDIR /slicing/

ADD vtkClipper.py /slicing/
ADD script.sh /slicing/
ENTRYPOINT [ "bash", "/slicing/script.sh" ]