#!/bin/bash

declare -A to_store=(
    [qiskit-service]=data
    [backend]=app/data
    [qhana-plugin-runner]=app/instance
)

# docker run --rm --volumes-from qhana-docker-dev-qiskit-service-1 -v $(pwd)/Backup:/backup ubuntu cp data/app.db backup

export() {
    for container_name in "${!to_store[@]}"
    do
        docker run --rm \
            --volumes-from qhana-docker-dev-${container_name}-1 \
            -v $(pwd)/Backup:/backup \
            ubuntu tar cfz /backup/${container_name}.tar.gz ${to_store[$container_name]}
    done
}

export
