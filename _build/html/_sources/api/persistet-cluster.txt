##########################################################################
Persisstent Cluster Hands-on with Resacle API
##########################################################################

上から順にコピペすれば、動くようにしております

Precondition (前提)
======================

.. code-block:: bash
    :caption: [command] APIキーの設定

    RESCALE_API_TOKEN=<'APIキー'>


ここから下のグレーのコード領域は、お手持ちのターミナルにコピペするだけで、一通りのハンズオンが可能です。

.. code-block:: bash
    :caption: [command] 作業環境の構築

    workDir=$(pwd)
    script=${workDir}/api
    mkdir ${script}
    export PATH=${script}:$PATH

|

Create the persistent cluster (永続クラスタを定義する)
========================================================

Sample code (スクリプトの作成)
---------------------------------

起動するClusterの条件をJSONで定義します。

.. code-block:: bash
    :caption: [command] ファイル名の決定

    CLUSTER_JSON="testCluster.json"


.. code-block:: bash
    :caption: [command] jsonファイルの作成

    cat << EOF > ${CLUSTER_JSON}
    {
      "name": "Untitled Cluster 3",
      "hardware": {
        "coresPerSlot": 1,
        "slots": 1,
        "coreType": {
          "code": "hpc-3"
        },
        "walltime": 10
      },
      "installedAnalyses": [
        {
          "analysis": {
            "code": "user_included",
            "version": "0"
          }
        }
      ],
      "runLowPriority": true
    }
    EOF


上記JSONに従ってJOBをCreateするためのスクリプトを作成します。

.. code-block:: bash
    :caption: [command] ヒアドキュメントによるスクリプトの生成

    cat << EOF > ${script}/rescale-createPersistentCluster
    #!/bin/sh

    clusterJsonFile=\$1
    token=\${RESCALE_API_TOKEN}

    _create_job()
    {
    rescaleJson=\$1
    echo \$rescaleJson | jq . > _jobanalyses.json 2>/dev/null
    curl -s -X POST \
    -H "Authorization: Token \${token}" \
    -H "Content-Type: application/json" \
    https://platform.rescale.jp/api/v3/clusters/ \
    -d "\${rescaleJson}"
    }

    _my_jobanalyses()
    {
    jsonFile=\$1
    cat \${jsonFile}
    }

    # Rescaleに送るためのJSONを作る
    # 普段ブラウザ上で行う作業をJSONで表現する
    jobAnalysesJson=\$(_my_jobanalyses \${clusterJsonFile})

    # バラバラにならないように、" " で囲むこと。
    # スペースが入っているため、引数1で全てを送る必要がある
    r=\$(_create_job "\${jobAnalysesJson}")
    echo \$r
    EOF


.. code-block:: bash
    :caption: [command]実行権限付与

    chmod +x ${script}/rescale-createPersistentCluster

|



Create Job
--------------------------------------------------------------

.. code-block:: bash
    :caption: [command]変数の確認

    cat << ETX

    CLUSTER_JSON: ${CLUSTER_JSON}
    RESCALE_API_TOKEN: ${RESCALE_API_TOKEN}

    ETX


.. code-block:: bash
    :caption: [command] createCluster

    createClusterJson=$(rescale-createPersistentCluster ${CLUSTER_JSON})
    clusterId=$(echo ${createClusterJson} | jq -r .id) && echo ${clusterId}


.. code-block:: bash
    :caption: 返り値

    kvHyW

|

Start the persistent cluster (永続クラスタの起動)
========================================================

Sample code (スクリプトの作成)
---------------------------------


.. code-block:: bash
    :caption: [command] ヒアドキュメントによるスクリプトの生成

    cat << EOF > ${script}/rescale-startPersistenCluster
    #!/bin/sh

    CLUSTER_ID=\$1
    TOKEN="\${RESCALE_API_TOKEN}"

    curl -s -X POST -H "Authorization: Token \${TOKEN}" \
    https://platform.rescale.jp/api/v3/clusters/\${CLUSTER_ID}/start/
    EOF


