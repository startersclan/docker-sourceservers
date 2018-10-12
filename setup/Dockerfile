# Builds a base image for the specified game.

FROM joeltimothyoh/steamcmd

MAINTAINER The Oh Brothers

ARG GAME_BASE_DIR=/server
ARG APPMANIFEST_AR_URL=https://gameservers.startersclan.com/shared/assets/hlds/appmanifest.tar.gz
ARG APP_ID
ARG MOD
ARG appmanifest_fix=false
ARG install_count=3

# Download game
RUN echo "[docker-source-server-setup] Downloading game"; \
    echo "[docker-source-server-setup] GAME_BASE_DIR: $GAME_BASE_DIR"; \
    echo "[docker-source-server-setup] APPMANIFEST_AR_URL: $APPMANIFEST_AR_URL"; \
    echo "[docker-source-server-setup] APP_ID: $APP_ID"; \
    echo "[docker-source-server-setup] MOD: $MOD"; \
    echo "[docker-source-server-setup] appmanifest_fix: $appmanifest_fix"; \
    echo "[docker-source-server-setup] install_count: $install_count"; \
    if [ ! -z "$MOD" ]; then \
        steamcmd_params="+login anonymous +force_install_dir $GAME_BASE_DIR +app_set_config $APP_ID mod $MOD +app_update $APP_ID validate +quit"; \
    else \
        steamcmd_params="+login anonymous +force_install_dir $GAME_BASE_DIR +app_update $APP_ID validate +quit"; \
    fi; \
    echo "[docker-source-server-setup] steamcmd parameters: $steamcmd_params"; \
    echo "[docker-source-server-setup] Downloading game"; \
    if [ "$APP_ID" = 90 ] && [ "$appmanifest_fix" = true ]; then \
        echo "[docker-source-server-setup] APP_ID is 90 and appmanifest_fix is true. Appmanifest fix and install count will apply."; \
        i=0; \
        while [ "$i" -le $(( $install_count-1 )) ]; do \
            echo "[docker-source-server-setup] Current install count: $(( i+1 ))"; \
            steamcmd.sh $steamcmd_params; \
            i=$(( i+1 )); \
            if [ "$i" -eq 1 ]; then \
                echo "[docker-source-server-setup] Downloading and applying appmanifest fix"; \
                curl -sqLk "$APPMANIFEST_AR_URL" | tar zxvf - -C $GAME_BASE_DIR/steamapps; \
            fi; \
        done; \
    else \
        echo "[docker-source-server-setup] Either APP_ID is not 90 or appmanifest_fix is not true. Appmanifest fix and install count will be ignored."; \
        steamcmd.sh $steamcmd_params; \
    fi

# Apply game fixes
RUN echo "[docker-source-server-setup] Applying game fixes"; \
    # Create steam_appid.txt containing the app id to prevent crash on first run
    echo $APP_ID > $GAME_BASE_DIR/steam_appid.txt
    # Create a symlink to steamcmd's steamclient.so file to stop the error
    #mkdir -p ~/.steam/sdk32 && ln -sf $STEAMCMD_DIR/linux32/steamclient.so ~/.steam/sdk32/steamclient.so

ENV GAME_BASE_DIR $GAME_BASE_DIR
ENV APP_ID $APP_ID
ENV MOD $MOD
ENV PATH $PATH:$GAME_BASE_DIR
ENV LD_LIBRARY_PATH .:bin:$LD_LIBRARY_PATH

WORKDIR $GAME_BASE_DIR

ENTRYPOINT ["/bin/bash", "-c"]
CMD [""]