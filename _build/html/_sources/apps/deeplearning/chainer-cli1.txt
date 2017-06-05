###################################
Chaniner Hands-on (CLI編)
###################################

**システム連携を目的にCLIによる操作を習得する**

.. note::
    | 本ハンズオンは、コード部分をひたすらコピーして、Linux のTerminalに貼り付けてください
    | 間違わなければ、最後まで実行できるようになっています。

|

事前準備
==================================================

Rescale CLI/API環境を設定されていない場合は :doc:`./setup` を実施してください

|

ランスクリプトの作成
==================================================


.. code-block:: bash
    :caption: chainer 実行ディレクトリの作成と移動

    mkdir ${WORK_DIR}/chainer && cd ${WORK_DIR}/chainer


.. code-block:: bash
    :caption: chainer ランスクリプト ``run_chainer.sh`` の作成

    cat << EOF > run_chainer.sh
    #!/bin/sh -f
    #RESCALE_NAME=chainer-1.22.0-mnist-with-RescaleCli
    #RESCALE_CORES=2
    #RESCALE_CORE_TYPE=obsidian
    #RESCALE_LOW_PRIORITY=true
    #RESCALE_ANALYSIS=chainer
    #RESCALE_ANALYSIS_VERSION=1.22.0-cuda8-gpu-centos

    # download/uncompress chainer sample model
    wget https://github.com/pfnet/chainer/archive/v1.22.0.tar.gz
    tar xzf v1.22.0.tar.gz

    # start chainer w/ GPU
    python chainer-1.22.0/examples/mnist/train_mnist.py -g 0

    EOF

|


Rescaleへのジョブ投入
==================================================

Upload/Download ファイルの指定
---------------------------------

.. code-block:: bash
    :caption: ランスクリプトとダウンロードする結果ファイルを指定

    RUNSCRIPT="run_chainer.sh"
    DOWNLOAD_FILES="*.log"

|

Rescale ジョブの投入 (学習の開始)
---------------------------------

.. code-block:: bash
    :caption: 変数の確認

    cat << ETX

    RUNSCRIPT: ${RUNSCRIPT}
    DOWNLOAD_FILES: ${DOWNLOAD_FILES}
    RESCALE_CLI_PATH: ${RESCALE_CLI_PATH}
    RESCALE_API_TOKEN: ${RESCALE_API_TOKEN}

    ETX

.. code-block:: bash
    :caption: ジョブ投入

    java -jar ${RESCALE_CLI_PATH}/rescale.jar \
        -X https://platform.rescale.jp/ submit \
        -p ${RESCALE_API_TOKEN} \
        -E -i ${RUNSCRIPT} -f ${DOWNLOAD_FILES}

.. code-block:: bash
    :caption: 結果例(返り値)

    2017-06-04 04:23:44,452 - Authenticated as daisuke@rescale.com
    2017-06-04 04:23:44,460 - Executing Command.
    2017-06-04 04:23:44,464 - Parsing Input Files
    2017-06-04 04:23:44,464 - No existing files to include
    2017-06-04 04:23:46,228 - Found Analysis: chainer
    2017-06-04 04:23:46,295 - No project with the specified name was found: null
    2017-06-04 04:23:46,295 - Zipping Files
    2017-06-04 04:23:46,295 - Creating temporary encrypted zip at /enc/ujpprod.gbkKo/work/chainer/input.zip
    2017-06-04 04:23:46,317 - Finished writing encrypted file
    2017-06-04 04:23:46,317 - Uploading Files
    2017-06-04 04:23:46,320 - Uploading: /enc/ujpprod.gbkKo/work/chainer/run.sh
    2017-06-04 04:23:46,322 - Uploading run.sh:
    2017-06-04 04:23:47,927 - ##############################| 432B / 432B
    2017-06-04 04:23:48,176 - Uploading: /enc/ujpprod.gbkKo/work/chainer/input.zip
    2017-06-04 04:23:48,176 - Uploading input.zip:
    2017-06-04 04:23:48,247 - ##############################| 784B / 784B
    2017-06-04 04:23:48,566 - Job: Saving Job
    2017-06-04 04:23:48,942 - Job bjkKo: Saved
    2017-06-04 04:23:48,943 - Job bjkKo: Submitting
    2017-06-04 04:23:49,810 - Job bjkKo: Starting polling cycle
    2017-06-04 04:24:49,878 - Job bjkKo: Status - Validated
    2017-06-04 04:25:49,937 - Job bjkKo: Status - Validated
    2017-06-04 04:26:49,984 - Job bjkKo: Status - Validated
    2017-06-04 04:27:50,041 - Job bjkKo: Status - Validated
    2017-06-04 04:28:50,144 - Job bjkKo: Status - Validated
    2017-06-04 04:29:50,195 - Job bjkKo: Status - Validated
    2017-06-04 04:30:50,243 - Job bjkKo: Status - Validated
    2017-06-04 04:31:50,303 - Job bjkKo: Status - Executing
    2017-06-04 04:32:50,352 - Job bjkKo: Status - Executing
    2017-06-04 04:33:50,397 - Job bjkKo: Status - Executing
    2017-06-04 04:34:50,509 - Job bjkKo: Status - Executing
    2017-06-04 04:35:50,554 - Job bjkKo: Status - Executing
    2017-06-04 04:36:50,609 - Job bjkKo: Status - Executing
    2017-06-04 04:37:50,674 - Job bjkKo: Status - Executing
    2017-06-04 04:38:50,719 - Job bjkKo: Status - Completed
    2017-06-04 04:38:50,720 - Job bjkKo: Finished...
    2017-06-04 04:38:50,720 - Job bjkKo: Downloading files to /enc/ujpprod.gbkKo/work/chainer/output
    2017-06-04 04:39:17,322 - Downloading /enc/ujpprod.gbkKo/work/chainer/output/process_output.log
    2017-06-04 04:39:17,323 - Downloading process_output.log:
    2017-06-04 04:39:17,541 - ##############################| 50.22KB / 50.22KB
    2017-06-04 04:39:23,951 - Finished downloading files.

|

結果ファイルの確認
==================================================

RescaleCLIを実行したディレクトリーに ``output/`` という名前のディレクトリーが作成されています。

その直下に、指定したファイルがダウンロードされています。

.. code-block:: bash
    :caption: process_output.logがダウンロードされていることを確認

    cat output/process_output.log