.. code-block:: bash
    :caption: [command] 実行権限付与

    chmod +x ${script}/rescale-startPersistenCluster

|


Submit Job (実行例)
---------------------------------------------

.. code-block:: bash
    :caption: [command] 変数の確認

    cat << ETX

    RESCALE_API_TOKEN: ${RESCALE_API_TOKEN}
    clusterId: ${clusterId}

    ETX


.. code-block:: bash
    :caption: [command] コマンドの実行

    rescale-startPersistenCluster ${clusterId}

.. code-block:: bash
    :caption: 返り値

    (empty body: This returns a 204 on success.)


Poll the cluster 永続クラスタの状態確認
===============================================


Sample code (スクリプトの作成)
---------------------------------

.. code-block:: bash
    :caption: [command]ヒアドキュメントによるスクリプトの生成

    cat << EOF > ${script}/rescale-pollCluster
    #!/bin/sh

    CLUSTER_ID=\$1
    TOKEN="\${RESCALE_API_TOKEN}"

    curl -s -X GET -H "Authorization: Token \${TOKEN}" \
    https://platform.rescale.jp/api/v3/clusters/\${CLUSTER_ID}/statuses/
    EOF


.. code-block:: bash
    :caption: [command]実行権限付与

    chmod +x ${script}/rescale-pollCluster

|

Check the Cluster Status (実行例)
--------------------------------------------------

.. code-block:: bash
    :caption: [command]変数の確認

    cat << ETX

    RESCALE_API_TOKEN: ${RESCALE_API_TOKEN}
    clusterId: ${clusterId}

    ETX


.. code-block:: bash
    :caption: [command]コマンドの実行

    rescale-pollCluster ${clusterId} | jq .

.. code-block:: json
    :caption: result

    {
      "count": 5,
      "previous": null,
      "results": [
        {
          "status": "Started",
          "statusDate": "2017-02-26T15:48:08.253000Z",
          "clusterId": "kvHyW",
          "id": "tuStgb",
          "statusReason": null
        },
        {
          "status": "Starting",
          "statusDate": "2017-02-26T15:45:29.083000Z",
          "clusterId": "kvHyW",
          "id": "eSYGV",
          "statusReason": null
        },
        {
          "status": "Queued",
          "statusDate": "2017-02-26T15:45:25.190627Z",
          "clusterId": "kvHyW",
          "id": "gjStgb",
          "statusReason": null
        },
        {
          "status": "Pending",
          "statusDate": "2017-02-26T15:45:24.073813Z",
          "clusterId": "kvHyW",
          "id": "SGYGV",
          "statusReason": null
        },
        {
          "status": "Not Started",
          "statusDate": "2017-02-26T15:17:44.251868Z",
          "clusterId": "kvHyW",
          "id": "BHkXdb",
          "statusReason": null
        }
      ],
      "next": null
    }


ジョブの生成
==============================

Sample code (スクリプトの作成)
---------------------------------

.. code-block:: bash
    :caption: [command]ジョブ定義用jsonファイル名の決定

    JOB_JSON="testJob.json"


.. code-block:: bash
    :caption: [command] JSONによるジョブの定義

    cat << EOF > ${JOB_JSON}
    {
      "name": "Test Job",
      "jobanalyses": [
        {
          "analysis": {
            "code": "user_included",
            "version": "0"
          },
          "command": "echo hello",
          "flags": {},
          "hardware": {
            "coresPerSlot": 1,
            "slots": 1,
            "coreType": {
              "code": "hpc-3"
            },
            "walltime": 10
          },
          "inputFiles": []
        }
      ],
      "isLowPriority": "true"
    }
    EOF


