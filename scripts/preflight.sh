#!/usr/bin/env bash

set -u

readonly MIN_KVER="6.17.9"
KVER="${1:-$(uname -r)}"
failed=0

for tool in b4 git make; do
	if ! command -v "$tool" >/dev/null 2>&1; then
		printf 'Missing required tool: %s\n' "$tool"
		failed=1
	fi
done

if [[ ! -d "/lib/modules/$KVER/build" ]]; then
	printf 'Missing kernel build directory: /lib/modules/%s/build\n' "$KVER"
	failed=1
fi

version_at_least() {
	local version="$1"
	local minimum="$2"
	local version_major version_minor version_patch
	local minimum_major minimum_minor minimum_patch

	if [[ ! "$version" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
		return 1
	fi
	version_major="${BASH_REMATCH[1]}"
	version_minor="${BASH_REMATCH[2]}"
	version_patch="${BASH_REMATCH[3]}"

	[[ "$minimum" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]
	minimum_major="${BASH_REMATCH[1]}"
	minimum_minor="${BASH_REMATCH[2]}"
	minimum_patch="${BASH_REMATCH[3]}"

	(( 10#$version_major > 10#$minimum_major )) ||
		(( 10#$version_major == 10#$minimum_major && 10#$version_minor > 10#$minimum_minor )) ||
		(( 10#$version_major == 10#$minimum_major && 10#$version_minor == 10#$minimum_minor && 10#$version_patch >= 10#$minimum_patch ))
}

if ! version_at_least "$KVER" "$MIN_KVER"; then
	printf 'Kernel %s is too old; the ISP4 patchset requires %s or newer.\n' "$KVER" "$MIN_KVER"
	failed=1
fi

if (( failed )); then
	printf 'Preflight failed: fix the requirements above before running setup.\n'
	exit 1
fi

printf 'Preflight passed: this machine is ready to build the AMD ISP4 driver.\n'
