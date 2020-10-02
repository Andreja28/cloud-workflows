FROM alpine

WORKDIR /preprocess/
ADD preprocess/ /preprocess/

ENTRYPOINT [ "ash", "/preprocess/script.sh", "/preprocess/pakh-template.DAT" ]