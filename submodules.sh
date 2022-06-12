#!/bin/bash

help() {
    echo "Usage: $0 BRANCH [BRANCH]"
    echo
    echo "Specify one or two branch names"
    echo " - One:   Check out this branch in qhana-ui and qhana-plugin-runner"
    echo " - Two:   Check out the first branch in qhana-ui and the second in qhana-plugin-runner"
    echo

    exit 2
}

[ "$#" -eq 0 ] && help
[ "$#" -eq 1 ] && UI_BRANCH="$1" && PR_BRANCH="$1"
[ "$#" -eq 2 ] && UI_BRANCH="$1" && PR_BRANCH="$2"
[ "$#" -gt 2 ] && help

cd qhana-ui
git checkout "${UI_BRANCH}"
[ "$?" -gt 0 ] && exit $?
cd -

cd qhana-plugin-runner
git checkout "${PR_BRANCH}"
[ "$?" -gt 0 ] && exit $?
cd -
