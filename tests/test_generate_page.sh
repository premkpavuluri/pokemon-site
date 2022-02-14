#! /bin/bash

source tests/tools.sh
source scripts/generate_page.sh

function test_generate_page () {  
    local DESC="Should generate a page of a type"
    local PAGE_TYPE="all"
    local TYPES=( all grass )
    local POKEMONS_DATA="1|bulbasaur|grass|1|2|3|4|5|6"
    local CARD_TEMPLATE=`cat tests/test_files/card_template.html`
    local EXP_OUTPUT=`cat tests/test_files/exp_allpage.html`

    local ACTUAL_OUTPUT=$( generate_page "${PAGE_TYPE}" "${TYPES[*]}" "${POKEMONS_DATA}" "${CARD_TEMPLATE}" )
    echo "generate_page"
    assert_results "generate_page" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}