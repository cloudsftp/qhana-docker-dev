#!/bin/bash

REBUILD_IMAGES="false"

while [ $# -gt 0 ]; do
    case "$1" in
        --rebuild-runner | -r)
            REBUILD_IMAGES="true"
            IMAGES_TO_REBUILD="${IMAGES_TO_REBUILD} qhana-plugin-runner"
            shift
            ;;
        *)
            echo "Usage: $0 [OPTIONS]"
            echo
            echo "OPTIONS:"
            echo
            echo "   --rebuild-runner       Rebuilds qhana-plugin-runner"
            echo
            
            exit 2
    esac
done

# Rebuild images
[ "${REBUILD_IMAGES}" = "true" ] && docker-compose build --parallel ${IMAGES_TO_REBUILD}

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

# Start the rest with docker compose
docker-compose --profile with_db up

# Stop ng
[ -d "/proc/${NG_PID}" ] && kill "${NG_PID}"
