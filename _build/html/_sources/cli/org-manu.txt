################################
File Transfer Manual
################################


Upload Files
=======================

次のコマンドを使用して、ローカルファイルシステムから1つまたは複数のファイルをRescaleのクラウドストレージにアップロードすることができます。

.. code-block:: bash

    java -jar /usr/local/bin/rescale.jar upload \
    -p <api-token> \
    -f <file1> ... <fileN>

このコマンドは、指定されたすべてのファイルが実際にファイルであるかどうかをチェックし、指定されていないファイルがあれば停止します。 cliツールはまだディレクトリのアップロードをサポートしていないことに注意してください

アップロード中、各ファイルが正常にアップロードされた後、それを示す内容が標準出力に表示されます。 したがって、ユーザーは出力をログファイルにリダイレクトして、成功したすべてのアップロードが記録されるようにすることもできます。

.. code-block:: bash

    java -jar /usr/local/bin/rescale.jar \
    -p <api-token> \
    -f <file1> ... <fileN> > upload_20141201.log

デフォルトでは、uploadコマンドはアップロードされたファイルのメタデータのセットを返します。 拡張メタデータセットを表示するには、アップロード呼び出しで ``-e`` フラグを使用します。

.. code-block:: bash

    java -jar /usr/local/bin/rescale.jar upload \
    -p <api-token> \
    -f <file1> ... <fileN> -e

最後に、CLIがより大きなスクリプトに組み込まれている場合、``--quiet`` フラグを使用して、コマンドから非json出力を抑制すると便利です。 これにより、解析の応答が簡単になります。

.. code-block:: shell

    java -jar /usr/local/bin/rescale.jar \
    --quiet upload \
    -p <api-token> \
    -f <file1> ... <fileN> -e



Download Files
=======================

Syncing (Downloading)
--------------------------------------

ユーザーは、リモート出力ファイルをローカルファイルシステムと同期させたい場合があります。 ユーザーがアプリケーションを通して出力ファイルを同期させたい理由の1つは、手動でジョブを通過してブラウザを介してファイルをダウンロードする必要はありません。 .rescaleファイルに同期状態を保存し、アプリケーションに組み込まれたファイルを同期する非常に基本的な実装があります。

syncコマンドは、ダウンロードしたファイルを格納するのに十分なディスク容量を持つファイルシステムから実行する必要があります。

ユーザーが単一のジョブのみを同期させたい場合、ユーザーは次のように実行します。

.. code-block:: bash

    java -jar /usr/local/bin/rescale.jar sync \
    -p <api-token> \
    -j <job-id>

また、ユーザーは特定のジョブよりも新しいすべてのジョブを同期させたい場合があります。その場合、ユーザーは次のコマンドを使用します。

.. code-block:: bash

    java -jar /usr/local/bin/rescale.jar sync \
    -p <api-token> \
    -n <job-id>

連続的な同期のために、ユーザは同期時間を指定することができます。 秒単位の時間は、2回の同期試行の間の遅延時間を決定します。

.. code-block:: bash

    java -jar /usr/local/bin/rescale.jar sync \
    -p <api-token> \
    -d <sync-time>

作業ディレクトリを指定すると、ジョブ出力ファイルはジョブごとに個々のディレクトリに同期されます。 たとえば、*zzzZZZ* 、*yyyYYY*、*xxxXXX*、*cccCCC*、*bbbBBB*、*aaaAAA*のように、作成日の古い順に次のジョブを実行することができます。

.. code-block:: bash

    java -jar /usr/local/bin/rescale.jar sync \
    -p <api-token> \
    -n xxxXXX

アプリケーションは *rescale_job_zzzZZZ* 、*rescale_job_yyyYYY* 、*rescale_job_xxxXXX* というディレクトリを作成し、これらのディレクトリ内の出力ファイルを同期させます。 *zzzZZZ* と *yyyYYY* の同期が成功したにもかかわらず *xxxXXX* の同期が失敗した場合、次回ユーザーが同じコマンドを実行すると、アプリケーションは *zzzZZZ* と *yyyYYY* を再び同期しようとはしませんが、*xxxXXX* を再び同期しようとします。


同期状態ファイルはそれぞれの出力ファイルディレクトリに保存されるため、ユーザーが別の作業ディレクトリから ``sync`` コマンドを実行しようとすると、そのディレクトリにファイルが再同期されます。


Output File Filtering
--------------------------------------

``submit`` コマンドと ``sync`` コマンドの両方にオプションの -f フラグを指定すると、ダウンロードされた出力ファイルを指定されたファイル名のフィルタに一致するものに制限することができます。 使用例をいくつか紹介します：


.. code-block:: bash

    java -jar rescale.jar submit \
    -p <api-token> \
    -i <input-script> \
    -E \
    -f *.out process_output.log

.. code-block:: bash

    java -jar rescale.jar sync \
    -p <api-token> \
    -j <job-id> \
    -f image?.png

