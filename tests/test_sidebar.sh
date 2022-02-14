#! /bin/bash

source scripts/generate_sidebar.sh
source tests/tools.sh

function test_generate_tag () {
    local DESC="Should generate html of tag with given tag details"
    local TAG_NAME="div"
    local ATTRIBUTES="attr='value'"
    local CLASS="ab"
    local CONTENT="this is a tag"
    local EXP_OUTPUT="<div attr='value' class='ab'>this is a tag</div>"

    local ACTUAL_OUTPUT=$( generate_tag "${TAG_NAME}" "${ATTRIBUTES}" "${CLASS}" "${CONTENT}" )
    assert_results "generate_tag" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_generate_sidebar () {
    local DESC="Should generate html of sidebar with given types"
    local SELECTED_TYPE="all"
    local TYPES=( all grass )
    local EXP_OUTPUT="<ul class=''><li class=''><a href='all.html' class='all selected'>all</a></li><li class=''><a href='grass.html' class=''>grass</a></li></ul>"

    local ACTUAL_OUTPUT=$( generate_sidebar  "${SELECTED_TYPE}" "${TYPES[*]}" )
    assert_results "generate_sidebar" "${DESC}" "${ACTUAL_OUTPUT}" "${EXP_OUTPUT}"
}

function test_sidebar () {
    echo "generate_tag"
    test_generate_tag

    echo "generate_sidebar"
    test_generate_sidebar
}