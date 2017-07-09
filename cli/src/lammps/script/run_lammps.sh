#!/bin/sh


MPI_NUM_PROCS=$1
LAMMPS=./lmp_mpi

INPUT_FILE="in.n40setup"
mpirun -np ${MPI_NUM_PROCS} ${LAMMPS} -in ${INPUT_FILE}

INPUT_FILE="in.n40run1"
mpirun -np ${MPI_NUM_PROCS} ${LAMMPS} -in ${INPUT_FILE}



