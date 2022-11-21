#!/bin/bash

declare -a volumes=(
    instance
    experiments
    exec_data
)

export() {
    rm -rf Backup
    mkdir -p Backup

    cp -r "${HOME}/Volumes" Backup
}

import() {
    sudo rm -rf "${HOME}/Volumes"

    cp -r Backup/Volumes "${HOME}"
}

$1
