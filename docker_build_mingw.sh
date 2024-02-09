#!/bin/bash
set -e
source docker_build_helper.sh

prepare_container buster

BUILD="$(gcc -dumpmachine)"
TARGET="x86_64-w64-mingw32"
for HOST in "$BUILD" "$TARGET"; do
	docker exec -i gcc_multilib bash /scripts/build.sh "$HOST" "$TARGET"
done

cleanup_container

exit 0
