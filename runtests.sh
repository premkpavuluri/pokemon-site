#! /bin/bash

source tests/test_generate_site.sh
source tests/test_generate_page.sh
source tests/test_sidebar.sh
source tests/test_generate_cards.sh

function test_all () {
    test_cards
    test_sidebar
    test_generate_page
    test_site
}

test_all
report
