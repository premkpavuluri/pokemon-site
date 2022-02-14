#! /bin/bash

source scripts/generate_page.sh

function get_unique_types () {
  local RECORDS="$1"
  local TYPES=$( get_types "${RECORDS}" )

  TYPES=$( echo "${TYPES}" | tr "," "\n" | sort | uniq )
  echo "$TYPES"
}

function filter_records () {
  local FILTER="$1"
  local RECORDS="$2"
  local FILTER_REGEX="^[0-9]\{1,\}|.*|.*${FILTER}"

  echo "${RECORDS}" | grep "${FILTER_REGEX}"
}

function generate_site () {
  local RECORDS="$1"
  local CARD_TEMPLATE="$2"
  local DIR_PATH="$3"
  
  local TYPES=( "all" $( get_unique_types "${RECORDS}" ) )
  for TYPE in "${TYPES[@]}"
  do
    local SELECTED_TYPE="${TYPE}"
    [[ "${TYPE}" == "all" ]] && TYPE=""
    FILTERED_RECORDS=$( filter_records "${TYPE}" "${RECORDS}" )
    
    echo "Creating ${SELECTED_TYPE}.html"
    generate_page "${SELECTED_TYPE}" "${TYPES[*]}" "${FILTERED_RECORDS}" "${CARD_TEMPLATE}" > "${DIR_PATH}/${SELECTED_TYPE}.html"
  done
}