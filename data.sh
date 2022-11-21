#!/bin/bash

declare -A to_store=(
    [qiskit-service]=data
    [backend]=app/data
    [qhana-plugin-runner]=app/instance
)

declare -a containers=(
    redis
    postgres
    nisq-analyzer-db
)

export() {
    mkdir -p Backup
    rm -rf Backup/*

    for container in "${!to_store[@]}"
    do
        docker run --rm \
            --volumes-from qhana-docker-dev-${container}-1 \
            -v $(pwd)/Backup:/backup \
            ubuntu tar cfz /backup/${container}.tar.gz ${to_store[$container]}
    done
    
    for container in "${containers[@]}"
    do
        docker commit qhana-docker-dev-${container}-1 ${container}:demo
        docker save ${container}:demo | gzip > Backup/${container}-demo-image.tar.gz
    done
}

import() {
    for container in "${!to_store[@]}"
    do
        docker run --rm \
            --volumes-from qhana-docker-dev-${container}-1 \
            -v $(pwd)/Backup:/backup \
            ubuntu bash -c "tar xfz /backup/${container}.tar.gz"
    done
    
    for container in "${containers[@]}"
    do
        docker load < Backup/${container}-demo-image.tar.gz
    done
}

$1
