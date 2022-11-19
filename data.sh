#!/bin/bash

declare -A to_store=(
    [qiskit-service]=data
    [backend]=app/data
    [qhana-plugin-runner]=app/instance
)

declare -a containers=(
    redis
    postgres
)

export() {
    mkdir -p Backup
    rm -rf Backup/*

    for container_name in "${!to_store[@]}"
    do
        docker run --rm \
            --volumes-from qhana-docker-dev-${container_name}-1 \
            -v $(pwd)/Backup:/backup \
            ubuntu tar cfz /backup/${container_name}.tar.gz ${to_store[$container_name]}
    done
    
    for container in "${containers}"
    do
        docker export -o Backup/${container}.tar qhana-docker-dev-${container}-1
    done
}

import() {
    for container_name in "${!to_store[@]}"
    do
        docker run --rm \
            --volumes-from qhana-docker-dev-${container_name}-1 \
            -v $(pwd)/Backup:/backup \
            ubuntu bash -c "tar xfz /backup/${container_name}.tar.gz"
    done
    
    for container in "${containers}"
    do
        docker import Backup/${container}.tar
    done
}

$1
