# Builds a base image for the specified game.

FROM joeltimothyoh/steamcmd

MAINTAINER The Oh Brothers

ARG GAME_BASE_DIR=/server
ARG APPMANIFEST_AR_URL=https://gameservers.startersclan.com/shared/assets/hlds/appmanifest.tar.gz
ARG APPID
ARG MOD
ARG FIX_APPMANIFEST=false
ARG INSTALL_COUNT=3
ARG GAME
ARG VERSION

# Download game
RUN echo "[SETUP] GAME_BASE_DIR: $GAME_BASE_DIR"; \
    echo "[SETUP] APPMANIFEST_AR_URL: $APPMANIFEST_AR_URL"; \
    echo "[SETUP] APPID: $APPID"; \
    echo "[SETUP] MOD: $MOD"; \
    echo "[SETUP] FIX_APPMANIFEST: $FIX_APPMANIFEST"; \
    echo "[SETUP] INSTALL_COUNT: $INSTALL_COUNT"; \
    echo "[SETUP] GAME: $GAME"; \
    echo "[SETUP] VERSION: $VERSION"; \
    if [ ! -z "$MOD" ]; then \
        steamcmdArgs="+login anonymous +force_install_dir $GAME_BASE_DIR +app_set_config $APPID mod $MOD +app_update $APPID validate +quit"; \
    else \
        steamcmdArgs="+login anonymous +force_install_dir $GAME_BASE_DIR +app_update $APPID validate +quit"; \
    fi; \
    echo "[SETUP] steamcmd arguments: $steamcmdArgs"; \
    echo "[SETUP] Downloading game"; \
    if [ "$APPID" = 90 ] && [ "$FIX_APPMANIFEST" = true ]; then \
        echo "[SETUP] APPID is 90 and FIX_APPMANIFEST is true. Appmanifest fix and install count will apply."; \
        i=0; \
        while [ "$i" -le $(( $INSTALL_COUNT-1 )) ]; do \
            echo "[SETUP] Current install count: $(( i+1 ))"; \
            steamcmd.sh $steamcmdArgs; \
            i=$(( i+1 )); \
            if [ "$i" -eq 1 ]; then \
                echo "[SETUP] Downloading and applying appmanifest fix"; \
                curl -sqLk "$APPMANIFEST_AR_URL" | tar zxvf - -C $GAME_BASE_DIR/steamapps; \
            fi; \
        done; \
    else \
        echo "[SETUP] Either APPID is not 90 or FIX_APPMANIFEST is not true. Appmanifest fix and install count will be ignored."; \
        steamcmd.sh $steamcmdArgs; \
    fi

# Apply game fixes
RUN echo "[SETUP] Applying game fixes"; \
    # Create steam_appid.txt containing the app id to prevent crash on first run
    echo $APPID > $GAME_BASE_DIR/steam_appid.txt
    # Create a symlink to steamcmd's steamclient.so file to stop the error
    #mkdir -p ~/.steam/sdk32 && ln -sf $STEAMCMD_DIR/linux32/steamclient.so ~/.steam/sdk32/steamclient.so

ENV GAME_BASE_DIR $GAME_BASE_DIR
ENV APPID $APPID
ENV MOD $MOD
ENV PATH $PATH:$GAME_BASE_DIR
ENV LD_LIBRARY_PATH .:bin:$LD_LIBRARY_PATH

LABEL appid=$APPID
LABEL mod=$MOD
LABEL game=$GAME
LABEL game_version=$VERSION

WORKDIR $GAME_BASE_DIR

ENTRYPOINT ["/bin/bash", "-c"]
CMD [""]