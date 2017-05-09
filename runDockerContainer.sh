#!/bin/sh

SRC_DIR=$(pwd)
DEST_DIR="/sphinx"
IMAGE="daikumatan/sphinx"

docker run -it -v ${SRC_DIR}:${DEST_DIR} ${IMAGE} /bin/bash
#docker run -it -p 80:80 ${IMAGE} /bin/bash
#docker run -t -v ${SRC_DIR}:${DEST_DIR} ${IMAGE}
