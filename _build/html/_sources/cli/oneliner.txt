###################################
Rescale CLI Oneliner
###################################


code 情報の取得
===============================

.. code-block:: bash
    :caption: アプリケーションリストを得るOneliner

    java -jar /usr/local/bin/rescale.jar \
    -X https://platform.rescale.jp/ list-info -a -p ${RESCALE_API_TOKEN} \
    | jq -c '{code: .code, versionCode: .versions[].versionCode, allowdCoreTypes: .versions[].allowedCoreTypes[]}'


.. code-block:: json
    :caption: 結果例(大部分省略)

    {"code":"cd_adapco_star_ccm","versionCode":"12.2.10","allowdCoreTypes":"bronze"}
    {"code":"cd_adapco_star_ccm","versionCode":"12.2.10","allowdCoreTypes":"copper"}
    {"code":"cd_adapco_star_ccm","versionCode":"12.2.10","allowdCoreTypes":"gpu-kepler"}


ジョブ投入
===============================

計算終了後、全ファイルをダウンロード
--------------------------------

.. code-block:: bash
    :caption: 必要な変数

    RESCALE_API_TOKEN='<APIキー>'
    RUNSCRIPT='<ランスクリプトファイル名>'


.. code-block:: bash
    :caption: bashジョブ投入

    java -jar /usr/local/bin/rescale.jar \
    -X https://platform.rescale.jp/ submit \
    -p ${RESCALE_API_TOKEN} \
    -E -i ${RUNSCRIPT}


計算終了後、ファイル名を指定してダウンロード
----------------------------------------------------------------

.. code-block:: bash
    :caption: 必要な変数

    RESCALE_API_TOKEN='<APIキー>'
    RUNSCRIPT='<ランスクリプトファイル名>'
    DOWNLOAD_FILES='<ランスクリプトファイル名> (e.g file1 file2 *.log)'


.. code-block:: bash
    :caption: ジョブ投入

    java -jar /usr/local/bin/rescale.jar \
    -X https://platform.rescale.jp/ submit \
    -p ${RESCALE_API_TOKEN} \
    -E -i ${RUNSCRIPT} -f ${DOWNLOAD_FILES}
