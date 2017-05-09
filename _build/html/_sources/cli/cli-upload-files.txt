##########################################################
ファイルのアップロード
##########################################################


前提
=====================================================

下記を実施済みであること

- :doc:`setupcli-main`

.. note:: `rescale.jar` の保存先が `/usr/local/bin/rescale.jar` であることに注意してくださ


スクリプトのダウンロード
=====================================================

以下より `rescalecli-upload` をダウンロードしてください。

    :download:`src/rescalecli-upload`

ダウンロードしたスクリプトに実行権限を付与します。

.. code-block:: bash

    chmod +x rescalecli-download

スクリプトの実行方法
=====================================================

対象とするジョブIDとダウロンドーロするファイル名を指定します。
複数ファイルも指定することができます。

.. code-block:: bash
    :caption: アップロードファイルの決定

    FILE_NAME='hoge1 hoge2'

.. code-block:: bash
    :caption: スクリプトの実行

    ./rescalecli-upload ${FILE_NAME}

.. literalinclude:: ./src/upload.json
    :emphasize-lines: 25, 46
    :caption: 結果(返り値)


実践的なスクリプト実行例
=====================================================

ファイルアップロード後、ファイルIDを取得したい場合がよくあります。
上記JSONの黄色線がファイルIDに相当します。
もしアップロードと同時にこのIDを取得したい場合は下記のように実行します。
jqが必要です。

.. code-block:: bash

    JSON=$(./rescalecli-upload hoge1.txt hoge2.txt) && echo ${JSON} | jq -r .files[].id

.. code-block:: bash

    WAvaac
    xOBoPb


ソースコード例
=====================================================

.. literalinclude:: src/rescalecli-upload
    :language: bash
    :linenos:
    :caption: ソースコード

詳細情報
=====================================================

:doc:`org-manu`
