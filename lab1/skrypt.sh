#!/bin/bash

SOURCE_DIR=${1:-lab_uno}
RM_LIST=${2:-lab_uno/2remove}
TARGET_DIR=${3:-bakap}

if [[ ! -d ${TARGET_DIR} ]]; then
    mkdir ${TARGET_DIR}
fi

REMOVE_LIST=$(cat ${RM_LIST})
for ENTRY in ${REMOVE_LIST}; do
    if [[ -f ${SOURCE_DIR}/${ENTRY} ]]; then
        rm ${SOURCE_DIR}/${ENTRY}
    fi
    if [[ -d ${SOURCE_DIR}/${ENTRY} ]]; then
        rm -r ${SOURCE_DIR}/${ENTRY}
    fi
done

LIST=$(ls ${SOURCE_DIR})
for FILE in ${LIST}; do
    if [[ -f ${SOURCE_DIR}/${FILE} ]]; then
        mv ${SOURCE_DIR}/${FILE} ${TARGET_DIR}
    fi
    if [[ -d ${SOURCE_DIR}/${FILE} ]]; then 
        cp -r ${SOURCE_DIR}/${FILE} ${TARGET_DIR}
    fi
done

NUMBER_OF_FILES=$(ls ${SOURCE_DIR} | wc -w)
if [[ ${NUMBER_OF_FILES} -gt 0 ]]; then
    echo "There is something more."
    if [[ ${NUMBER_OF_FILES} -ge 2 ]]; then
        echo "There are at least 2 files more."
    fi

    if [[ ${NUMBER_OF_FILES} -gt 4 ]]; then
        echo "There are more than 4 files."
    fi

    if [[ ${NUMBER_OF_FILES} -ge 2 && ${NUMBER_OF_FILES} -le 4 ]]; then
        echo "There are at least 2 files more but less than 4 files."
    fi
    
    else
    echo "Kononowicz was there."
fi

REVOKE_LIST=$(ls ${TARGET_DIR})
for FILE in ${REVOKE_LIST}; do
    chmod -w ${TARGET_DIR}/${FILE}
done

DATE=$(date +'%Y-%m-%d')
zip -r bakap_${DATE}.zip ${TARGET_DIR}