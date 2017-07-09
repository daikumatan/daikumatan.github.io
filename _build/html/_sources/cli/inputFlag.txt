########################################################################
ランスクリプトの書き方 (Rescale Specific Flags)
########################################################################

Rescale CLI は ``#RESCALE_ ....`` で始まるフラグによって、環境を設定することができます。
その一覧と使用例を示します。

詳細は `本家(英語) <https://support.rescale.com/customer/en/portal/articles/2624542-rescale-cli>`_  をご参照ください

|

よく使うフラグ一覧表
============================================================================

|

.. list-table:: Table of Rescale Specific Flags
    :widths: 30 70

    * - #RESCALE_NAME=<string>
      - | 任意のジョブ名を入力する
        | e.g) ``#RESCALE_NAME=hello_world``
    * - #RESCALE_CORES=<integer>
      - | 使用するコア数を入力する。完全に自由にはコア数を指定できるわけではないので注意。
        | 実際に使用できるコア数は ":ref:`get_hardware_code`" のセクションを参照してください。
        | e.g.) ``#RESCALE_CORES=16``
    * - #RESCALE_CORE_TYPE=<string>
      - | 使用するコアタイプのコードを入力する。
        | コアタイプのコードは ":ref:`get_hardware_code`" のセクションを参照してください
        | e.g.) ``#RESCALE_CORE_TYPE=hpc-plus``
    * - #RESCALE_ANALYSIS=<string>
      - | 使用するアプリケーションコードを入力する。
        | アプリケーションコードは ":ref:`get_application_code`" のセクションを参照してください。
        | e.g.) ``#RESCALE_ANALYSIS=sc_stream``
    * - #RESCALE_ANALYSIS_VERSION=<string>
      - | 使用するアプリケーションのバージョンコードを入力する。
        | アプリケーションのバージョンコードは ":ref:`get_application_code`" のセクションを参照してください
        | e.g.) ``#RESCALE_ANALYSIS_VERSION=12.0.0-intelmpi``
    * - #RESCALE_LOW_PRIORITY=<boolean>
      - | 低優先度を指定する。すべてのコアタイプで使えるわけでは無いので注意。
        | e.g.) ``#RESCALE_LOW_PRIORITY=true``
    * - #RESCALE_ENV_<varname>=<value>
      - | 環境変数を設定するとき
        | e.g.) ``#RESCALE_ENV_LD_LIBRARY_PATH="~/work/shared/FrontISTR/lib":$LD_LIBRARY_PATH``
    * - #RESCALE_EXISTING_FILES=<comma delimited list of strings>
      - | アップロード済みの FileIdを記述する。
        | e.g.) ``#RESCALE_EXISTING_FILES="AbCdEf xyzwabc"``
    * - #RESCALE_ENV_CDLMD_LICENSE_FILE
      - | Licenseサーバを指定する必要があるとき使用する。
        | e.g.) ``#RESCALE_ENV_CDLMD_LICENSE_FILE=1999@flex.cd-adapco.com`` (STAR-CCM+ のPoDのLicenseサーバ)
    * - #RESCALE_ENV_LM_PROJECT
      - | Licenseサーバを指定し、尚且つ環境変数等を設定する必要があるとき使用する。
        | e.g.) ``#RESCALE_ENV_LM_PROJECT=XXXXXXXXXXXXXXXXXXXXXXXXXXXX`` (STAR-CCM+ のPoDキー)
    * - #USE_RESCALE_LICENSE
      - | 一部の従量課金のアプリケーションを使用するとき使用する。
        | e.g.) ``#USE_RESCALE_LICENSE``
    * - #RESCALE_PROJECT_ID=<project name or external id>
      - | "プロジェクト" を指定してジョブを投入する (プロジェクトに予算を設定されている場合など便利)
        | e.g.) ``#USE_RESCALE_LICENSE=my_project``

|

具体例
============================================================================

Rescale ライセンス (e.g. cradle製品などの従量アプリ)を利用するとき
------------------------------------------------------------------------------

Cradele製品は従量ラインセスなので ``#USE_RESCALE_LICENSE`` を指定している。

.. code-block:: bash

    #!/bin/sh -f
    #RESCALE_NAME=stream_from_cli
    #RESCALE_CORES=1
    #RESCALE_CORE_TYPE=hpc-plus
    #RESCALE_ANALYSIS=sc_stream
    #RESCALE_ANALYSIS_VERSION=12.0.0-intelmpi
    #RESCALE_LOW_PRIORITY=true
    #USE_RESCALE_LICENSE

    <'アプリケーションをキックするためのコマンドを記述'>

|


PoDライセンスを Rescale CLI から利用する場合
------------------------------------------------------------------------------

PoD Licenseの指定方法がポイント

.. code-block:: bash

    #!/bin/sh -f
    #RESCALE_NAME=starccm_from_cli
    #RESCALE_CORES=1
    #RESCALE_CORE_TYPE=hpc-plus
    #RESCALE_ANALYSIS=cd_adapco_star_ccm
    #RESCALE_ANALYSIS_VERSION=12.2.10
    #RESCALE_LOW_PRIORITY=true
    #RESCALE_ENV_CDLMD_LICENSE_FILE=1999@flex.cd-adapco.com
    #RESCALE_ENV_LM_PROJECT=XXXXXXXXXXXXXXXXXXXXXXXXXXXX

    <'アプリケーションをキックするためのコマンドを記述'>

|

Deep Learning の学習に適用(GPUコアタイプ)
------------------------------------------------------------------------------

Deep Learning (OSS)の例

.. code-block:: bash

    #!/bin/sh -f
    #RESCALE_NAME=chainer-1.22.0-mnist-with-RescaleCli
    #RESCALE_CORES=2
    #RESCALE_CORE_TYPE=obsidian
    #RESCALE_LOW_PRIORITY=true
    #RESCALE_ANALYSIS=chainer
    #RESCALE_ANALYSIS_VERSION=1.22.0-cuda8-gpu-centos

    <'アプリケーションをキックするためのコマンドを記述'>


フラグで設定する内部コード名がわからないとき
====================================================

.. _get_application_code:

アプリケーションコードを得る
---------------------------------

.. code-block:: bash

    RESCALE_API_TOKEN=<'取得したAPIキー'>

    java -jar /usr/local/bin/rescale.jar \
    -X https://platform.rescale.jp/ list-info -a \
    -p ${RESCALE_API_TOKEN} \
    | jq -c '{code: .code, versionCode: .versions[].versionCode, allowdCoreTypes: .versions[].allowedCoreTypes[]}'

|

.. _get_hardware_code:

コアタイプコードを得る
-------------------

.. code-block:: bash

    RESCALE_API_TOKEN=<'取得したAPIキー'>

    java -jar /usr/local/bin/rescale.jar \
    -X https://platform.rescale.jp/ \
    list-info -c \
    -p ${RESCALE_API_TOKEN} | jq .
