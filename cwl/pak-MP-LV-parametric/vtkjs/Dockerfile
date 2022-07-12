FROM python:3.8.10-buster

RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y
RUN pip install vtk

WORKDIR /vtkjs/

ADD helper.py /vtkjs/
ADD main.py /vtkjs/