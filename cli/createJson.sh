#!/bin/sh


_create_app_rst()
{
DATE=$(date)
cat << EOF
##################################
Application-code information
##################################

作成日: ${DATE}

一般ユーザ権限で作成しています。
ここにないアプリケーションはRescaleにお問い合わせください。

.. literalinclude:: src/apps.json
    :language: bash
    :linenos:
    :caption: ソースコード
EOF
}

_create_hw_rst()
{
DATE=$(date)
cat << EOF
##################################
Hardware-code information
##################################

作成日: ${DATE}

一般ユーザ権限で作成しています。
ここにないHardwareはRescaleにお問い合わせください。

.. literalinclude:: src/hw.json
    :language: bash
    :linenos:
    :caption: ソースコード
EOF
}


AP_RST_FILE="apps-json.rst"
HW_RST_FILE="hw-json.rst"

_create_app_rst > ${AP_RST_FILE}
_create_hw_rst > ${HW_RST_FILE}

#
#

java -jar /usr/local/bin/rescale.jar \
-X https://platform.rescale.jp/ list-info -a \
-p ${my_numrecipes_token} \
| jq -c '{code: .code, versionCode: .versions[].versionCode, allowdCoreTypes: .versions[].allowedCoreTypes[]}' \
> src/apps.json


java -jar /usr/local/bin/rescale.jar \
-X https://platform.rescale.jp/ \
list-info -c \
-p ${my_numrecipes_token} | jq . \
> src/hw.json