``submit`` コマンドでは、ファイルフィルタリングオプションはエンドツーエンドジョブの実行時にのみ適用されます。

1つ以上のファイル名マッチャーは、``-f`` 引き数の後に指定することができます。 マッチャーはスペースで区切られています。 ``*`` は任意の文字列に一致するワイルドカードで、``？`` 任意の1文字に一致するワイルドカードです。

すべての照合はファイル名に対してのみ行われ、出力ファイルの完全なパスとは一致しないことに注意してください。


################################
JOBの投入
################################

Job Configuration Using the Input Script
=============================================


The Input Parser
------------------

アプリケーションはデフォルトでSGE入力パーサを使用して、スクリプトからの情報を解析してRescaleの設定として使用し、送信スクリプトで不要なクラスタ固有の設定を解析します。 たとえば、次のような *submit.sh* という名前のスクリプトがあるとします。

.. code-block:: bash

    #!/bin/bash
    #RESCALE_NAME="Hello World!"
    module load hello-world
    source /home/rescale/environments/hello_world
    /usr/lib64/openmpi/bin/mpirun echo "hello-world" > $(hostname)

パーサは、クラスタ固有のラインモジュールのロードを解析して、スクリプトがこの行でエラーにならないことを確認します。 次に、環境を変更するコマンドを削除しようとします。 この場合、ソースの後の行は解析され、Rescale環境を妨げません。 さらに、パーサーは、実行ファイルがローカルクラスタと同じRescale上に存在しない可能性が高いため、実行可能ファイル/バイナリへの絶対参照を削除しようとします。 この場合、mpirunへの参照は、Rescale環境のPATH環境変数を介して参照されます。 結果のスクリプトは、run.shという名前のファイルに保存され、次のようになります。

.. code-block:: bash

    #!/bin/bash
    #RESCALE_NAME="Hello World!"
    #module load hello-world
    #source /home/rescale/environments/hello_world
    mpirun echo "hello-world" > $(hostname)

Rescale解析コマンドは *./run.sh* に設定されます。 このスクリプトは、入力ファイルと共にRescaleにアップロードされます。

Rescale Specific Flags for the Input Script
---------------------------------------------

このアプリケーションでは、Submit スクリプト内で Rescale 固有の設定フラグを使用することができ、ユーザーは自分の希望するとおりにジョブを設定できます。 現在利用可能なフラグは次のとおりです。 これらのフラグが含まれていない場合、fallback value が最初に使用されます。

.. code-block:: bash

    #RESCALE_CORES=<integer>
    {1|2|4|8|16|32|64|128|...}

使用するコアの数。 コアタイプに応じて、許可される値はリストされたオプションのサブセットです。 このオプションのフォールバック値は SGEにおける ``#$ -pe`` の値です。

.. code-block:: bash

    #RESCALE_CORE_TYPE=<string>
    {Marble|Nickel|Onyx|Iron|Gold|Obsidian|...}

使用するRescaleコアタイプ。 このオプションの代替値はありません。 このオプションの有効な値のリストを取得する方法については、このドキュメントの「メタデータ」を参照してください。

.. code-block:: bash

    #RESCALE_NAME=<string>

あなたの仕事の名前。 このオプションのフォールバック値は SGEにおける ``#$ -N`` 値です。

.. code-block:: bash

    #RESCALE_ANALYSIS=<string>

``{abaqus | adina | aermod | ansys_cfx | ansys_fluent | ... | user_included | ...}`` 分析が使用されました。 これは解析コード値に設定する必要があります。 このドキュメントの「メタデータ」セクションには、このオプションの有効な値のリストを取得する方法が記載されています。 フォールバック値は、解析可能な任意の解析名であり、スクリプトのモジュールまたはソース行で指定されます。

.. code-block:: bash

    #RESCALE_ANALYSIS_VERSION=<string>

使用する選択された分析の特定のバージョン。 これはオプションの設定です。 省略すると、最新のバージョンが使用されます。 これを指定する場合は、特定の解析バージョンの "versionCode" 値に設定する必要があります。 このドキュメントの「メタデータ」セクションには、このオプションの有効な値のリストを取得する方法が記載されています。

.. code-block:: bash

    #RESCALE_EXISTING_FILES=<comma delimited list of strings>

``#RESCALE_EXISTING_FILES = aAbBcC、dDeEfF、gGhHiI`` すでにこのジョブにRescaleに格納されているリストされたファイルを含めます。 リストされたファイルが存在しない場合、検証時にジョブは失敗します。 このオプションの代替値はありません。

.. code-block:: bash

    #USE_RESCALE_LICENSE

解析コードには、提供されているライセンスのサイズ変更を使用します。 すでに存在するライセンスを使用する場合は、実行スクリプトを使用して環境変数を使用して設定することができます。

.. code-block:: bash

    #RESCALE_ENV_<varname>=<value>

