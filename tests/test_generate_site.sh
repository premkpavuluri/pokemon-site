#! /bin/bash

source tests/tools.sh
source scripts/generate_site.sh

function test_get_unique_types () {
  local DESC="Should give all the types in csv"
  local DATA="`cat tests/test_files/pokemon.csv`"
  local EXP_OUTPUT="`echo -e "fire\ngrass\npoison"`"

  local ACTUAL_OUTPUT=$( get_unique_types "${DATA}" )
  assert_results "get_unique_types" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_filter_records () {
  local DESC="Should give filtered records of type in csv"
  local FILTER="grass"
  local RECORDS="`cat tests/test_files/pokemon.csv`"
  local EXP_OUTPUT="`echo -e "1|bulbasaur|grass,poison|45|45|64|49|49|69\n2|ivysaur|grass,poison|60|60|142|62|63|130\n3|venusaur|grass,poison|80|80|236|82|83|1000"`"

  local ACTUAL_OUTPUT=$( filter_records "${FILTER}" "${RECORDS}" )
  assert_results "filter_records" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_generate_site () {
  local DESC="Should generate pages of all types"
  local RECORDS="`cat tests/test_files/pokemon.csv`"
  local CARD_TEMPLATE="`cat tests/test_files/card_template.html`"
  local DESTINATION_DIR="tests/test_files/html"
  local EXP_OUTPUT="`echo -e "all.html\nfire.html\ngrass.html\npoison.html"`"
  
  generate_site "${RECORDS}" "${CARD_TEMPLATE}" "${DESTINATION_DIR}" > /dev/null
  local ACTUAL_OUTPUT=$( ls ${DESTINATION_DIR} )
  assert_results "filter_records" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_generate_site_file () {
  local DESC="Should write generated html to new file"
  local EXP_FILE="tests/test_files/exp_siteall.html"
  local ACT_FILE="tests/test_files/html/all.html"

  assert_files "generate_site" "${DESC}" "${ACT_FILE}" "${EXP_FILE}"
}

function test_site () {
  echo "test_get_unique_types"
  test_get_unique_types

  echo "test_filter_records"
  test_filter_records

  echo "test_generate_site"
  test_generate_site  
  test_generate_site_file
}
