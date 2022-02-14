#! /bin/bash

function generate_tag () {
  local TAG_NAME="$1"
  local ATTRIBUTES="$2"
  local CLASS="$3"
  local CONTENT="$4"

  local TAG=$( echo "<${TAG_NAME} ${ATTRIBUTES} class='${CLASS}'>${CONTENT}</${TAG_NAME}>" )
  echo ${TAG}
}

function generate_sidebar () {
  local SELECTED_TYPE="$1"
  local TYPES=(${2})
  local GENERATED_SIDEBAR

  for type in ${TYPES[@]}
  do
    local SELECTED_CLASS=""
    [[ "${type}" == "${SELECTED_TYPE}" ]] && SELECTED_CLASS="${type} selected"

    local anchor=$( generate_tag "a" "href='${type}.html'" "${SELECTED_CLASS}" "${type}")
    local list_item=$( generate_tag "li" "" "" "$anchor" )
    GENERATED_SIDEBAR+=$list_item
  done
  generate_tag "ul" "" "" "$GENERATED_SIDEBAR"
}