function _create_test_data() {
    local volume="$1"; shift

    echo "success" > "${volume}/index.html"
}

function _test_data_volume() {
    local ip="$1"; shift
    local download; download="$( cci_download "http://${ip}:8080/index.html" )"

    grep --quiet -e '^success$' "${download}"
}

function cci_case_data_volume() {
    local -r TESTCASE_NAME="${TESTSUITE_NAME}_data_volume"

    cci_print info "Running $( cci_case_data_volume_desc )"

    local volume; volume="$( cci_volume_create "${TESTCASE_NAME}_data" )"
    cci_cmd '_create_test_data "${volume}"' 0 \
        "Creating test data"

    CONTAINER_ARGS="-v ${volume}:/srv/www:Z"
    cci_cmd 'cci_container_create "${TESTCASE_NAME}" run-nginx' 0 \
        "Creating container with data volume"
    CONTAINER_ARGS=
    sleep 2

    local ip; ip="$( cci_container_get_ip "${TESTCASE_NAME}" )"
    cci_cmd '_test_data_volume "${ip}"' 0 \
        "Testing container data volume"
}

function cci_case_data_volume_desc() {
    echo 'data volume `/srv/www` mount tests'
}
