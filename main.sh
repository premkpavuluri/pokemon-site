#! /bin/bash

source scripts/generate_site.sh

DATA="`tail +2 database/pokemon.csv`"
TEMPLATE="`cat database/card_template.html`"
DIR_PATH="html"

rm -rf ${DIR_PATH}
mkdir  ${DIR_PATH}
cp resources/{styles.css,images.tar.gz} ${DIR_PATH}
$( cd ${DIR_PATH} ; tar -xzf images.tar.gz ; rm images.tar.gz )

time generate_site "${DATA}" "${TEMPLATE}" "${DIR_PATH}"

open ${DIR_PATH}/all.html
