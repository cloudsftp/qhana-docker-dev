#!/bin/bash

help() {
    echo "Usage: $0 [MODE [OPTIONS]]"
    echo
    echo "MODE:"
    echo "     <empty>              for development mode"
    echo "     docker               for docker mode"
    echo
    echo "OPTIONS for docker mode:"
    echo "   --rebuild-runner       Rebuilds qhana-plugin-runner"
    echo "   --rebuild | -r         Rebuilds all services"
    echo
    
    exit 2
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
    [ "${REBUILD_IMAGES}" = "true" ] && docker-compose -f docker-compose-complete.yaml \
                                            build --parallel ${IMAGES_TO_REBUILD}

    # Start the rest with docker compose
    docker-compose -f docker-compose-complete.yml --profile with_db up
}

dev_mode() {
    # Start UI first
    cd qhana-ui
    if ! [ -x "$(command -v npm)" ]; then
        echo "Please install npm first!"
        exit 2
    fi
    npm install

    if ! [ -x "$(command -v ng)" ]; then
        echo "Please install @angular/cli gobally"
        echo "You can do this by running 'sudo npm i -g @angular/cli'"
        exit 2
    fi
    ng serve --poll 2000 &
    NG_PID=$!
    cd -

    # Then start the plugin runner
    cd qhana-plugin-runner
    if ! [ -x "$(command -v poetry)" ]; then
        echo "Please install poetry first!"
        exit 2
    fi
    poetry run flask run &
    PLUGIN_RUNNER_PID=$!

    poetry run invoke start-broker
    poetry run invoke worker &
    WORKER_PID=$!
    cd -
    
    docker-compose -f docker-compose-minimal.yml up

    # Stop ng and flask
    [ -d "/proc/${NG_PID}" ] && kill "${NG_PID}"
    [ -d "/proc/${PLUGIN_RUNNER_PID}" ] && kill "${PLUGIN_RUNNER_PID}"
    [ -d "/proc/${WORKER_PID}" ] && kill "${WORKER_PID}"
}

if [ "$#" -eq 0 ]; then
    dev_mode
elif [ "$1" = "docker" ]; then
    shift
    docker_mode
else
    help
fi
