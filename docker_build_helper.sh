#!/bin/bash
set -e

# Current script folder
SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

function prepare_container() {
	docker rm -f gcc_multilib || true
	cat "$SCRIPT_DIR/scripts/Dockerfile.$1" "$SCRIPT_DIR/scripts/Dockerfile.base" | docker build -t gcc_multilib -
	docker run -d --name gcc_multilib gcc_multilib sleep 86400 # 24 hours...
	docker cp "$SCRIPT_DIR/patches" gcc_multilib:/patches
	docker cp "$SCRIPT_DIR/scripts" gcc_multilib:/scripts
	docker cp "$SCRIPT_DIR/test" gcc_multilib:/test
}

function cleanup_container() {
	docker cp gcc_multilib:/release ./
	docker rm -f gcc_multilib || true
	docker system prune -f -a
}
