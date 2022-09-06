#!/bin/bash

SUBMODULES=$(git submodule | sed -E 's/^\S*\s(\S*)\s\S*$/\1/')

for SUB in $SUBMODULES; do
	cd "$SUB"

	echo "$SUB"
	git fetch
	git pull
	git status
	echo

	cd -
done

