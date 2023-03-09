#!/bin/sh

set -eu

usage() {
    echo "build.sh: Builds a docker image. Requires docker and git"
    echo "Usage: ./build.sh [OPTIONS]"
    echo 'Options:'
    echo "  -f|--env-file           Path to env file. Default: ./.env"
    echo "  -h|--help               Help"
    echo "Environment variables:"
    echo "  PIPELINE                Build pipeline"
    echo "                          Type: string"
    echo "                          Possible values: 'build', 'update'"
    echo "  GAME_UPDATE_COUNT       Game update count (docker label). Applies only to PIPELINE=update"
    echo "                          Type: int"
    echo "  GAME_VERSION            Game version. For example, to get the latest CS:GO version:"
    echo "                            wget -qO- 'https://api.steampowered.com/ISteamApps/UpToDateCheck/v1?appid=730&version=0' | jq '.response.required_version'"
    echo "                          Type: int"
    echo "  APPID                   AppID. See: https://developer.valvesoftware.com/wiki/Steam_Application_IDs"
    echo "                          Type: int"
    echo "  CLIENT_APPID            Client AppID. See: https://developer.valvesoftware.com/wiki/Steam_Application_IDs"
    echo "                          Type: int"
    echo "  GAME                    Game"
    echo "                          Type: string"
    echo "  MOD                     Mod. Needed when APPID=90, except for APPID=90 GAME=valve"
    echo "                          Type: string, optional"
    echo "  FIX_APPMANIFEST         Whether to fix appmanifests."
    echo "                          Type: bool, optional"
    echo "                          Possible values: 'true', 'false'"
    echo "  LATEST                  Whether to tag docker image as :latest. Applies only to PIPELINE=build"
    echo "                          Type: bool, optional"
    echo "                          Possible values: 'true', 'false'"
    echo "  CACHE                   Whether to pull the :latest image before running build"
    echo "                          Type: bool, optional"
    echo "                          Possible values: 'true', 'false'"
    echo "  NO_PULL                 Whether to skip pulling :latest image before building. Applies only to PIPELINE=update"
    echo "                          Type: bool, optional"
    echo "                          Possible values: 'true', 'false'"
    echo "  NO_TEST                 Whether to skip testing the game image after a successful build"
    echo "                          Type: bool, optional"
    echo "                          Possible values: 'true', 'false'"
    echo "  NO_PUSH                 Whether to skip pushing the docker image after a successful build"
    echo "                          Type: bool, optional"
    echo "                          Possible values: 'true', 'false'"
    echo "  DOCKER_REPOSITORY       Docker repository"
    echo "                          Type: string"
    echo "  REGISTRY_USER           Docker registry user"
    echo "                          Type: string"
    echo "  REGISTRY_PASSWORD       Docker registry password"
    echo "                          Type: string"
    echo "  STEAM_LOGIN             Whether to logon to Steam so that games download without rate limiting. Generally needed when APPID=90"
    echo "                          Type: bool, optional"
    echo "  STEAM_USERNAME          Steam username"
    echo "                          Type: string"
    echo "  STEAM_PASSWORD          Steam password"
    echo "                          Type: string"
    echo "Examples:"
    echo "  # Build hlds/cstrike image and push"
    echo "  PIPELINE=build GAME_VERSION=1127 APPID=90 CLIENT_APPID=10 GAME=cstrike MOD=cstrike FIX_APPMANIFEST=true LATEST=true STEAM_LOGIN=true DOCKER_REPOSITORY=docker.io/mynamespace/cstrike REGISTRY_USER=xxx REGISTRY_PASSWORD=xxx STEAM_USERNAME=xxx STEAM_PASSWORD=xxx ./build.sh"
    echo
    echo "  # Update hlds/cstrike image and push"
    echo "  PIPELINE=update GAME_UPDATE_COUNT=1 GAME_VERSION=1128 APPID=90 CLIENT_APPID=10 GAME=cstrike MOD=cstrike FIX_APPMANIFEST=true STEAM_LOGIN=true DOCKER_REPOSITORY=docker.io/mynamespace/cstrike REGISTRY_USER=xxx REGISTRY_PASSWORD=xxx STEAM_USERNAME=xxx STEAM_PASSWORD=xxx ./build.sh"
    echo
    echo "  # Build hlds/valve image and push"
    echo "  PIPELINE=build GAME_VERSION=1122 APPID=90 CLIENT_APPID=10 GAME=valve MOD= FIX_APPMANIFEST=true LATEST=true STEAM_LOGIN=true DOCKER_REPOSITORY=docker.io/mynamespace/valve REGISTRY_USER=xxx REGISTRY_PASSWORD=xxx STEAM_USERNAME=xxx STEAM_PASSWORD=xxx ./build.sh"
    echo
    echo "  # Update hlds/valve image and push"
    echo "  PIPELINE=update GAME_UPDATE_COUNT=1 GAME_VERSION=1123 APPID=90 CLIENT_APPID=10 GAME=valve MOD= FIX_APPMANIFEST=true STEAM_LOGIN=true DOCKER_REPOSITORY=docker.io/mynamespace/valve REGISTRY_USER=xxx REGISTRY_PASSWORD=xxx STEAM_USERNAME=xxx STEAM_PASSWORD=xxx ./build.sh"
    echo
    echo "  # Build srcds/csgo image and push"
    echo "  PIPELINE=build GAME_VERSION=13840 APPID=740 CLIENT_APPID=730 GAME=csgo LATEST=true DOCKER_REPOSITORY=docker.io/mynamespace/csgo REGISTRY_USER=xxx REGISTRY_PASSWORD=xxx ./build.sh"
    echo
    echo "  # Update srcds/csgo image and push"
    echo "  PIPELINE=update GAME_UPDATE_COUNT=1 GAME_VERSION=13841 APPID=740 CLIENT_APPID=730 GAME=csgo DOCKER_REPOSITORY=docker.io/mynamespace/csgo REGISTRY_USER=xxx REGISTRY_PASSWORD=xxx ./build.sh"
    echo
    echo "  # Build using an .env file in the same directory as build.sh"
    echo "  ./build.sh"
    echo
    echo "  # Build using a custom .env file in the same directory as build.sh"
    echo "  ./build.sh --env-file path/to/.env"
    echo
}

