################################################################
[Python] Persisstent Cluster Hands-on with Resacle API
################################################################

Python コードは 得意でないのでイケてないです。そのうち改善します


永続クラスタの起動
================================================================================

永続クラスタの事前準備
--------------------------------------------------------------------------------

jsonで、設定条件を記述し "cluster.json" 名前で保存します。

:download:`src/python/cluster.json`

.. code-block:: json
    :caption: 永続クラスタの起動条件の記述

    {
        "name": "Test-Cluster",
        "hardware": {
            "coresPerSlot": 1,
            "slots": 1,
            "coreType": {
                "code": "hpc-3"
            },
            "walltime": 1
        },
        "installedAnalyses": [
        {
            "analysis": {
                "code": "user_included",
                "version": "0"
                }
        }],
        "runLowPriority": "true"
    }


永続クラスタの設定
--------------------------------------------------------------------------------

"cluster.json" を読み込み永続クラスタを設定します。

:download:`src/python/rescale-createCluster.py`

.. code-block:: bash
    :caption: 永続クラスタの設定

    CREATE_CLUSTER_JSON="cluster.json"
    return_cluster_json=$(python rescale-createCluster.py ${CREATE_CLUSTER_JSON}) \
    && cluster_id=$(echo ${return_cluster_json} | jq -r .id) \
    && echo ${cluster_id}

.. code-block:: bash
    :caption: 返り値例

    qgkKo


永続クラスタの開始
--------------------------------------------------------------------------------

ClusterIdを元に、永続クラスタを起動します

:download:`src/python/rescale-startCluster.py`

.. code-block:: bash
    :caption: 永続クラスタの起動

    python rescale-startCluster.py ${cluster_id}


.. code-block:: bash
    :caption: 返り値

    なし

永続クラスタの状態監視
--------------------------------------------------------------------------------

状態をポーリングします。

:download:`src/python/rescale-pollCluster.py`

.. code-block:: bash
    :caption: 永続クラスタの状態確認

    return_status_json=$(python rescale-pollCluster.py ${cluster_id}) \
    && cluster_status=$(echo ${return_status_json} | jq -r .results[].status) \
    && echo "${cluster_status}"

下記のように ``Started`` が表示されていればクラスタは起動しています。

.. code-block:: bash
    :caption: 返り値

    Started
    Starting
    Queued
    Pending
    Not Started


ジョブの投入
================================================================================

ジョブ投入の事前準備
--------------------------------------------------------------------------------

jsonで、設定条件を記述します。まずは Json ファイルを作り ``testjob.json`` という名前で保存します。

:download:`src/python/testjob.json`

.. code-block:: json
    :caption: ジョブ実行条件の記述

    {
      "name": "Test Job",
      "jobanalyses": [
        {
          "analysis": {
            "code": "user_included",
            "version": "0"
          },
          "command": "sleep 60",
          "flags": {},
          "hardware": {
            "coresPerSlot": 1,
            "slots": 1,
            "coreType": {
              "code": "hpc-3"
            },
            "walltime": 1
          }
        }
      ],
      "isLowPriority": "true"
    }


ジョブ投入の設定
--------------------------------------------------------------------------------

:download:`src/python/rescale-createJob.py`

.. code-block:: bash
    :caption: ジョブの生成

    JOB_JSON="testjob.json"
    return_job_json=$(python rescale-createJob.py ${JOB_JSON}) \
    && job_id=$(echo $return_job_json | jq -r .id) \
    && echo "${job_id}"

.. code-block:: bash
    :caption: ジョブの生成

    NrwMV


永続クラスタへのジョブ投入
--------------------------------------------------------------------------------

:download:`src/python/rescale-submitJob2PersistentCluster.py`

.. code-block:: bash
    :caption: ジョブの生成

    return_job_json=$(python rescale-submitJob2PersistentCluster.py ${job_id} ${cluster_id})

.. code-block:: bash
    :caption: 返り値(例)

    {"id":"bUpygb"}
