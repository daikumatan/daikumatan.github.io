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
    pip install sphinxcontrib-actdiag && \
    mkdir /sphinx && \
    mkdir /script && \
    chmod 777 /sphinx
# 日本語環境
#RUN apt-get install -y language-pack-ja-base \
#                       language-pack-ja \
#                       ibus-mozc \
#                       man \
#                       manpages-ja && \
#    update-locale LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja
#RUN apt-get update
#ENV LANG ja_JP.UTF-8
#ENV LC_ALL ja_JP.UTF-8
#ENV LC_CTYPE ja_JP.UTF-8

ADD autobuild_on_docker.sh /script/
EXPOSE 80
CMD ["/script/autobuild_on_docker.sh"]
