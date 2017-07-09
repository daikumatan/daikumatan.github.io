##########################################
API List one liner curlコマンド編
##########################################

事前準備
=========

jqの準備
----------

jqをインストールしてください

API Keyの準備
--------------------

API Key の準備

.. code-block:: bash

    export RESCALE_API_TOKEN=<'作成したAPI-Key'>

FIle API をつかいこなす
===========================

ファイルリストを得る

.. code-block:: bash

    json=$(curl -s -X GET -H "Authorization: Token ${RESCALE_API_TOKEN}" \
    "https://platform.rescale.jp/api/v2/files/") \
    && echo ${json} | jq .

2ページ目を見る。``?page=2`` を付け加えれば良い

.. code-block:: bash

    PAGE=2
    json=$(curl -s -X GET -H "Authorization: Token ${RESCALE_API_TOKEN}" \
    "https://platform.rescale.jp/api/v2/files/?page=${PAGE}") \
    && echo ${json} | jq .


ファイル名、更新日、ファイルIDのみをリストで得る。取得するリストのサイズは64とする

.. code-block:: bash

    SIZE=64
    json=$(curl -s -X GET -H "Authorization: Token ${RESCALE_API_TOKEN}" \
    "https://platform.rescale.jp/api/v2/files/?page_size=${SIZE}") \
    && echo ${json} | jq -c '.results[] | {dateUploaded: .dateUploaded, id: .id, name: .name}'

入力ファイルだけを得る。かつ拡張子は .pc .mpl とする。サイズは64とする

.. code-block:: bash

    SIZE=64
    json=$(curl -s -X GET -H "Authorization: Token ${RESCALE_API_TOKEN}" \
    "https://platform.rescale.jp/api/v3/files/?ext=.pc&ext=.mpl&owner=3&type=1&page_size=${SIZE}") \
    && echo ${json} \
    | jq -c '.results[] | {dateUploaded: .dateUploaded, id: .id, name: .name, owner: .owner}'

?ext=.pc&ext=.mpl&fileTypeFilter=1&ownerFilter=3

対象とするFileのメタデータを参照する

.. code-block:: bash

    FILE_ID=<'対象とするFileId'>
    curl -s -X GET -H "Authorization: Token ${RESCALE_API_TOKEN}" \
    "https://platform.rescale.jp/api/v2/files/${FILE_ID}/" | jq .

メタデータを更新する

.. code-block:: bash

    FILE_ID="SfwFc"
    json=$(cat ${FILE_ID}.json) && echo ${json} | jq .
    curl -s -X PATCH \
    -H 'Content-Type: application/json' -H "Authorization: Token ${RESCALE_API_TOKEN}" --data "${json}" https://platform.rescale.com/api/v2/files/${FILE_ID}/

    curl -s -X GET -H "Authorization: Token ${RESCALE_API_TOKEN}" \
    "https://platform.rescale.jp/api/v2/files/${FILE_ID}/" | jq .
