FROM debian:buster                                                                                                                                                                                                                              
USER root                                                                                                                                                                                                                                                                                                                                                               
RUN apt-get update                                                                                                      
RUN apt-get install -y wine --no-install-recommends --no-install-suggests
RUN dpkg --add-architecture i386 && apt-get -y update && apt-get -y install wine32 --no-install-recommends --no-install-suggests                                        
WORKDIR /pak

COPY PakC /pak/
COPY script.sh /pak/

ENTRYPOINT [ "bash", "/pak/script.sh" ]



