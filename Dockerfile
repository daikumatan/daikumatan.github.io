FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y python-pip && \
    apt-get install -y python-sphinx && \
    apt-get install -y make && \
    pip install --upgrade pip && \
    pip install sphinx-autobuild && \
    pip install sphinxjp.themes.basicstrap && \
    easy_install blockdiag && \
    pip install sphinxcontrib-blockdiag && \
    mkdir /sphinx && \
    mkdir /script && \
    chmod 777 /sphinx
ADD autobuild_on_docker.sh /script/
EXPOSE 80
CMD ["/script/autobuild_on_docker.sh"]
