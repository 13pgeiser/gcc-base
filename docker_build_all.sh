#!/bin/bash
set -e
source docker_build_helper.sh

prepare_container jammy

BUILD="$(gcc -dumpmachine)"
for TARGET in "riscv32-unknown-elf" "m68k-elf"; do
	for HOST in "$(gcc -dumpmachine)" ; do
		if [ "$TARGET" == "$BUILD" ] && [ "$HOST" != "$TARGET" ]; then
			echo "Skipping $HOST -> $TARGET"
			continue
		fi
		echo "$HOST -> $TARGET"
		docker exec -i gcc_multilib bash /scripts/build.sh "$HOST" "$TARGET"
	done
done

cleanup_container

exit 0
