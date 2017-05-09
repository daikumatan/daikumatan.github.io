FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y python-sphinx && \
    apt-get install -y make && \
    apt-get install -y python-pip && \
    pip install sphinx-autobuild && \
    pip install --upgrade pip && \
    mkdir /sphinx && \
    mkdir /script && \
    chmod 777 /sphinx
ADD autobuild_on_docker.sh /script/
EXPOSE 80
CMD ["/script/autobuild_on_docker.sh"]

