#!/bin/bash

source "${CONTAINER_ENTRYPOINT_PATH}/libce.sh"

function nginx_config_log_to_volume() {
    sed -Ei 's!^(\s*error_log)\s+\S+;!\1  '"${NGINX_LOG_PATH}"'/error.log;!g' "${NGINX_CONF_PATH}/nginx.conf"
    sed -Ei 's!^(\s*access_log)\s+\S+(\s+\S+);!\1  '"${NGINX_LOG_PATH}"'/access.log\2;!g' "${NGINX_CONF_PATH}/nginx.conf"
}

function nginx_process_config_files() {
    local directory="${1:-.}"

    if [ -d "${directory}/conf.d" ]; then
        if [ "$( ls -A "${directory}/conf.d"/*.conf )" ]; then
            cp --verbose "${directory}/conf.d"/*.conf "${NGINX_CONFD_PATH}"
            rm --force --recursive "${directory}/conf.d"
        fi
    fi

    if [ -d "${directory}/default.d" ]; then
        if [ "$( ls -A "${directory}/default.d"/*.conf )" ]; then
            cp --verbose "${directory}/default.d"/*.conf "${NGINX_DEFAULTD_PATH}"
            rm --force --recursive "${directory}/default.d"
        fi
    fi
}

function nginx_process_hook_files() {
    local directory="${1:-.}"

    if [ -d "${directory}/pre-init.d" ]; then
        if [ "$( ls -A "${directory}/pre-init.d"/*.sh )" ]; then
            cp --verbose "${directory}/pre-init.d"/*.sh "${CONTAINER_ENTRYPOINT_PATH}/nginx/pre-init.d"
            rm --force --recursive "${directory}/pre-init.d"
        fi
    fi
}
