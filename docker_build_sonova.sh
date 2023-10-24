#!/bin/bash
set -e
source docker_build_helper.sh

prepare_container

BUILD="$(gcc -dumpmachine)"
for TARGET in "x86_64-w64-mingw32" "arc-elf" "arm-none-eabi" "$BUILD"; do
	for HOST in "$BUILD" "x86_64-w64-mingw32"; do
		if [ "$TARGET" == "$BUILD" ] && [ "$HOST" != "$TARGET" ]; then
			echo "Skipping $HOST -> $TARGET"
			continue
		fi
		echo "$HOST -> $TARGET"
		docker exec -e WRK_DIR=/home/shannon/_tools -i gcc_multilib bash /scripts/build.sh "$HOST" "$TARGET"
		docker cp gcc_multilib:/release ./
	done
done

cleanup_container

exit 0
