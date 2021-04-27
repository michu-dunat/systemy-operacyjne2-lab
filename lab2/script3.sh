#!/bin/bash

DIR=${1}

DIR_NOT_FOUND=3
PARAMETER_NOT_FOUND=4

if [[ $# -eq 0 ]]; then 
    echo "Parameter requierd."
    exit "${PARAMETER_NOT_FOUND}"
fi

if [[ ! -d ${DIR} ]]; then
    exit "${DIR_NOT_FOUND}"
fi

for FILE in ${LIST}; do
    EXTENSION=".${FILE##*.}"

    if [[ -f ${DIR}/${FILE} && ${EXTENSION} == ".bak" ]]; then
        chmod uo-w ${DIR}/${FILE}
    elif [[ -d ${DIR}/${FILE} && ${EXTENSION} == ".bak" ]]; then
        chmod a-x ${DIR}/${FILE}
        chmod o+x ${DIR}/${FILE}
    elif [[ -d ${DIR}/${FILE} && ${EXTENSION} == ".tmp" ]]; then
        chmod a+w ${DIR}/${FILE}
    elif [[ -f ${DIR}/${FILE} && ${EXTENSION} == ".txt" ]]; then
        chmod a-rwx ${DIR}/${FILE}
        chmod u+r ${DIR}/${FILE}
        chmod g+w ${DIR}/${FILE}
        chmod o+x ${DIR}/${FILE}
    elif [[ -f ${DIR}/${FILE} && ${EXTENSION} == ".exe" ]]; then
        chmod a+x ${DIR}/${FILE}
    fi

done