#!/bin/bash

SUBMODULES=$(git submodule | awk '{print $2}')

for SUB in $SUBMODULES; do
	cd "$SUB"

	echo "$SUB"
	git fetch
	git pull
	git status
	echo

	cd -
done

