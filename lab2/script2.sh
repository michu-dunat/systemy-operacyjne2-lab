#!/bin/bash

DIR=${1}
WRITE_FILE=${2}

DIR_NOT_FOUND=3
TWO_PARAMETERS_NOT_FOUND=4

if [[ $# -le 1 ]]; then 
    echo "Two parameteres requierd."
    exit "${TWO_PARAMETERS_NOT_FOUND}"
fi

if [[ ! -d ${DIR} ]]; then
    exit "${DIR_NOT_FOUND}"
fi

DATE=$(date --iso-8601)

LIST=$(ls ${DIR})
for FILE in ${LIST}; do
    if [[ -L ${DIR}/${FILE} && ! -e ${DIR}/${FILE} ]]; then
        echo "${FILE} - ${DATE}" >> ${WRITE_FILE}
        rm ${DIR}/${FILE}
    fi
done