.. code-block:: bash
    :caption: [command]ヒアドキュメントによるスクリプトの生成

    cat << EOF > ${script}/rescale-createJob-v3
    #!/bin/sh

    jobJson=\$1
    declare -a fileIds=(\${@:2})
    token=\${RESCALE_API_TOKEN}

    _create_job()
    {
    rescaleJson=\$1
    echo \$rescaleJson | jq . > _jobanalyses.json 2>/dev/null
    curl -s -X POST \
    -H "Authorization: Token \${token}" \
    -H "Content-Type: application/json" \
    https://platform.rescale.jp/api/v3/jobs/ \
    -d "\${rescaleJson}"
    }

    _my_jobanalyses()
    {
    json=\$1
    cat \${json}
    }

    _create_rescaleJson()
    {
    json=\$1
    declare -a ids=(\${@:2})
    buff=\$(_my_jobanalyses \${json} | jq '.jobanalyses[0] |= .+ {"inputFiles": []}')

    if [ \$# -gt 0 ];then
        for thisId in \${ids[*]}
    do
        buff=\$(echo \${buff} | jq ".jobanalyses[0].inputFiles |= .+[{"id": \"\${thisId}\"}]")
            done
            echo \${buff}
    elif [ \$# -eq 0 ];then
        _my_jobanalyses \${json}
    else
        exit 1
    fi
    }

    #
    # Rescaleに送るためのJSONを作る
    # 普段ブラウザ上で行う作業をJSONで表現される
    #
    jobAnalysesJson=\$(_create_rescaleJson \${jobJson} \${fileIds[*]})


    # バラバラにならないように、" " で囲むこと。
    # スペースが入っているため、引数1で全てを送る必要がある

    r=\$(_create_job "\${jobAnalysesJson}")
    echo \$r
    EOF


.. code-block:: bash
    :caption: [command]実行権限付与

    chmod +x ${script}/rescale-createJob-v3

|


Create Job: (実行例)
---------------------------------------------

.. code-block:: bash
    :caption: [command]変数の確認

    cat << ETX

    RESCALE_API_TOKEN: ${RESCALE_API_TOKEN}
    JOB_JSON: ${JOB_JSON}
    fileId: ${fileId}
    clusterId: ${clusterId}

    ETX


.. code-block:: bash
    :caption: [command]コマンドの実行

    createJobJson=$(rescale-createJob-v3 ${JOB_JSON} ${fileId})
    jobId=$(echo ${createJobJson} | jq -r .id) && echo ${jobId}

.. code-block:: bash
    :caption: 返り値

    QvQAo


永続クラスタによるジョブの実行
==============================

Sample code (スクリプトの作成)
---------------------------------

以下をコピペし、スクリプトを生成します。

.. code-block:: bash
    :caption: [command]ヒアドキュメントによるスクリプトの生成

    cat << EOF > ${script}/rescale-submitJob2PersistetCluster
    #!/bin/sh

    JOB_ID=\$1
    CLUSTER_ID=\$2
    TOKEN="\${RESCALE_API_TOKEN}"

    _create_json()
    {
    jid=\$1
    cat << ETX
    {
      "id": "\${jid}",
      "submit": true
    }
    ETX
    }

    rescaleJson=\$(_create_json \${JOB_ID})
    echo \$rescaleJson

    curl -s -X POST \
    -H "Authorization: Token \${TOKEN}" \
    -H "Content-Type: application/json" \
    https://platform.rescale.jp/api/clusters/\${CLUSTER_ID}/jobs/ \
    -d "\${rescaleJson}"
    EOF


.. code-block:: bash
    :caption: [command]実行権限付与

    chmod +x ${script}/rescale-submitJob2PersistetCluster

|

Submit Job: (実行例)
---------------------------------------------

.. code-block:: bash
    :caption: [command] 変数の確認

    cat << ETX

    RESCALE_API_TOKEN: ${RESCALE_API_TOKEN}
    clusterId: ${clusterId}
    jobId: ${jobId}

    ETX


.. code-block:: bash
    :caption: [command] 永続クラスタへのジョブ投入

    rescale-submitJob2PersistetCluster ${jobId} ${clusterId}


.. code-block:: json
    :caption: 結果例

    {"id":"ReUKdb"}
