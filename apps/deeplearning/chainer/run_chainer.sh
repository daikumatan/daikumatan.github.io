#!/bin/sh -f
#RESCALE_NAME=chainerCli
#RESCALE_CORES=4
#RESCALE_CORE_TYPE=gpu-kepler
#RESCALE_LOW_PRIORITY=off
#RESCALE_ANALYSIS=chainer
#RESCALE_ANALYSIS_VERSION=1.7.0-chainer-gpu
#RESCALE_EXISTING_FILES=qLJkhb

cd chainer/
python chainer-1.7.0/examples/mnist/train_mnist.py -g 0


