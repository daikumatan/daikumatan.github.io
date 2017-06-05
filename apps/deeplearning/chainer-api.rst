###################################
Chaniner Hands-on (CLI/API編)
###################################

**システム連携を目的にCLIによる操作を習得する**



Rescale API でもUpload/Downloadは可能ですが、Rescale CLIの方が、よりセキュアで高速な転送が可能なため、こちらを使います。具体的には Rescale CLIを使うことで、

- Rescale CLIを実行した場合、ファイル転送を https を使用するだけでなく、localマシンで暗号化/復号化を行い、Rescale Storageに直接アクセスする(2重に暗号化されS3に対して直接転送)
- ファイルを分割して複数のスレッドで転送するためAPIより高速

そのため、ここではファイル転送は Rescale API を使わず、Rescale CLI を使うこととします.

.. note::
    | 本ハンズオンは、コード部分をひたすらコピーして、Linux のTerminalに貼り付けてください
    | 間違わなければ、最後まで実行できるようになっています。

|

事前準備
==================================================

Rescale CLI/API設定
---------------------

Rescale CLI/API環境を設定されていない場合は :doc:`./setup` を実施してください



必要変数の設定確認
---------------------

.. code-block:: bash
    :caption: 変数の設定確認

    cat << ETX

    WORK_DIR: ${WORK_DIR}
    BIN: ${BIN}
    RESCALE_CLI_PATH: ${RESCALE_CLI_PATH}
    RESCALE_API_TOKEN: ${RESCALE_API_TOKEN}

    ETX

実行ディレクトリーの作成
------------------------------

.. code-block:: bash
    :caption: ハンズオンディレクトリの作成

    mkdir ${WORK_DIR}/chainerAPI
    cd ${WORK_DIR}/chainerAPI

|

ファイルのアップロード
==================================================


アップロードするサンプルの準備
----------------------------------------

.. code-block:: bash
    :caption: ランスクリプト ``run_chainer_from_API.sh`` の作成

    cat << EOF > run_chainer_from_API.sh
    #!/bin/sh
    wget https://github.com/pfnet/chainer/archive/v1.22.0.tar.gz
    tar xzf v1.22.0.tar.gz
    python chainer-1.22.0/examples/mnist/train_mnist.py -g 0

    EOF
    cat run_chainer_from_API.sh


ファイルのアップロードとファイルIDの取得
----------------------------------------

.. code-block:: bash
    :caption: アップロードしたいファイル名を決定

    FILENAME='run_chainer_from_API.sh'

.. code-block:: bash
    :caption: 変数の確認

    cat << ETX

    FILENAME: ${FILENAME}
    RESCALE_CLI_PATH: ${RESCALE_CLI_PATH}
    RESCALE_API_TOKEN: ${RESCALE_API_TOKEN}

    ETX


.. code-block:: bash
    :caption: ファイルのアップロードとファイルIDの取得

    JSON=$(java -jar ${RESCALE_CLI_PATH}/rescale.jar \
    -X https://platform.rescale.jp/ \
    --quiet upload \
    -p ${RESCALE_API_TOKEN} \
    -f ${FILENAME} \
    -e) && echo ${JSON}

.. code-block:: json
    :caption: 結果例(返り値)

    {"success":true,"startTime":1496576499829,"endTime":1496576501642,"files":[{"name":"run_chainer_from_API.sh","storage":{"storageType":"S3Storage","id":"pCTMk","encryptionType":"default","connectionSettings":{"region":"ap-northeast-1"}},"pathParts":{"path":"user/user_QbQWc/run_chainer_from_API.sh-a688855d-c99a-4145-959a-8c1b930ce01b","container":"jpprod-rescale-platform"},"isUploaded":true,"decryptedSize":152,"encodedEncryptionKey":"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","typeId":1,"md5":"88484647e1d2c00ca5407f22635703bc","id":"JVHffb"}]}

.. code-block:: bash
    :caption: jqによるファイルIDの抽出

    FILE_ID=$(echo ${JSON} | jq -r .files[].id) && echo ${FILE_ID}

.. code-block:: bash
    :caption: 結果例(返り値)

    JVHffb

ジョブの作成 Create Job
==========================

JSONにより計算環境を定義する
---------------------------

``${FILENAME}`` と ``${FILE_ID}`` にちゃんと値が入っていることを確認してください。

.. code-block:: bash
    :caption: jsonの作成

    cat << EOF > rescale.json
    {
        "name": "Hello Chainer!",
        "jobanalyses": [
            {
                "useMpi": "true",
                "command": "./${FILENAME}",
                "analysis": {
                    "code": "chainer",
                    "name": "Chainer",
                    "version": "1.22.0-cuda8-gpu-centos"
                },
                "hardware": {
                    "coresPerSlot": 2,
                    "slots": 1,
                    "coreType": "obsidian"
                },
                "inputFiles": [
                    {
                        "id":"${FILE_ID}"
                    }
                ]

            }
        ],
        "isLowPriority": "true"
    }
    EOF
    cat rescale.json

