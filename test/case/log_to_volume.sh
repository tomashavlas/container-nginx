function _test_log_to_volume() {
    local ip="$1"; shift
    local volume="$1"; shift

    set -o errexit

    curl "http://${ip}:8080" > /dev/null
    test -f "${volume}/access.log"
    test -f "${volume}/error.log"

    set +o errexit
}

function cci_case_log_to_volume() {
    local -r TESTCASE_NAME="${TESTSUITE_NAME}_log_to_volume"

    cci_print info "Running $( cci_case_log_to_volume_desc )"

    local volume; volume="$( cci_volume_create "${TESTCASE_NAME}_log" )"

    CONTAINER_ARGS="-e NGINX_LOG_TO_VOLUME=1 -v ${volume}:/var/log/nginx:Z"
    cci_cmd 'cci_container_create "${TESTCASE_NAME}" run-nginx' 0 \
        "Creating container with log volume"
    CONTAINER_ARGS=
    sleep 2

    local ip; ip="$( cci_container_get_ip "${TESTCASE_NAME}" )"
    cci_cmd '_test_log_to_volume "${ip}" "${volume}"' 0 \
        "Testing logs volume"

}

function cci_case_log_to_volume_desc() {
    echo 'nginx logging to volume `/var/log/nginx` tests'
}
