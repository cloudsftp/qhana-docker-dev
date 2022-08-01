#!/bin/bash

ROOT_DIR="$(pwd)"

help() {
    echo "Usage: $0 [MODE] [OPTIONS]"
    echo
    echo "MODE:"
    echo "     <empty>              For development mode"
    echo "     docker               For docker mode"
    echo
    echo "OPTIONS for development mode:"
    echo "   --no-ui                Does not start the user interface"
    echo "   --no-worker            Does not start the worker"
    echo "   --no-plugin-runner     Does not start the plugin runner"
    echo "   --no-nisq-ui           Does not start the user interface for the nisq analyzer"
    echo
    echo "OPTIONS for docker mode:"
    echo "   --rebuild-runner       Rebuilds qhana-plugin-runner (the same image is used for the worker)"
    echo "   --rebuild-ui           Rebuilds qhana-ui"
    echo "   --rebuild-nisq-ui      Rebuilds nisq-analyzer-ui"
    echo "   --rebuild | -r         Rebuilds all services"
    echo
    
    exit 2
}

info() {
    echo
    echo [START SCRIPT] $@
    echo
}

docker_mode() {
    REBUILD_IMAGES="false"
    REBUILD_ALL_IMAGES="false"

    while [ $# -gt 0 ]; do
        case "$1" in
            --rebuild-runner)
                REBUILD_IMAGES="true"
                [ "${REBUILD_ALL_IMAGES}" = "true" ] || IMAGES_TO_REBUILD="${IMAGES_TO_REBUILD} qhana-plugin-runner"
                shift
                ;;
            --rebuild-ui)
                REBUILD_IMAGES="true"
                [ "${REBUIld_ALL_IMAGES}" = "true" ] || IMAGES_TO_REBUILD="${IMAGES_TO_REBUILD} qhana-ui"
                shift
                ;;
            --rebuild-nisq-ui)
                REBUILD_IMAGES="true"
                [ "${REBUIld_ALL_IMAGES}" = "true" ] || IMAGES_TO_REBUILD="${IMAGES_TO_REBUILD} nisq-analyzer-ui"
                shift
                ;;
            --rebuild | -r)
                REBUILD_IMAGES="true"
                REBUILD_ALL_IMAGES="true"
                IMAGES_TO_REBUILD="" # Rebuilds all
                shift
                ;;
            *)
                help
        esac
    done

    # Rebuild images
    [ "${REBUILD_IMAGES}" = "true" ] && docker-compose -f docker-compose-complete.yml \
                                            build ${IMAGES_TO_REBUILD}

    # Start the rest with docker compose
    docker-compose -f docker-compose-complete.yml --profile with_db up
}

dev_mode() {
    UI_LOG="${ROOT_DIR}/ui.log"
    PR_LOG="${ROOT_DIR}/plugin-runner.log"
    WR_LOG="${ROOT_DIR}/worker.log"
    NISQ_UI_LOG="${ROOT_DIR}/nisq-analyzer-ui.log"

    while [ $# -gt 0 ]; do
        case "$1" in
            --no-ui)
                NO_UI="true"
                shift
                ;;
            --no-worker)
                NO_WORKER="true"
                shift
                ;;
            --no-plugin-runner)
                NO_PLUGIN_RUNNER="true"
                shift
                ;;
            --no-nisq-analyzer-ui)
                NO_NISQ_ANALYZER_UI="true"
                shift
                ;;
            *)
                help
        esac
    done

    # Start UI first
    if ! [ "${NO_UI}" = "true" ]; then
        cd qhana-ui
        npm install
        
        info "Starting the user interface. Log is written to ${UI_LOG}"
        ng serve --poll 2000 &> "${UI_LOG}" &
        NG_PID=$!
        cd -
    fi

    # Then start the plugin runner
    cd qhana-plugin-runner
    if ! [ "${NO_PLUGIN_RUNNER}" = "true" ]; then
        info "Starting the plugin runner. Log is written to ${PR_LOG}"
        poetry run flask run &> "${PR_LOG}" &
        PLUGIN_RUNNER_PID=$!
    fi

    if ! [ "${NO_WORKER}" = "true" ]; then
        poetry run invoke start-broker
        info "Starting the worker. Log is written to ${WR_LOG}"
        poetry run invoke worker &> "${WR_LOG}" &
        WORKER_PID=$!
    fi
    cd -
    
    # Also start the NISQ Analyzer UI
    
    if ! [ "${NO_NISQ_ANALYZER_UI}" = "true" ]; then
        export NISQ_ANALYZER_HOST_NAME="localhost"
        export NISQ_ANALYZER_PORT="6473"
        
        cd nisq-analyzer-ui
        info "Starting the NISQ Analyzer UI. Log is written to ${NISQ_UI_LOG}"
        npm install
        sudo echo you need to have root privileges
        sudo ng serve --port 80 &> "${NISQ_UI_LOG}" &
        NISQ_NG_PID=$!
        cd -
    fi
    
    docker-compose -f docker-compose-minimal.yml up

    # Stop ng and flask
    [ -d "/proc/${NG_PID}" ] && kill "${NG_PID}"
    [ -d "/proc/${PLUGIN_RUNNER_PID}" ] && kill "${PLUGIN_RUNNER_PID}"
    [ -d "/proc/${WORKER_PID}" ] && kill "${WORKER_PID}"
    [ -d "/proc/${NISQ_NG_PID}" ] && kill "${NISQ_NG_PID}"
}

if [ "$#" -eq 0 ]; then
    dev_mode
elif [ "$1" = "docker" ]; then
    shift
    docker_mode "$@"
else
    dev_mode "$@"
fi
