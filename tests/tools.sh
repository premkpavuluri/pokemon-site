#report_arrays
DESCRIPTION=()
ACTUAL_DETAILS=()
EXPECTED_DETAILS=()

#Global variable
GREEN='\033[0;32m'
RED='\033[5;31m'
NORMAL='\033[0m'
BOLD='\033[1;m'
THIN="\033[2;m"
PASS=$( echo -e "${GREEN}\xE2\x9C\x94${NORMAL}" )
FAIL=$( echo -e "${RED}X${NORMAL}" )
TOTAL_TESTS=0
FAILED_TESTS=0

function assert_results () {
    local function_name="$1"
    local description="$2"
    local actual_output="$3"
    local expected_output="$4"
    local test_result="${PASS}"

    if [[ "${actual_output}" != "${expected_output}" ]] ; then
        test_result="${FAIL}"
        FAILED_TESTS=$(( ${FAILED_TESTS} + 1 ))
        DESCRIPTION[${FAILED_TESTS}]=`echo "${function_name}|${description}"`
        ACTUAL_DETAILS[${FAILED_TESTS}]="${actual_output}"; EXPECTED_DETAILS[${FAILED_TESTS}]="${expected_output}"
    fi

    TOTAL_TESTS=$(( ${TOTAL_TESTS} + 1 ))
    echo "  ${test_result} ${description}"
}

function assert_files () {
	local function_name="$1"
	local description="$2"
	local actual_file="$3"
	local expected_file="$4"
	local test_result="${PASS}"

	diff "${actual_file}" "${expected_file}" &> /dev/null
	file_status=$?

	if [[ ${file_status} != 0 ]] ; 	then
		test_result="${FAIL}"
		FAILED_TESTS=$(( ${FAILED_TESTS} + 1 ))
		DESCRIPTION[${FAILED_TESTS}]=`echo "${function_name}|${description}"`
		ACTUAL_DETAILS[${FAILED_TESTS}]="${actual_file}"; EXPECTED_DETAILS[${FAILED_TESTS}]="${expected_file}"
	fi

	TOTAL_TESTS=$(( ${TOTAL_TESTS} + 1 ))
	echo "  ${test_result} ${description}"
}

function report () {
    echo -e "\n\nREPORT:"
    echo -e "Total tests: ${TOTAL_TESTS}  |  FAILED TESTS:${FAILED_TESTS}/${TOTAL_TESTS}"

    for (( index=1 ; index<=${FAILED_TESTS} ; index=$(( $index + 1 )) ))
    do
        function_name=`echo "${DESCRIPTION[${index}]}" | cut -d"|" -f1`
        test_name=`echo "${DESCRIPTION[${index}]}" | cut -d"|" -f2`
        echo -e "\n${BOLD}${function_name}${NORMAL}\n  ${RED}${index}. ${test_name}${NORMAL}"
        echo -e "${THIN}Actual Output: ${NORMAL}" ; echo -e "${ACTUAL_DETAILS[${index}]}\n"
        echo -e "${THIN}Expected Output: ${NORMAL}" ; echo -e "${EXPECTED_DETAILS[${index}]}\n"
    done
}