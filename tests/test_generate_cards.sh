#! /bin/bash

source scripts/generate_cards.sh
source tests/tools.sh

function test_cases_get_field () {
  local DESC="Should get the specified field"
  local RECORD="Hello|world|3"
  local FIELD="2"
  local EXP_OUTPUT="world"

  local ACTUAL_OUTPUT=$( get_field "${RECORD}" "${FIELD}" )
  assert_results "get_field" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_get_pokemon_name () {
  local DESC="Should get the pokemon name"
  local RECORD="1|bulbasaur|grass,poison|1|2|3|4|5|6"
  local EXP_OUTPUT="bulbasaur"

  local ACTUAL_OUTPUT=$( get_pokemon_name "${RECORD}" )
  assert_results "get_pokemon_name" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_get_types () {
  local DESC="Should get the pokemon types"
  local RECORD="1|bulbasaur|grass,poison|1|2|3|4|5|6"
  local EXP_OUTPUT="grass,poison"

  local ACTUAL_OUTPUT=$( get_types "${RECORD}" )
  assert_results "get_types" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_substitute_data () {
  local DESC="Should substitute given data in place of PLACEHOLDER"
  local PLACEHOLDER="name"
  local SUBSTITUTE="prem"
  local TEMPLATE="<html><body><p>Hello,I am name</p></body></html>"
  local EXP_OUTPUT="<html><body><p>Hello,I am prem</p></body></html>"

  local ACTUAL_OUTPUT=$( substitute_data ${PLACEHOLDER} ${SUBSTITUTE} "${TEMPLATE}" )
  assert_results "substitute_data" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_substitute_data_at_multiple_places () {
  local DESC="Should substitute given data in place of PLACEHOLDER at multiple places"
  local PLACEHOLDER="name"
  local SUBSTITUTE="prem"
  local TEMPLATE="<html><body><p>Hello,I am name</p><p>Hello,I am name</p></body></html>"
  local EXP_OUTPUT="<html><body><p>Hello,I am prem</p><p>Hello,I am prem</p></body></html>"
  
  local ACTUAL_OUTPUT=$( substitute_data ${PLACEHOLDER} ${SUBSTITUTE} "${TEMPLATE}" )
  assert_results "substitute_data" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_transform_to_camelcase () {
  local DESC="Should transform a word to camel case"
  local WORD="grass"
  local EXP_OUTPUT="Grass"

  local ACTUAL_OUTPUT=$( transform_to_camelcase ${WORD} )
  assert_results "transform_to_camelcase" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_get_types_template () {
  local DESC="Should get types template"
  local TEMPLATE=$( echo -e "<div>\n<span class=\"__CLASS-TYPE__ type\">__TYPE__</span>\n</div>" )
  local EXP_OUTPUT="<span class=\"__CLASS-TYPE__ type\">__TYPE__</span>"

  local ACTUAL_OUTPUT=$( get_types_template "${TEMPLATE}" )
  assert_results "get_types_template" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_apply_types () {
  local DESC="Should apply types on types-template"
  local TYPES="grass,poison"
  local TYPES_TEMPLATE="<span class=\"__CLASS-TYPE__ type\">__TYPE__</span>"
  local EXP_OUTPUT="<span class=\"grass type\">Grass</span><span class=\"poison type\">Poison</span>"

  local ACTUAL_OUTPUT=$( apply_types "${TYPES}" "${TYPES_TEMPLATE}" )
  assert_results "apply_types" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_generate_card () {
  local DESC="Should generate a pokemon card with given details"
  local POKEMON_DETAILS="1|bulbasaur|grass,poison|1|2|3|4|5|6"
  local CARD_TEMPLATE=$( cat tests/test_files/card_template.html )
  local EXP_OUTPUT=$( cat tests/test_files/exp_card.html )

  local ACTUAL_OUTPUT=$( generate_card "${POKEMON_DETAILS}" "${CARD_TEMPLATE}" )
  assert_results "generate_card" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_generate_multiple_cards () {
  local DESC="Should generate pokemon cards with given details based on template"
  local POKEMON_DETAILS=`echo -e "1|bulbasaur|grass,poison|1|2|3|4|5|6\n2|ivi|abc|1|2|3|4|5|6"`
  local CARD_TEMPLATE=$( cat tests/test_files/card_template.html )
  local EXP_OUTPUT=$( cat tests/test_files/exp_multiple_cards.html )

  local ACTUAL_OUTPUT=$( generate_multiple_cards "${POKEMON_DETAILS}" "${CARD_TEMPLATE}" )
  assert_results "generate_multiple_cards" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_cards () {
  echo "get_field"
  test_cases_get_field

  echo "get_pokemon_name"
  test_get_pokemon_name

  echo "get_types"
  test_get_types

  echo "substitute_data"
  test_substitute_data
  test_substitute_data_at_multiple_places

  echo "transform_to_camelcase"
  test_transform_to_camelcase
  
  echo "get_types_template"
  test_get_types_template
 
  echo "apply_types"
  test_apply_types

  echo "generate_card"
  test_generate_card
  
  echo "generate_multiple_cards"
  test_generate_multiple_cards
}