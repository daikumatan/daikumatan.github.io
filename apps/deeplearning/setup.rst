#############################
Rescale CLI/API 事前準備
#############################

|

API Key の作成
=============================

:doc:`../../cli/setupcli-create-apikey`

|

Rescale CLI のダウンロード
=============================

:doc:`../../cli/setupcli-download-jarfile`

|

作業ディレクトリー、スクリプト格納先の決定
--------------------------------------------------------

.. code-block:: bash
    :caption: 作業ディレクトリーへの移動

    cd <'任意のディレクトリー (e.g.) cd {HOME}/work'>

.. code-block:: bash
    :caption: 作業ディレクトリーと、スクリプト格納先を定義する(後で使用)

    WORK_DIR=$(pwd)
    BIN=${WORK_DIR}/bin


.. code-block:: bash
    :caption: スクリプト格納のためのディレクトリーを作成

    mkdir ${BIN}

|

必要ツールのセットアップ
===========================

rescale.jar の格納
-------------------------------------

先ほど、ダウンロードした "*.jar" ファイルを、``${BIN}`` へ格納します。

.. code-block:: bash
    :caption: rescale.jarをパスの通ったディレクトリーへ移動

    cp <'/Download先のパス/rescale.jar'> ${BIN}

|

jqの準備
-------------------------------------

jqがあるとJSONの取扱がとても便利なのでインストールします。

.. code-block:: bash
    :caption: jqのインストール

    cd ${BIN}
    wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
    chmod +x jq-linux64
    ln -s ${BIN}/jq-linux64 ${BIN}/jq

|

パスの設定
=========================

PATHの追加と, API-Keyを環境変数としてエクスポートする
---------------------------------------------------------

これらの変数は良く使用するので予め、設定しておきます。

.. code-block:: bash
    :caption: rescale.jar のPATH と API-Key の情報

    export PATH=${BIN}:${PATH}
    export RESCALE_CLI_PATH=${BIN}
    export RESCALE_API_TOKEN=<'作成したAPI Key'>

|

パスの確認
-----------------

.. code-block:: bash
    :caption: パス設定確認

    which jq

.. code-block:: bash
    :caption: 結果例(返り値)

    ~/work/bin/jq
