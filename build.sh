#!/bin/bash -x
set -o pipefail
SOFTWARE="trimmomatic"

REGISTRY="ghcr.io/martinluttap"
BRANCH="${BRANCH-}"
BUILD_ROOT_DIR=$(pwd)
GIT_SHORT_HASH=$(git rev-parse --short HEAD)

set -e
for directory in *; do
	if [ -d "${directory}" ]; then
	    # Ignore directories without a justfile
		if [ ! -f "${directory}"/justfile ]; then
			cd "$BUILD_ROOT_DIR"
			continue
		fi

		cd "${directory}"

		echo "Building ${directory} ..."
		# Build version image, tagging as build-<software>:<version>

		# Allow per-version Dockerfile
		DOCKERFILE=$(just emit-dockerfile)
		SHORT_TAG="${REGISTRY}/${SOFTWARE}:${directory}"
		BUILD_TAG="${REGISTRY}/${SOFTWARE}:${directory}-${GIT_SHORT_HASH}"
		docker buildx build --compress --progress plain \
  			-t "${BUILD_TAG}" \
			-t "${SHORT_TAG}" \
  			-f "${DOCKERFILE}" \
  			. \
  			--build-arg VERSION="${directory}"
		
		cd ..
	fi
done

echo "Successfully built all containers!"