# Get some options
while test $# -gt 0; do
    case "$1" in
        -f|--env-file)
            shift
            ENV_FILE=$1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Invalid option '$1'" 1>&2
            usage
            exit 1
            ;;
    esac
done

ENV_FILE=${ENV_FILE:-.env}
if [ -f "$ENV_FILE" ]; then
    ENV_FILE="$( cd "$( dirname "$ENV_FILE" )" && pwd )/$( basename "$ENV_FILE" )"
    echo "Reading env file $ENV_FILE"
    . "$ENV_FILE"
fi

# Process job variables
PIPELINE=${PIPELINE:?err}
if [ "$PIPELINE" = 'build' ]; then
    GAME_VERSION=${GAME_VERSION:?err}
    APPID=${APPID:?err}
    CLIENT_APPID=${CLIENT_APPID:?err}
    GAME=${GAME:?err}
    MOD=${MOD:-}
    FIX_APPMANIFEST=${FIX_APPMANIFEST:-}
    LATEST=${LATEST:-}
    CACHE=${CACHE:-}
    NO_TEST=${NO_TEST:-}
    NO_PUSH=${NO_PUSH:-}
    STEAM_LOGIN=${STEAM_LOGIN:-}
elif [ "$PIPELINE" = 'update' ]; then
    GAME_VERSION=${GAME_VERSION:?err}
    APPID=${APPID:?err}
    GAME=${GAME:?err}
    GAME_UPDATE_COUNT=${GAME_UPDATE_COUNT:?err}
    NO_PULL=${NO_PULL:-}
    NO_TEST=${NO_TEST:-}
    NO_PUSH=${NO_PUSH:-}
    STEAM_LOGIN=${STEAM_LOGIN:-}
fi

