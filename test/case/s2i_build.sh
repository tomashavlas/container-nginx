function _build_s2i_image() {
    local source="$1"; shift

    s2i usage --pull-policy=never "${IMAGE_NAME}"
    s2i build --pull-policy=never "file://${TESTSUITE_PATH}/${source}" "${IMAGE_NAME}" "${IMAGE_NAME}-${source}"
}

function _test_sample_app() {
    local ip="$1"; shift
    local download

    download="$( cci_download "http://${ip}:8080/index.html" )"
    fgrep --quiet '<h1>This is a sample s2i application with static content.</h1>' "${download}"

    download="$( cci_download "http://${ip}:8080/test.html" )"
    fgrep --quiet '<p>This is a sample s2i application with static content.</p>' "${download}"

    download="$( cci_download "http://${ip}:8888/" )"
    fgrep --quiet '<p>This is a sample s2i application with static content.</p>' "${download}"
}

function cci_case_s2i_build() {
    local -r TESTCASE_NAME="${TESTSUITE_NAME}_s2i_build"

    cci_print info "Running $( cci_case_s2i_build_desc )"

    cci_cmd '_build_s2i_image "sample-app"' 0 \
        "Building s2i image for sample-app"

    cci_cmd 'IMAGE_NAME="${IMAGE_NAME}-sample-app" cci_container_create "${TESTCASE_NAME}"' 0 \
        "Creating container form built s2i image"
    sleep 2

    local ip; ip="$( cci_container_get_ip "${TESTCASE_NAME}" )"
    cci_cmd '_test_sample_app "${ip}"' 0 \
        "Testing s2i sample app"
}

function cci_case_s2i_build_desc() {
    echo 'source-to-image build support tests'
}
