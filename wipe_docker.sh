#!/bin/bash

CONTAINERS="$(docker ps -qa)"
[ -n "$CONTAINERS" ] && docker stop $CONTAINERS
[ -n "$CONTAINERS" ] && docker rm --force $CONTAINERS

IMAGES="$(docker image ls -qa)"
[ -n "$IMAGES" ] && docker rmi --force $IMAGES

VOLUMES="$(docker volume ls -q)"
[ -n "$VOLUMES" ] && docker volume rm --force $VOLUMES
