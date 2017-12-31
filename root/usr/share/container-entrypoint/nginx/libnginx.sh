#!/bin/bash

source "${CONTAINER_ENTRYPOINT_PATH}/libce.sh"

function nginx_config_log_to_volume() {
    sed -Ei 's!^(\s*error_log)\s+\S+;!\1  '"${NGINX_LOG_PATH}"'/error.log;!g' "${NGINX_CONF_PATH}/nginx.conf"
    sed -Ei 's!^(\s*access_log)\s+\S+(\s+\S+);!\1  '"${NGINX_LOG_PATH}"'/access.log\2;!g' "${NGINX_CONF_PATH}/nginx.conf"
}

function nginx_process_config_files() {
    local dir="${1:-.}"

    if [ -d ${dir}/conf.d ]; then
        if [ "$( ls -A ${dir}/conf.d/*.conf )" ]; then
            cp --verbose ${dir}/conf.d/*.conf "${NGINX_CONFD_PATH}"
            rm --force --recursive ${dir}/conf.d
        fi
    fi

    if [ -d ${dir}/default.d ]; then
        if [ "$( ls -A ${dir}/default.d/*.conf )" ]; then
            cp --verbose ${dir}/default.d/*.conf "${NGINX_DEFAULTD_PATH}"
            rm --force --recursive ${dir}/default.d
        fi
    fi
}