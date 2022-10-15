#!/bin/sh

#################################  CI variables  #################################
# Use this section for local builds.
# All variables regardless of type will be processed as strings in builds.
# Types specified in comments but serve to aid users in populating said variables.
##################################################################################

## User variables ##
# REGISTRY_USER=          # string - docker hub username - required
# REGISTRY_PASSWORD=      # string - docker hub password or api key - required
# REGISTRY_GOLDSOURCE=    # string - docker hub username or organization for goldsource games - required
# REGISTRY_SOURCE=        # string - docker hub username or organization for source games - required
# STEAM_USERNAME=         # string - steam username - optional
# STEAM_PASSWORD=         # string - steam password - optional

## Job variables ##
# PIPELINE=               # string - 'build' for clean builds, 'update' for layered builds - required

## build variables ##
# GAME_VERSION=           # int - required
# APPID=                  # int - required
# CLIENT_APPID=           # int - required
# GAME=                   # string - required
# MOD=                    # string - required for APPID=90
# FIX_APPMANIFEST=true    # bool - only applicable to but optional for APPID=90
# LATEST=true             # bool - optional
# CACHE=false             # bool - optional
# NO_TEST=false           # bool - optional
# NO_PUSH=false           # bool - optional
# STEAM_LOGIN=false       # bool - optional

## update variables ##
# GAME_VERSION=           # int - required
# APPID=                  # int - required
# GAME=                   # string - required
# GAME_UPDATE_COUNT=      # int - required
# NO_TEST=false           # bool - optional
# NO_PUSH=false           # bool - optional
# STEAM_LOGIN=false       # bool - optional

#############################  End of CI variables  ##############################

# Process user variables
REGISTRY_USER=${REGISTRY_USER:?err}
REGISTRY_PASSWORD=${REGISTRY_PASSWORD:?err}
REGISTRY_GOLDSOURCE=${REGISTRY_GOLDSOURCE:?err}
REGISTRY_SOURCE=${REGISTRY_SOURCE:?err}

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
    NO_TEST=${NO_TEST:-}
    NO_PUSH=${NO_PUSH:-}
    STEAM_LOGIN=${STEAM_LOGIN:-}
fi
if [ "$STEAM_LOGIN" = 'true' ]; then
    export STEAM_USERNAME=${STEAM_USERNAME:?err}
    export STEAM_PASSWORD=${STEAM_PASSWORD:?err}
else
    export STEAM_USERNAME=${STEAM_USERNAME:-}
    export STEAM_PASSWORD=${STEAM_PASSWORD:-}
fi

# Process default job variables
export DOCKER_BUILDKIT=1
if [ "$PIPELINE" = 'build' ]; then
    DOCKER_BUILD_CONTEXT='build/'
elif [ "$PIPELINE" = 'update' ]; then
    DOCKER_BUILD_CONTEXT='update/'
fi
if [ "$APPID" = 90 ]; then
    REPOSITORY="$REGISTRY_GOLDSOURCE/$GAME"
    GAME_ENGINE='hlds'
    GAME_BIN='hlds_linux'
else
    REPOSITORY="$REGISTRY_SOURCE/$GAME"
    GAME_ENGINE='srcds'
    GAME_BIN='srcds_linux'
fi

# Display pipeline
echo "PIPELINE: $PIPELINE"

# Display system info
hostname
whoami
cat /etc/*release
lscpu
free
df -h
pwd
docker info
docker version

# Terminate the build on errors
set -e

# Docker registry login
if [ ! "$NO_PUSH" = 'true' ]; then
    echo "$REGISTRY_PASSWORD" | docker login -u "$REGISTRY_USER" --password-stdin
fi

# Build / Update the game image
if [ "$PIPELINE" = 'build' ]; then
    GAME_IMAGE="$REPOSITORY:$GAME_VERSION"
    if [ "$CACHE" = 'true' ]; then
        date
        time docker pull "$GAME_IMAGE" || true
    fi
    date
    time docker build \
        --cache-from "$GAME_IMAGE" \
        --secret id=STEAM_USERNAME,env=STEAM_USERNAME \
        --secret id=STEAM_PASSWORD,env=STEAM_PASSWORD \
        --build-arg APPID="$APPID" \
        --build-arg MOD="$MOD" \
        --build-arg FIX_APPMANIFEST="$FIX_APPMANIFEST" \
        --build-arg CLIENT_APPID="$CLIENT_APPID" \
        --build-arg STEAM_LOGIN="$STEAM_LOGIN" \
        -t "$GAME_IMAGE" \
        --label "appid=$APPID" \
        --label "mod=$MOD" \
        --label "client_appid=$CLIENT_APPID" \
        --label "game=$GAME" \
        --label "game_version=$GAME_VERSION" \
        --label 'game_update_count=0' \
        --label "game_engine=$GAME_ENGINE" \
        "$DOCKER_BUILD_CONTEXT"
    if [ "$LATEST" = 'true' ]; then
        docker tag "$GAME_IMAGE" "$REPOSITORY:latest"
    fi
    date
elif [ "$PIPELINE" = 'update' ]; then
    GAME_IMAGE="$REPOSITORY:latest"
    date
    time docker pull "$GAME_IMAGE"
    date
    time docker build \
        --secret id=STEAM_USERNAME,env=STEAM_USERNAME \
        --secret id=STEAM_PASSWORD,env=STEAM_PASSWORD \
        --build-arg GAME_IMAGE="$GAME_IMAGE" \
        --build-arg STEAM_LOGIN="$STEAM_LOGIN" \
        -t "$GAME_IMAGE" \
        --label "game_version=$GAME_VERSION" \
        --label "game_update_count=$GAME_UPDATE_COUNT" \
        "$DOCKER_BUILD_CONTEXT"
    docker tag "$GAME_IMAGE" "$REPOSITORY:$GAME_VERSION-layered"
    date
fi
docker images
docker inspect "$GAME_IMAGE"
docker history "$GAME_IMAGE"

# Test the game image
if [ ! "$NO_TEST" = 'true' ]; then
    date
    time docker run -t --rm "$GAME_IMAGE" 'printenv && ls -al'
    date
    time docker run -t --rm "$GAME_IMAGE" "$GAME_BIN -game $GAME +version +exit" | tee /tmp/test
    date
fi
# Verify game version of the game image matches the value of GAME_VERSION
echo 'Verifying game image game version'
GAME_IMAGE_VERSION_LINES=$( cat /tmp/test | grep -iE '\bexe\b|version' | sed 's/[^0-9]//g' )
if ! echo "$GAME_IMAGE_VERSION_LINES" | grep -E "^$GAME_VERSION" > /dev/null; then
    echo "Game version does not match GAME_VERSION=$GAME_VERSION"
    echo 'GAME_IMAGE_VERSION_LINES:'
    echo "$GAME_IMAGE_VERSION_LINES"
    exit 1
fi
rm -f /tmp/test

# Push the game image
if [ ! "$NO_PUSH" = 'true' ]; then
    date
    time docker push "$GAME_IMAGE"
    if [ "$PIPELINE" = 'build' ]; then
        if [ "$LATEST" = 'true' ]; then
            time docker push "$REPOSITORY:latest"
        fi
    elif [ "$PIPELINE" = 'update' ]; then
        time docker push "$REPOSITORY:$GAME_VERSION-layered"
    fi
    date
fi

# Docker registry logout
if [ ! "$NO_PUSH" = 'true' ]; then
    docker logout
fi
