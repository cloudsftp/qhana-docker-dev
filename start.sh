#!/bin/bash

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
ng serve &
cd -

# Start the rest with docker compose
docker-compose --profile with_db up
