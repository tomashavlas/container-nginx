function _create_test_data() {
    local volume="$1"; shift

    echo "success" > "${volume}/index.html"
}

function _test_arbitrary_user() {
    local ip="$1"; shift
    local download; download="$( cci_download "http://${ip}:8080/index.html" )"

    grep --quiet -e '^success$' "${download}"
}

function cci_case_arbitrary_user() {
    local -r TESTCASE_NAME="${TESTSUITE_NAME}_arbitrary_user"

    cci_print info "Running $( cci_case_arbitrary_user_desc )"

    local volume; volume="$( cci_volume_create "${TESTCASE_NAME}_data" )"
    cci_suite_fix_permissions "${volume}" 65533
    cci_cmd '_create_test_data "${volume}"' 0 \
        "Creating test data"

    CONTAINER_ARGS="--user 65533 -v ${volume}:/srv/www:Z"
    cci_cmd 'cci_container_create "${TESTCASE_NAME}" run-nginx' 0 \
        "Creating container with arbitrary user"
    CONTAINER_ARGS=
    sleep 2

    local ip; ip="$( cci_container_get_ip "${TESTCASE_NAME}" )"
    cci_cmd '_test_arbitrary_user "${ip}"' 0 \
        "Testing container with arbitrary user"
}

function cci_case_arbitrary_user_desc() {
    echo 'arbitrary user support tests'
}
