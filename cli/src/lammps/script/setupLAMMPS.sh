#!/bin/sh

###############################################
# package URL
###############################################
PACKAGE_URL='http://lammps.sandia.gov/tars/lammps-17Nov16.tar.gz'
PACKAGE_NAME='lammps-17Nov16'

# working directory path is stored to "WORK_DIR"
WORK_DIR=$(pwd)

# check cores per cpu & sockets per node & cores per node
NUM_CPU_CORES=$(cat /proc/cpuinfo | grep "cpu cores" | uniq | head -1 | awk '{print $NF}')
NUM_SOCKETS=$(cat /proc/cpuinfo | grep "physical id" | uniq | wc -l)
NUM_NODE_CORES=$(expr ${NUM_CPU_CORES} \* ${NUM_SOCKETS})

# check variables
cat << EXT

PACKAGE_URL: $PACKAGE_URL
PACKAGE_NAME: $PACKAGE_NAME
WORK_DIR: $WORK_DIR
NUM_CPU_CORES: $NUM_CPU_CORES
NUM_SOCKETS: $NUM_SOCKETS
NUM_NODE_CORES: $NUM_NODE_CORES

EXT

# download the LAMMPS package
wget ${PACKAGE_URL}
gunzip -c ${PACKAGE_NAME}.tar.gz | tar xvf -

# move to src directory
cd ${PACKAGE_NAME}/src && pwd

# You can edit the MAKE/Makefile.mpi if necessary.
# sed -i ... MAKE/Makefile.mpi

# check the pakage-status
make package-status

###############################################
# the packages you need can be done "make"
###############################################
make yes-rigid
make yes-colloid
make yes-opt
make yes-mc
make yes-user-omp
###############################################

# compile the LAMMPS
make -j ${NUM_NODE_CORES} mpi

# check the binary
./lmp_mpi -help > ${WORK_DIR}/lmp_mpi_help.txt

# copy the binary to work directory
cp ./lmp_mpi ${WORK_DIR}

# delete packages
cd ${WORK_DIR}
rm -rf lammps-17Nov16

