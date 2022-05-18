#!/bin/bash

# Start UI first
cd qhana-ui
npm install
ng serve &
cd -

# Start the rest with docker compose
docker-compose --profile with_db up
