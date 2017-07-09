###########################################################
USECASE2: lammps 必要パッケージをmakeし利用する
###########################################################

ランスクリプト
==========================

.. code-block:: bash
    :caption: run_lammps.sh
    :linenos:

    #!/bin/sh -f
    #RESCALE_NAME=my_lammps_with_RescaleCLI
    #RESCALE_CORES=4
    #RESCALE_CORE_TYPE=hpc-3
    #RESCALE_LOW_PRIORITY=true
    #RESCALE_ANALYSIS=user_included_mpi
    #RESCALE_ANALYSIS_VERSION=openmpi-1.6-el6

    ###############################################
    # package URL
    ###############################################
    PACKAGE_URL='http://lammps.sandia.gov/tars/lammps-17Nov16.tar.gz'
    PACKAGE_NAME='lammps-17Nov16'
    NUM_NODE_CORES=4
    WORK_DIR=$(pwd)

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


    #
    # start solver
    #
    LAMMPS=./lmp_mpi

    INPUT_FILE="in.n40setup"
    mpirun -np ${RESCALE_CORES_PER_SLOT} ${LAMMPS} -in ${INPUT_FILE}

    INPUT_FILE="in.n40run1"
    mpirun -np ${RESCALE_CORES_PER_SLOT} ${LAMMPS} -in ${INPUT_FILE}

    # clean files
    rm -rf lammps-17Nov16
    rm ${PACKAGE_NAME}.tar.gz


Submit job
==========================

.. code-block:: bash
    :caption: ジョブの実行

    RUNSCRIPT="run_lammps.sh"
    DOWNLOAD_FILES="*.log"

    java -jar /usr/local/bin/rescale.jar \
    -X https://platform.rescale.jp/ submit \
    -p ${RESCALE_API_TOKEN} \
    -E -i ${RUNSCRIPT} -f ${DOWNLOAD_FILES}
