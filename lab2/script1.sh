#!/bin/bash

FIRST_DIR=${1}
SECOND_DIR=${2}

DIR_NOT_FOUND=3
TWO_PARAMETERS_NOT_FOUND=4

if [[ $# -le 1 ]]; then 
    echo "Two parameteres requierd."
    exit "${TWO_PARAMETERS_NOT_FOUND}"
fi

if [[ ! -d ${FIRST_DIR} || ! -d ${SECOND_DIR} ]]; then
    exit "${DIR_NOT_FOUND}"
fi

LIST=$(ls ${FIRST_DIR})
for FILE in ${LIST}; do
    if [[ -d ${FIRST_DIR}/${FILE} ]]; then
        echo "${FILE} is directory."
    fi
    if [[ -L ${FIRST_DIR}/${FILE} ]]; then
        echo "${FILE} is symbolic link."
    fi
    if [[ -f ${FIRST_DIR}/${FILE} && ! -L ${FIRST_DIR}/${FILE} ]]; then
        echo "${FILE} is regular file."
    fi
done

for FILE in ${LIST}; do
    if [[ (-f ${FIRST_DIR}/${FILE} && ! -L ${FIRST_DIR}/${FILE}) || -d ${FIRST_DIR}/${FILE} ]]; then
        EXTENSION=".${FILE##*.}"
        SYMBOLIC_LINK_NAME="${FILE%.*}"
        if [[ ${EXTENSION} == ".${SYMBOLIC_LINK_NAME}" ]]; then
            EXTENSION=""
        fi
        SYMBOLIC_LINK_NAME=${SYMBOLIC_LINK_NAME^^}
        SYMBOLIC_LINK_NAME="${SYMBOLIC_LINK_NAME}_ln${EXTENSION}"
        if [[ "${FIRST_DIR}" == /* ]]; then
            ln -s ${FIRST_DIR}/${FILE} ${SECOND_DIR}/${SYMBOLIC_LINK_NAME}
        else
            ln -s ../${FIRST_DIR}/${FILE} ${SECOND_DIR}/${SYMBOLIC_LINK_NAME}
        fi
    fi
done

