#! /bin/bash

source scripts/generate_cards.sh
source scripts/generate_sidebar.sh

function generate_page () {
  local PAGE_TYPE="$1"
  local TYPES=(${2})
  local POKEMONS_DATA="$3"
  local CARD_TEMPLATE="$4"

  local PAGE_TITLE=$( generate_tag "title" "" "" "Pokemon" )
  local STYLES_LINK=$( echo "<link rel='stylesheet' href='styles.css' />" )
  local HEAD=$( generate_tag "head" "" "" "${PAGE_TITLE}${STYLES_LINK}")
 
  local SIDEBAR=$( generate_sidebar "${PAGE_TYPE}" "${TYPES[*]}" )
  SIDEBAR=$( generate_tag "nav" "" "sidebar" "${SIDEBAR}")
 
  local POKEMON_CARDS=$( generate_multiple_cards "${POKEMONS_DATA}" "${CARD_TEMPLATE}" )
  local MAIN=$( generate_tag "main" "" "cards-container" "${POKEMON_CARDS}" )
  local BODY=$( generate_tag "div" "" "page-wrapper" "${SIDEBAR}${MAIN}")
  BODY=$( generate_tag "body" "" "" "${BODY}" )
  local HTML=$( echo "<html>${HEAD}${BODY}</html>" )

  echo "${HTML}"
}