FROM centos:latest

RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y make && \
    yum install -y python-sphinx && \
    yum install -y python-pip && \
    pip install --upgrade pip && \
    pip install sphinx-autobuild && \
    pip install sphinx_rtd_theme && \
    pip install sphinxjp.themes.basicstrap && \
    easy_install blockdiag && \
    pip install sphinxcontrib-blockdiag && \
    mkdir /sphinx && \
    chmod 777 /sphinx
    CMD ["/bin/sphinx-autobuild", "/sphinx", "/sphinx/_build/html"]

