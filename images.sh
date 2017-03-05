#!/bin/bash

# Make sure we're in the projects root directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"
cd "$DIR"

SCRIPT_NAME="images.sh"
DOCKERHUB_USERNAME="mendlik"

function help() {
  echo "NAME"
  echo "  $SCRIPT_NAME - Docker script."
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
  echo "  build             Build the image using hooks/build"
  echo "  tags              List image tags from dockerhub"
  echo "  release VERSION   Release new version"
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

tags() {
  local -r REPO="$1"
  echo "Dockerhub tags:"
  curl -sk "https://registry.hub.docker.com/v1/repositories/$DOCKERHUB_USERNAME/$REPO/tags" | jq -r '.[].name'
  echo ""
  echo "See: https://hub.docker.com/r/$DOCKERHUB_USERNAME/$REPO/tags"
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
  IMAGE="$1" VERSION="${2:-undefined}" ./hooks/build
}

release() {
  local -r IMAGE="$1"
  local -r VERSION="$2"
  local -r TAG="$IMAGE-$VERSION"
  validateVersion $VERSION
  git tag $TAG && git push --tags && \
    echo "Pushed git tag: $TAG" && \
    echo "See: https://hub.docker.com/r/$DOCKERHUB_USERNAME/$IMAGE/~/settings/automated-builds/"
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
  release)
    release $IMAGE $VERSION;
    ;;
  *)
    error "Unknown command: $COMMAND"
    ;;
esac
