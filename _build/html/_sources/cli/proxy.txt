############################
Proxy を越える必要がある時
############################

プロキシーを越えて ジョブの status チェックをするコード例
===============================================================================

.. code-block:: bash
    :linenos:
    :emphasize-lines: 8,9
    :caption: sc_stream.json

    # 変数の決定
    PROXY_HOST='proxy'
    PROXY_PORT='8888'
    OPTION='status'

    # 実行例
    java \
    -Dhttps.proxyHost=${PROXY_HOST} \
    -Dhttps.proxyPort=${PROXY_PORT} \
    -jar /usr/local/bin/rescale.jar ${OPTION} \
    -p ${API_TOKEN} -j ${JOB_ID}
