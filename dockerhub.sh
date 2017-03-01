#!/bin/bash

# Make sure we're in the projects root directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"
cd "$DIR"

DOCKERHUB_USER="mendlik"
SCRIPT_NAME="dockerhub.sh"

function help() {
  echo "NAME"
  echo "  $SCRIPT_NAME - Docker hub script."
  echo "  Source: https://github.com/mendlik/docker-images"
  echo ""
  echo "SYNOPSIS"
  echo "  ./dockerhub.sh IMAGE COMMAND"
  echo "IMAGE"
  echo "  Image name to act on. Available:\n  $(ls)"
  echo "  Available:"
  echo "  $(ls)"
  echo "COMMAND"
  echo "  Command to execute on a docker image."
  echo "  build       Build the image"
  echo "  tags        List image tags from dockerhub"
  echo "  push VERSION    Push image to the dockerhub with given version"
  echo "  release VERSION   Like 'push' but marks as latest"
  echo ""
}

function error() {
  local -r MSG="${1:-Could not execute script.}"
  echo ""
  echo -e "Error: $MSG"
  echo -e "  Try: $SCRIPT_NAME help"
  exit 1;
}

function images() {
  find . -maxdepth 1 -mindepth 1 -type d | grep '^\./[^.]' | sed 's|^./||g'
}

if [ "$1" == "help" ] || [ "$1" == "-h" ]; then
  help
  exit 1;
fi

showTags() {
  local -r REPO="$1"
  curl -k "https://registry.hub.docker.com/v1/repositories/$DOCKERHUB_USER/$REPO/tags" | jq -r '.[].name'
}

dirtyStatus() {
  git status --porcelain 2>/dev/null | wc -l
}

validateVersion() {
  local -r VERSION="$1"
  [ -z "$VERSION" ] && error "Specify version number."
  [[ $VERSION =~ ^[0-9]+\.[0-9]\.[0-9]$ ]] || error "Use semantic version. Example: 1.2.3"
  [ "$(dirtyStatus)" -gt 0 ] && error "Version is not valid unless you commit your changes."
  echo "$VERSION"
}

build() {
  local -r IMAGE="$1"
  local -r VERSION="${2:-undefined}"
  local -r BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local -r VCS_URL=$(git config --get remote.origin.url || echo 'undefined')
  local -r VCS_REF_PREFIX=$(git rev-parse --short HEAD || echo 'undefined')
  local -r VCS_REF_SUFFIX=$([ $(dirtyStatus) -gt 0 ] && echo "-dirty")
  local -r VCS_REF="$VCS_REF_PREFIX$VCS_REF_SUFFIX"
  echo "> Docker build: $IMAGE"
  echo "  IMAGE:    $IMAGE"
  echo "  DATE:     $BUILD_DATE"
  echo "  VERSION:  $VERSION"
  echo "  VCS_URL:  $VCS_URL"
  echo "  VCS_REF:  $VCS_REF"
  docker build \
    --build-arg BUILD_DATE=$BUILD_DATE \
    --build-arg VERSION=$VERSION \
    --build-arg VCS_URL=$VCS_URL \
    --build-arg VCS_REF=$VCS_REF \
    -t $IMAGE .
  [ "$VERSION" != "undefined" ] && \
    docker tag $IMAGE "$IMAGE:$VERSION" && \
    echo "> Tagged: $IMAGE:$VERSION"
}

push() {
  local -r IMAGE="$1"
  local -r VERSION="$2"
  local -r DOCKERHUB_IMAGE="$DOCKERHUB_USER/$IMAGE:$VERSION"
  validateVersion $VERSION
  build $IMAGE $VERSION
  echo "Docker push: $DOCKERHUB_IMAGE"
  docker tag $IMAGE $DOCKERHUB_IMAGE && \
    echo "> Tagged: $IMAGE:$VERSION"
  docker push $DOCKERHUB_IMAGE && \
    echo "> Pushed: $DOCKERHUB_IMAGE"
  git tag "$IMAGE-$VERSION" && git push --tags && \
    echo "> Pushed git tag: $IMAGE-$VERSION"
}

release() {
  local -r IMAGE="$1"
  local -r VERSION="$2"
  local -r DOCKERHUB_IMAGE="$DOCKERHUB_USER/$IMAGE:latest"
  push $IMAGE $VERSION
  echo "Docker release: $DOCKERHUB_IMAGE"
  docker tag $IMAGE $DOCKERHUB_IMAGE && \
    echo "> Tagged: $IMAGE:$VERSION"
  docker push $DOCKERHUB_IMAGE && \
    echo "> Pushed: $DOCKERHUB_IMAGE"
}

IMAGE="$1"
COMMAND="$2"
VERSION="$3"

[ -z "$COMMAND" ] || [ -z "$IMAGE" ] && \
  error "Missing arguments.\nIMAGE: '$IMAGE' COMMAND: '$COMMAND'"
[ ! -d "$IMAGE" ] && \
  error "Image not found: '$IMAGE'.\nAvailable images:\n$(images)"

cd $IMAGE
echo "Using: $PWD"

case $COMMAND in
  tags)
    tags $IMAGE;
    ;;
  build)
    build $IMAGE $VERSION;
    ;;
  push)
    push $IMAGE $VERSION;
    ;;
  release)
    release $IMAGE $VERSION;
    ;;
  *)
    error "Unknown command: $COMMAND"
    ;;
esac
