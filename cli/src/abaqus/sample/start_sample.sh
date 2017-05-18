#!/bin/sh

declare -a files=($@)

# -e: To see an extended set of metadata, use the -e flag in the upload call:
# --quiet: to suppress non-json output from the command.

java -jar /usr/local/bin/rescale.jar \
-X https://platform.rescale.jp/ \
--quiet upload \
-p ${RESCALE_API_TOKEN} \
-f ${files[*]} \
-e