.. code-block:: bash
    :caption: 結果例(返り値)

    (上記と同じJSON。ただし、${FILENAME}`` と ${FILE_ID} の変数に値が入っていること)


ジョブを生成する
---------------------------

.. code-block:: bash
    :caption: jsonの変数への格納

    MY_JSON=$(cat rescale.json)

.. code-block:: bash
    :caption: 変数の確認

    cat << ETX

    RESCALE_API_TOKEN: ${RESCALE_API_TOKEN}
    MY_JSON: ${MY_JSON}

    ETX

.. code-block:: bash
    :caption: create Rescale Job with RescaleAPI

    JOB_JSON=$(curl -s -X POST \
    -H "Authorization: Token ${RESCALE_API_TOKEN}" \
    -H "Content-Type: application/json" \
    https://platform.rescale.jp/api/v2/jobs/ \
    -d "${MY_JSON}") && echo ${JOB_JSON}


.. code-block:: bash
    :caption: JOB ID を取得する

    JOB_ID=$(echo ${JOB_JSON} | jq -r .id) && echo ${JOB_ID}


.. code-block:: bash
    :caption: 結果例(返り値)

    tGaYS


ジョブ生成確認
---------------------

必要に応じて、Browserを開いて、ジョブが作成されていることを確認してください。

|

ジョブの実行 Submit Job
===================================

.. code-block:: bash
    :caption: 変数の確認

    cat << ETX

    RESCALE_API_TOKEN: ${RESCALE_API_TOKEN}
    JOB_ID: ${JOB_ID}

    ETX

.. code-block:: bash
    :caption: JOB ID を取得する

    curl -s -X POST -H "Authorization: Token ${RESCALE_API_TOKEN}" \
    https://platform.rescale.jp/api/v2/jobs/${JOB_ID}/submit/

|


ジョブのモニタリング
===================================

.. code-block:: bash
    :caption: 変数の確認

    cat << ETX

    RESCALE_API_TOKEN: ${RESCALE_API_TOKEN}
    JOB_ID: ${JOB_ID}

    ETX

.. code-block:: bash
    :caption: JOB ID を取得する

    curl -s -H "Authorization: Token ${RESCALE_API_TOKEN}" \
    https://platform.rescale.jp/api/v2/jobs/${JOB_ID}/statuses/ \
    | jq .


.. code-block:: json
    :caption: 結果例(返り値): 時間とともにClusterの状態が変化しこのJSONも変化します

    {
      "count": 4,
      "previous": null,
      "results": [
        {
          "status": "Validated",
          "statusDate": "2017-06-04T11:55:35.002000Z",
          "id": "xoxfp",
          "statusReason": null,
          "jobId": "tGaYS"
        },
        {
          "status": "Started",
          "statusDate": "2017-06-04T11:55:34.686000Z",
          "id": "iMDtd",
          "statusReason": null,
          "jobId": "tGaYS"
        },
        {
          "status": "Queued",
          "statusDate": "2017-06-04T11:55:32.002868Z",
          "id": "kdxfp",
          "statusReason": null,
          "jobId": "tGaYS"
        },
        {
          "status": "Pending",
          "statusDate": "2017-06-04T11:55:18.069054Z",
          "id": "WADtd",
          "statusReason": null,
          "jobId": "tGaYS"
        }
      ],
      "next": null
    }

ファイルのダウンロード
===============================

Rescale CLIによるファイルダウンロード
--------------------------------------

この例ではログをダウンロードすることとします。

.. code-block:: bash
    :caption: ダウンロードするファイル名の決定

    DOWNLOAD_FILES="*.log"

.. code-block:: bash
    :caption: 変数の確認

    cat << ETX

    RESCALE_CLI_PATH: ${RESCALE_CLI_PATH}
    RESCALE_API_TOKEN: ${RESCALE_API_TOKEN}
    DOWNLOAD_FILES: ${DOWNLOAD_FILES}
    JOB_ID: ${JOB_ID}

    ETX

.. code-block:: bash
    :caption: ファイルをダウンロードする

    java -jar ${RESCALE_CLI_PATH}/rescale.jar \
    -X https://platform.rescale.jp/ sync \
    -p "${RESCALE_API_TOKEN}" -j "${JOB_ID}" -f "${DOWNLOAD_FILES}"

ダウンロードファイルの確認
------------------------

``rescale_job_<JOB_ID>`` という名前のディレクトリが作成され、その中に "process_output.log" というファイルがあることを確認してください

.. code-block:: bash
    :caption: ファイルをダウンロードする

    ls rescale_job_*

.. code-block:: bash
    :caption: 結果例

    process_output.log