Rescaleクラスタでライセンスサーバー情報を設定するために使用されます。 環境変数名の名前とライセンスサーバーの場所に置き換えます。 たとえば、``#RESCALE_ENV_RLM_LICENSE=8112@license-proxy.rescale.com `` は、クラスタノードで ``8112@license-proxy.rescale.com ``に設定された ``RLM_LICENSE`` 環境変数を作成します。

.. code-block:: bash

    #RESCALE_WALLTIME=<# of hours>

このジョブの実行を許可する最大時間を設定するオプションの値。 この時間数を超えるジョブは終了します。 指定しない場合は、Rescaleユーザーアカウント設定にリストされているデフォルトのMax Job Hours値が使用されます。

Advanced Settings
--------------------

RescaleクラスタのマスターノードへのSSHアクセスを有効にするために使用できるいくつかの追加の高度な設定があります。 これはジョブの結果を調べたり変更したりするのに便利ですが、将来ジョブをクローンして再実行すると結果の再現性に悪影響を及ぼします。

現在、CLIからマスターノードのIPアドレスを取得する方法はありません。 この情報を見つけるには、Web UI上のJob statusページを使用する必要があります。

.. code-block:: bash

    #RESCALE_INBOUND_SSH_CIDR=<string>
    for example: #RESCALE_INBOUND_SSH_CIDR=50.123.22.112/32

RescaleクラスタのマスターノードへのインバウンドSSHアクセスを許可するIP範囲を定義するために使用されます。 この値を省略すると、Rescaleユーザーアカウント設定にリストされているデフォルト値が使用されます。

.. code-block:: bash

    #RESCALE_PUBLIC_KEY=<string>
    for example: #RESCALE_PUBLIC_KEY=ssh-rsa AAAA...

Rescaleクラスタ上のマスターノードのauthorized_keysファイルに追加される公開鍵を設定するために使用します。 これにより、関連付けられた秘密鍵を使用してRescaleクラスタのマスターノードにSSHすることができます。 この値を省略すると、Rescaleユーザーアカウント設定にリストされているデフォルト値が使用されます。

.. code-block:: bash

    #RESCALE_AUTO_TERMINATE_CLUSTER=<boolean>
    {true, false}

分析が完了した後にRescaleクラスタを実行したままにする必要があるかどうかを示すフラグ。 この値は、``RESCALE_INBOUND_SSH_CIDR`` および ``RESCALE_PUBLIC_KEY`` ディレクティブが設定されている（またはデフォルトがユーザーアカウント設定に存在する）場合にのみ、``false`` に設定できます。 この値を省略すると、Rescaleユーザーアカウント設定にリストされているデフォルトの自動終了値が使用されます。

Example Scripts
------------------

SGEとRescaleの両方で動作するサンプルスクリプトは、次のようになります（モジュール行はコメントアウトされ、mpirunへの絶対参照は削除されます）。

.. code-block:: bash

    #!/bin/bash
    #RESCALE_NAME="Converge Sample"
    #RESCALE_CORES=32
    #RESCALE_CORE_TYPE=HPC
    #RESCALE_ANALYSIS=converge_open_mpi
    module load converge
    /usr/bin/mpirun -np 32 converge-2.1.0

Rescaleでしか動作しないスクリプトの例は、以下のようになります。 コマンドラインのコマンドは、解析コードテーブル（別の添付ファイル）にあります。

.. code-block:: bash

    #!/bin/bash
    #RESCALE_NAME="Converge Sample"
    #RESCALE_CORES=32
    #RESCALE_CORE_TYPE=HPC
    #RESCALE_ANALYSIS=converge_open_mpi
    converge-mpi -n all -v 2.1

Metadata
----------

ジョブを送信するときに記入する必要がある、いくつかのRescale固有のフラグがあります。 次のメタデータ検索コマンドを使用して、使用するデータを含むJSON BLOBを取得できます。

次のコマンドは、コアタイプのリストを取得します。

.. code-block:: bash

    java -jar /usr/local/bin/rescale.jar list-info -c -p <api-token>

名前またはコードの値は、``RESCALE_CORE_TYPE`` フラグで使用できます。 返されるリストには廃止された型が含まれており、時間の経過とともに変更される可能性があるので、ユーザーはisDeprecated値が目的のコアタイプに対してfalseに設定されていることを確認する必要があります。

次のコマンドは、分析のリストとそのバージョンを取得します。

.. code-block:: bash

    java -jar /usr/local/bin/rescale.jar list-info -a -p <api-token>

返されるリストの各項目は分析を表します。 ``RESCALE_ANALYSIS`` オプションで "code"の値を使用できます。 すべての分析の中に、バージョンのリストがあります。 「versionCode」フィールドは、``RESCALE_ANALYSIS_VERSION`` オプションで使用できます。

注：FAQセクションの方法2または3に従ってAPIキーを設定した場合は、上記のコマンドの[-p <api-token>]を省略することができます。
