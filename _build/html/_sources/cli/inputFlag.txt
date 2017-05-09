########################################################################
ランスクリプトの設定方法 (Rescale Specific Flags for the Input Script)
########################################################################

Rescale ライセンス (e.g. cradle製品などの従量アプリ)を利用するとき
============================================================================

.. code-block:: bash

    #!/bin/sh -f
    #RESCALE_NAME=stream_from_cli
    #RESCALE_CORES=1
    #RESCALE_CORE_TYPE=hpc-plus
    #RESCALE_ANALYSIS=sc_stream
    #RESCALE_ANALYSIS_VERSION=12.0.0-intelmpi
    #RESCALE_LOW_PRIORITY=on
    #USE_RESCALE_LICENSE

上からそれぞれ

- Jobname
- コア数
- コアタイプ
- アプリケーションコード
- Versionコード
- Low Priorityの利用
- Rescale Licenseの利用


PoDライセンスを Rescale CLI から利用する場合
==================================================

.. code-block:: bash

    #!/bin/sh -f
    #RESCALE_NAME=starccm_from_cli
    #RESCALE_CORES=1
    #RESCALE_CORE_TYPE=hpc-plus
    #RESCALE_ANALYSIS=cd_adapco_star_ccm
    #RESCALE_ANALYSIS_VERSION=12.2.10
    #RESCALE_LOW_PRIORITY=on
    #RESCALE_ENV_CDLMD_LICENSE_FILE=1999@flex.cd-adapco.com
    #RESCALE_ENV_LM_PROJECT=XXXXXXXXXXXXXXXXXXXXXXXXXXXX

上からそれぞれ

- Jobname
- コア数
- コアタイプ
- アプリケーションコード
- Versionコード
- Low Priorityの利用
- ライセンスサーバの指定
- PoDキーの入力



フラグで設定する内部コード名がわからないとき
====================================================

アプリケーション
-------------------

.. code-block:: bash

    RESCALE_API_TOKEN=<'取得したAPIキー'>

    java -jar /usr/local/bin/rescale.jar \
    -X https://platform.rescale.jp/ list-info -a \
    -p ${RESCALE_API_TOKEN} \
    | jq -c '{code: .code, versionCode: .versions[].versionCode, allowdCoreTypes: .versions[].allowedCoreTypes[]}'

コアタイプ
-------------------

.. code-block:: bash

    RESCALE_API_TOKEN=<'取得したAPIキー'>

    java -jar /usr/local/bin/rescale.jar \
    -X https://platform.rescale.jp/ \
    list-info -c \
    -p ${RESCALE_API_TOKEN} | jq .
