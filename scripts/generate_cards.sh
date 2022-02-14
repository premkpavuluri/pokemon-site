#! /bin/bash

function get_field () {
  local RECORD="$1"
  local FIELD=$2

  cut -d"|" -f${FIELD} <<< "${RECORD}"
}

function get_pokemon_name {
  get_field "${1}" 2
}
function get_types {
  get_field "${1}" 3
}
function get_speed {
  get_field "${1}" 4
}
function get_HP {
  get_field "${1}" 5
}
function get_baseXP {
  get_field "${1}" 6
}
function get_attack {
  get_field "${1}" 7
}
function get_defense {
  get_field "${1}" 8
}
function get_weight {
  get_field "${1}" 9
}

function substitute_data () {
  local PLACEHOLDER="$1"
  local REPLACEMENT="$2"
  local TEMPLATE="$3"

  sed "s;${PLACEHOLDER};${REPLACEMENT};g" <<< "${TEMPLATE}"
}

function transform_to_camelcase () {
  local WORD=$1
  local LOWERCASE=$( echo ${WORD} | tr "[:upper:]" "[:lower:]" )

  local FIRST_LETTER=$( cut -c1 <<< ${LOWERCASE} | tr "[:lower:]" "[:upper:]" )
  echo ${LOWERCASE} | sed "s/.\(.*\)/${FIRST_LETTER}\1/"
}

function get_types_template () {
  local TEMPLATE="${1}"
  grep "__TYPE__" <<< "${1}"
}

function apply_types () {
  local TYPES="${1}"
  local TYPES_TEMPLATE="${2}"
  
  OLDIFS=$IFS
  IFS=$','
  for TYPE in ${TYPES}
  do
    local APPLIED_TYPE="${TYPES_TEMPLATE}"
    local TYPE_NAME=$( transform_to_camelcase "${TYPE}" )
    APPLIED_TYPE=$( substitute_data "__CLASS-TYPE__" "${TYPE}" "${APPLIED_TYPE}")
    APPLIED_TYPE=$( substitute_data "__TYPE__" "${TYPE_NAME}" "${APPLIED_TYPE}")

    echo -n ${APPLIED_TYPE}
  done
  IFS=${OLDIFS}
}

function generate_card () {
  local RECORD="${1}"
  local CARD_TEMPLATE="${2}"
  local GENERATED_CARD
  
  local POKEMON_NAME=$( get_pokemon_name "${RECORD}" )
  local POKEMON_TITLE=$( transform_to_camelcase "${POKEMON_NAME}" )
  local TYPES=$( get_types "${RECORD}" )
  local TYPES_TEMPLATE=$( get_types_template "${CARD_TEMPLATE}" )
  local WEIGHT=$( get_weight "${RECORD}" )
  local BASEXP=$( get_baseXP "${RECORD}" )
  local HP=$( get_HP "${RECORD}" )
  local ATTACK=$( get_attack "${RECORD}" )
  local DEFENSE=$( get_defense "${RECORD}" )
  local SPEED=$( get_speed "${RECORD}" )
  
  GENERATED_CARD="${CARD_TEMPLATE}"
  APPLIED_TYPES=$( apply_types "${TYPES}" "${TYPES_TEMPLATE}" )

  sed "s#__POKEMON-NAME__#${POKEMON_NAME}#g;
       s#__POKEMON-TITLE__#${POKEMON_TITLE}#g;
       s#${TYPES_TEMPLATE}#${APPLIED_TYPES}#;
       s#__WEIGHT__#${WEIGHT}#;
       s#__BASE-XP__#${BASEXP}#;
       s#__HP__#${HP}#;
       s#__ATTACK__#${ATTACK}#;
       s#__DEFENSE__#${DEFENSE}#;
       s#__SPEED__#${SPEED}#;" <<< "${GENERATED_CARD}"  
}

function generate_multiple_cards () {
  local RECORDS="$1"
  local CARD_TEMPLATE="$2"
  local GENERATED_CARDS

  OLDIFS=$IFS
  IFS=$'\n'
  for RECORD in ${RECORDS}
  do
    GENERATED_CARDS+=$( generate_card "${RECORD}" "${CARD_TEMPLATE}" )
  done
  IFS=${OLDIFS}

  echo "${GENERATED_CARDS}"
}