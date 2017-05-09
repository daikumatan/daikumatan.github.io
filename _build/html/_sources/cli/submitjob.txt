###############################
ジョブの投入
###############################


想定シナリオとして **「計算終了後、回収したいファイルが決まっている」** とする。

このシナリオのとき、計算の実行から、ファイルのダウンロードまで、Rescale CLIを使ってシンプルにジョブ実行を実現できる。

使用するファイル
================

- **ランスクリプト**: ンスクリプト内に、アプリケーション情報、使用するハードウェア情報、ライセンス情報などの設定情報を書き込む。
- **計算に必要なインプットファイル**: アプリケーションが読み込むmeshファイルや条件ファイル


ランスクリプト
====================

ランスクリプトを作成します。

.. code-block:: bash

    vi submit_gammes.sh

下記をこのスクリプトに書き込みます。

.. code-block:: bash
    :linenos:
    :caption: GAMESSのランスクリプト例

    #!/bin/sh -f
    #RESCALE_NAME=gamess_from_cli
    #RESCALE_CORES=8
    #RESCALE_CORE_TYPE=hpc-plus
    #RESCALE_ANALYSIS=gamess
    #RESCALE_LOW_PRIORITY=on

    rungms glyz_makefp 8 > gamess.log 2>&1

#で始まるフラグは以下の意味です

- Jobname
- コア数
- コアタイプ
- アプリケーションコード
- Low Priorityの利用



ジョブのキック方法
====================

.. code-block:: bash
    :caption: 変数の決定

    RUNSCRIPT="submit.sh"
    DOWNLOAD_FILES="*.png *.xml *.log"


.. code-block:: bash
    :caption: ジョブの投入

    java -jar /usr/local/bin/rescale.jar \
    -X https://platform.rescale.jp/ submit \
    -p ${RESCALE_API_TOKEN} -E -i ${RUNSCRIPT} -f ${DOWNLOAD_FILES}
