#dockerfile for running carpentries offline on a PC or cloud server
from debian:bullseye-slim


RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata \
    unzip git wget sudo curl

COPY setup.sh /
COPY docker-startup.sh /
RUN /setup.sh

ENTRYPOINT /docker-startup.sh
