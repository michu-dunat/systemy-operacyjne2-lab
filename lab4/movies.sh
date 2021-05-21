#!/bin/bash -eu

function print_help () {
    echo "This script allows to search over movies database"
    echo -e "-d DIRECTORY\n\tDirectory with files describing movies"
    echo -e "-a ACTOR\n\tSearch movies that this ACTOR played in"
    echo -e "-t QUERY\n\tSearch movies with given QUERY in title"
    echo -e "-y YEAR\n\tSearch movies that were made after the given YEAR"
    echo -e "-r REGEX\n\tSearch movies that plot matches given REGEX"
    echo -e "-f FILENAME\n\tSaves results to file (default: results.txt)"
    echo -e "-x\n\tPrints results in XML format"
    echo -e "-h\n\tPrints this help message"
}

function print_error () {
    echo -e "\e[31m\033[1m${@}\033[0m" >&2
}

function get_movies_list () {
    local -r MOVIES_DIR=${1}
    local -r MOVIES_LIST=$(cd "${MOVIES_DIR}" && realpath *)
    echo "${MOVIES_LIST}"
}

function query_title () {
    # Returns list of movies from ${1} with ${2} in title slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Title" ${MOVIE_FILE} | grep -q "${QUERY}"; then
            RESULTS_LIST+=( ${MOVIE_FILE} )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_actor () {
    # Returns list of movies from ${1} with ${2} in actor slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Actors" ${MOVIE_FILE} | grep -q "${QUERY}"; then
            RESULTS_LIST+=( ${MOVIE_FILE} )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

# Dokończ funkcję “print_xml_format”
function print_xml_format () {
    local -r FILENAME=${1}

    local TEMP=$(cat "${FILENAME}")

    # TODO: replace first line of equals signs
    TEMP="${TEMP//==================================================/<movie>}"
    # TODO: change 'Author:' into <Author>
    TEMP="${TEMP//| Author: /<Author>}"
    # TODO: change others too
    TEMP="${TEMP//| Title: /<Title>}"
    TEMP="${TEMP//| Year: /<Year>}"
    TEMP="${TEMP//| Runtime: /<Runtime>}"
    TEMP="${TEMP//| IMDB: /<IMDB>}"
    TEMP="${TEMP//| Tomato: /<Tomato>}"
    TEMP="${TEMP//| Rated: /<Rated>}"
    TEMP="${TEMP//| Genre: /<Genre>}"
    TEMP="${TEMP//| Director: /<Director>}"
    TEMP="${TEMP//| Actors: /<Actors>}"
    TEMP="${TEMP//| Plot: /<Plot>}"

    # append tag after each line
    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+).*/\0<\/\1>/')

    # replace the last line with </movie>
    TEMP=$(echo "${TEMP}" | sed '$s/===*/<\/movie>/')

    echo "${TEMP}"
}

function print_movies () {
    local -r MOVIES_LIST=$(echo "${1}")
    local -r OUTPUT_FORMAT=${2}    

    for MOVIE_FILE in ${MOVIES_LIST}; do
        if [[ "${OUTPUT_FORMAT}" == "xml" ]]; then
            print_xml_format "${MOVIE_FILE}"
        else
            cat "${MOVIE_FILE}"
        fi
    done
}

# jeżeli plik podany przez użytkownika nie posiada rozszerzenia '.txt' dodaj je
function modify_extension() {
    EXTENSION=".${FILE_4_SAVING_RESULTS##*.}"
    if [[ ${EXTENSION} != ".txt" ]]; then
        FILE_4_SAVING_RESULTS="${FILE_4_SAVING_RESULTS//$EXTENSION/}.txt"
    fi
}

# Dodaj opcję -y ROK: wyszuka wszystkie filmy nowsze niż ROK.
function query_year () {
    # Returns list of movies from ${1} with ${2} after year slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        YEAR_LINE=$(grep "| Year" "${MOVIE_FILE}")
        YEAR=${YEAR_LINE##*Year: }
        if [[ ${YEAR} > ${QUERY} ]]; then
            RESULTS_LIST+=( ${MOVIE_FILE} )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

# Dodaj wyszukiwanie po polu z fabułą, za pomocą wyrażenia regularnego. Jeżeli dodatkowo podamy parametr '-i' to ignoruje wielkość liter
function query_plot () {
    # Returns list of movies from ${1} with plot that matches ${2} regular expression
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if [[ "${IS_I_FLAG_USED}" == false ]]; then
            if grep "| Plot" ${MOVIE_FILE} | grep -qE "${QUERY}"; then
                RESULTS_LIST+=( ${MOVIE_FILE} )
            fi
        else
            if grep "| Plot" ${MOVIE_FILE} | grep -qiE "${QUERY}"; then
                RESULTS_LIST+=( ${MOVIE_FILE} )
            fi
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

ANY_ERRORS=false
IS_D_FLAG_USED=false
IS_I_FLAG_USED=false

while getopts ":hd:t:a:y:r:i:f:x" OPT; do
  case ${OPT} in
    h)
        print_help
        exit 0
        ;;
    d)
        MOVIES_DIR=${OPTARG}
        IS_D_FLAG_USED=true
        ;;
    t)
        SEARCHING_TITLE=true
        QUERY_TITLE=${OPTARG}
        ;;
    y)
        SEARCHING_YEAR=true
        QUERY_YEAR=${OPTARG}
        ;;
    r)  
        SEARCHING_PLOT=true
        QUERY_PLOT=${OPTARG}
        ;;
    i)
        IS_I_FLAG_USED=true
        HALO=${OPTARG}
        ;;
    f)
        FILE_4_SAVING_RESULTS=${OPTARG}
        ;;
    a)
        SEARCHING_ACTOR=true
        QUERY_ACTOR=$( echo "${OPTARG}")
        ;;
    x)
        OUTPUT_FORMAT="xml"
        ;;
    \?)
        print_error "ERROR: Invalid option: -${OPTARG}"
        ANY_ERRORS=true
        exit 1
        ;;
  esac
done

# Dodaj sprawdzenie, czy na pewno wykorzystano opcję '-d' i czy jest to katalog
if [[ "$IS_D_FLAG_USED" == false ]]; then
    echo "Use -d flag"
else 
    
    if [[ -d ${MOVIES_DIR} ]]; then

        MOVIES_LIST=$(get_movies_list "${MOVIES_DIR}")

        if ${SEARCHING_TITLE:-false}; then
            MOVIES_LIST=$(query_title "${MOVIES_LIST}" "${QUERY_TITLE}")
        fi

        if ${SEARCHING_ACTOR:-false}; then
            MOVIES_LIST=$(query_actor "${MOVIES_LIST}" "${QUERY_ACTOR}")
        fi

        if ${SEARCHING_YEAR:-false}; then
            MOVIES_LIST=$(query_year "${MOVIES_LIST}" "${QUERY_YEAR}")
        fi

        if ${SEARCHING_PLOT:-false}; then
            echo "${IS_I_FLAG_USED}"
            MOVIES_LIST=$(query_plot "${MOVIES_LIST}" "${QUERY_PLOT}")
        fi

        if [[ "${#MOVIES_LIST}" < 1 ]]; then
            echo "Found 0 movies :-("
            exit 0
        fi

        if [[ "${FILE_4_SAVING_RESULTS:-}" == "" ]]; then
            print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}"
        else
            # TODO: add XML option
            modify_extension
            print_movies "${MOVIES_LIST}" "raw" | tee "${FILE_4_SAVING_RESULTS}"
        fi

    else
        echo "${MOVIES_DIR} isn't a dir."

    fi
fi