# Process user variables
DOCKER_REPOSITORY=${DOCKER_REPOSITORY:-}
if [ ! "$NO_PUSH" = 'true' ]; then
    REGISTRY_USER=${REGISTRY_USER:?err}
    REGISTRY_PASSWORD=${REGISTRY_PASSWORD:?err}
else
    REGISTRY_USER=${REGISTRY_USER:-}
    REGISTRY_PASSWORD=${REGISTRY_PASSWORD:-}
fi
if [ "$STEAM_LOGIN" = 'true' ]; then
    STEAM_USERNAME=${STEAM_USERNAME:?err}
    STEAM_PASSWORD=${STEAM_PASSWORD:?err}
else
    STEAM_USERNAME=${STEAM_USERNAME:-}
    STEAM_PASSWORD=${STEAM_PASSWORD:-}
fi

# Process default job variables
export DOCKER_BUILDKIT=1
if [ "$APPID" = 90 ]; then
    DOCKER_REPOSITORY="${DOCKER_REPOSITORY:-${REGISTRY_GOLDSOURCE:?err}/$GAME}"
    GAME_ENGINE='hlds'
    GAME_BIN='hlds_linux'
else
    DOCKER_REPOSITORY="${DOCKER_REPOSITORY:-${REGISTRY_SOURCE:?err}/$GAME}"
    GAME_ENGINE='srcds'
    GAME_BIN='srcds_linux'
fi
if [ "$PIPELINE" = 'build' ]; then
    GAME_IMAGE_CLEAN="$DOCKER_REPOSITORY:$GAME_VERSION"
    BUILD_CONTEXT='build/'
elif [ "$PIPELINE" = 'update' ]; then
    GAME_IMAGE_LAYERED="$DOCKER_REPOSITORY:$GAME_VERSION-layered"
    BUILD_CONTEXT='update/'
else
    echo "Invalid PIPELINE '$PIPELINE'"
    exit 1
fi
GAME_IMAGE_LATEST="$DOCKER_REPOSITORY:latest"
COMMIT_SHA=$( git rev-parse HEAD )

# Display pipeline
echo "PIPELINE: $PIPELINE"

