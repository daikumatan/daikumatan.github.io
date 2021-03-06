##############################################################
USECASE1: Rescale CLI on Windows
##############################################################

:update: June 6th, 2017 
:author: Daisuke Nagao

Windows上からつかってみます。Rescale CLIをつかうことが目的です。

アプリケーションはAbaqusをもちいてみます。

|

スクリプトのダウンロード
========================================================

下記をダウンロードしてください。

- :download:`src/win/abaqus_rescale.py`

下記のソースコード例を参考に、ダウンロードしたスクリプトを修正します

|

.. list-table:: 修正箇所
    :widths: 10 95

    * - 11行目
      - | ダウンロードしたい "ファイル名" を記述してください。
        | 複数のファイルの指定はUNIX形式で指定するか、もしくはスペースで区切ってください。
        | e.g) ``download_files="*.out process_output.log"``
    * - 12行目
      - | ``rescale.jar`` をあなたが保存したパスに修正してください(パスの区切りは **"￥" ではなく "/"** を使用)
        | e.g) ``rescalecli = "C:/rescale/rescale.jar"``

|


スクリプトの実行方法
========================================================

以下を仮定して、Rescaleへジョブを投入します。

- コア数: 8
- 入力ファイル: s4d
- 同一フォルダ内に、"s4d", "abaqus_rescale.py" が存在こととする

.. code-block:: bash
    :caption: ジョブ投入

    python abaqus_rescale.py job=s4d cpus=8 interactive

このファイルをバッチファイルにしても便利です。Rescale CLIを実行するフォルダでクリックすれば良いです。

- Download: :download:`src/win/test.bat`

|

ソースコード例
=====================================================

.. literalinclude:: src/win/abaqus_rescale.py
    :caption: abaqus_rescale.py
    :linenos:
    :emphasize-lines: 11,12
