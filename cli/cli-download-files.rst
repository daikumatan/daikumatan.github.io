##########################################################
結果のダウンロード (ファイル名を指定)
##########################################################

前提
========================================================

下記を実施済みであること

- :doc:`setupcli-main`

.. note:: `rescale.jar` の保存先が `/usr/local/bin/rescale.jar` であることに注意してくださ


スクリプトのダウンロード
========================================================

以下より `rescalecli-download` をダウンロードしてください。

    :download:`src/rescalecli-download`

ダウンロードしたスクリプトに実行権限を付与します。

.. code-block:: bash

    chmod +x rescalecli-download

スクリプトの実行方法
========================================================

対象とするジョブIDとダウロンドーロするファイル名を指定します。複数ファイルも指定することができます。ジョブIDが分からない方は ":doc:`jobId`" をご参照ください

.. code-block:: bash
    :caption: JOB_IDの指定

    JOB_ID='XXXXXX'

.. code-block:: bash
    :caption: ダウンロードしたいファイルネームの指定

    FILE_NAME='myFile1 myFile2 *.log'

.. code-block:: bash
    :caption: スクリプトの実行

    ./rescalecli-download ${JOB_ID} ${FILE_NAME}



ソースコード例
=====================================================

.. literalinclude:: src/rescalecli-download
    :language: bash
    :linenos:
    :caption: ソースコード


詳細情報
=====================================================

:doc:`org-manu`