# Display system info
(
    hostname
    whoami
    cat /etc/*release
    lscpu
    free
    df -h
    pwd
    docker info
    docker version
) || true

# Docker registry login
if [ ! "$NO_PUSH" = 'true' ]; then
    echo "$REGISTRY_PASSWORD" | docker login -u "$REGISTRY_USER" --password-stdin
fi

# Build / Update the game image
if [ "$PIPELINE" = 'build' ]; then
    GAME_IMAGE="$GAME_IMAGE_CLEAN"
    if [ "$CACHE" = 'true' ]; then
        date
        time docker pull "$GAME_IMAGE" || true
    fi
    date
    STEAM_USERNAME="$STEAM_USERNAME" STEAM_PASSWORD="$STEAM_PASSWORD" time docker build \
        --progress plain \
        --secret id=STEAM_USERNAME,env=STEAM_USERNAME \
        --secret id=STEAM_PASSWORD,env=STEAM_PASSWORD \
        --build-arg APPID="$APPID" \
        --build-arg MOD="$MOD" \
        --build-arg FIX_APPMANIFEST="$FIX_APPMANIFEST" \
        --build-arg CLIENT_APPID="$CLIENT_APPID" \
        --build-arg STEAM_LOGIN="$STEAM_LOGIN" \
        --build-arg CACHE_KEY="$GAME_VERSION" \
        -t "$GAME_IMAGE" \
        --label "appid=$APPID" \
        --label "mod=$MOD" \
        --label "client_appid=$CLIENT_APPID" \
        --label "game=$GAME" \
        --label "game_version=$GAME_VERSION" \
        --label "game_version_base=$GAME_VERSION" \
        --label 'game_update_count=0' \
        --label "game_engine=$GAME_ENGINE" \
        --label "commit_sha=$COMMIT_SHA" \
        "$BUILD_CONTEXT"
    if [ "$LATEST" = 'true' ]; then
        docker tag "$GAME_IMAGE" "$GAME_IMAGE_LATEST"
    fi
    date
elif [ "$PIPELINE" = 'update' ]; then
    GAME_IMAGE="$GAME_IMAGE_LAYERED"
    date
    if [ ! "$NO_PULL" = 'true' ]; then
        time docker pull "$GAME_IMAGE_LATEST"
    fi
    date
    STEAM_USERNAME="$STEAM_USERNAME" STEAM_PASSWORD="$STEAM_PASSWORD" time docker build \
        --progress plain \
        --secret id=STEAM_USERNAME,env=STEAM_USERNAME \
        --secret id=STEAM_PASSWORD,env=STEAM_PASSWORD \
        --build-arg GAME_IMAGE="$GAME_IMAGE_LATEST" \
        --build-arg STEAM_LOGIN="$STEAM_LOGIN" \
        --build-arg CACHE_KEY="$GAME_VERSION" \
        -t "$GAME_IMAGE" \
        -t "$GAME_IMAGE_LATEST" \
        --label "game_version=$GAME_VERSION" \
        --label "game_update_count=$GAME_UPDATE_COUNT" \
        --label "commit_sha=$COMMIT_SHA" \
        "$BUILD_CONTEXT"
    date
fi
docker images
docker inspect "$GAME_IMAGE"
docker history "$GAME_IMAGE"

# Test the game image
if [ ! "$NO_TEST" = 'true' ]; then
    TEST_DIR=$( mktemp -d )

    echo "Testing image"
    date
    time docker run -t --rm "$GAME_IMAGE" 'printenv && ls -al'
    date
    time docker run -t --rm "$GAME_IMAGE" "$GAME_BIN -game $GAME +version +exit" | tee "$TEST_DIR/test"
    date

    # Verify game version of the game image matches the value of GAME_VERSION
    echo 'Verifying game image game version'
    GAME_IMAGE_VERSION_LINES=$( cat "$TEST_DIR/test" | grep -iE '\bexe\b|version' | sed 's/[^0-9]//g' )
    if ! echo "$GAME_IMAGE_VERSION_LINES" | grep -E "^$GAME_VERSION" > /dev/null; then
        echo "Game version does not match GAME_VERSION=$GAME_VERSION"
        echo 'GAME_IMAGE_VERSION_LINES:'
        echo "$GAME_IMAGE_VERSION_LINES"
        exit 1
    fi
    rm -f "$TEST_DIR/test"
fi

# Push the game image
if [ ! "$NO_PUSH" = 'true' ]; then
    date
    time docker push "$GAME_IMAGE"
    if [ "$PIPELINE" = 'build' ]; then
        if [ "$LATEST" = 'true' ]; then
            time docker push "$GAME_IMAGE_LATEST"
        fi
    elif [ "$PIPELINE" = 'update' ]; then
        time docker push "$GAME_IMAGE_LATEST"
    fi
    date
fi

# Docker registry logout
if [ ! "$NO_PUSH" = 'true' ]; then
    docker logout
fi

# Create .build.state artifact
echo "Creating .build.state artifact"
# Searching for 'WORKDIR /server' is a reliable way to locate the base image layers
BASE_SIZE=0; for i in $( docker history "$DOCKER_REPOSITORY:latest" --format='{{.Size}} {{.CreatedAt}} {{.CreatedBy}}' --no-trunc --human=false | grep 'WORKDIR /server' -A99999 | awk '{print $1}' ); do BASE_SIZE=$(( $BASE_SIZE + $i )); done
# Searching for 'UPDATE' is a reliable way to determine the incremental image layers
LAYERS_SIZE=0; for i in $( docker history "$DOCKER_REPOSITORY:latest" --format='{{.Size}} {{.CreatedAt}} {{.CreatedBy}}' --no-trunc --human=false | grep UPDATE | awk '{print $1}' ); do LAYERS_SIZE=$(( $LAYERS_SIZE + $i )); done
LAYERED_SIZE=$(( $BASE_SIZE + $LAYERS_SIZE ))
cat - > .build.state <<EOF
BASE_SIZE=$BASE_SIZE
LAYERED_SIZE=$LAYERED_SIZE
DIFF=$LAYERS_SIZE
EOF
cat .build.state
ls -al .build.state
