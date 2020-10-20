FROM python

WORKDIR /torso/

ADD templates /torso/templates
ADD torso_preprocessor.py /torso/
ADD script.sh /torso/

ENTRYPOINT [ "bash", "/torso/script.sh" ]