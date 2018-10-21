# Updates the specified game base image.

ARG GAME_IMAGE
FROM $GAME_IMAGE

ARG install_count=1

RUN echo "[UPDATE] Updating game"; \
    echo "[UPDATE] SERVER_DIR: $SERVER_DIR"; \
    echo "[UPDATE] APPID: $APPID"; \
    echo "[UPDATE] MOD: $MOD"; \
    echo "[UPDATE] install_count: $install_count"; \
    # For performance, no validate will be used when updating
    if [ ! -z "$MOD" ]; then \
        steamcmdArgs="+login anonymous +force_install_dir $SERVER_DIR +app_set_config $APPID mod $MOD +app_update $APPID validate +quit"; \
    else \
        steamcmdArgs="+login anonymous +force_install_dir $SERVER_DIR +app_update $APPID validate +quit"; \
    fi; \
    echo "[UPDATE] steamcmd parameters: $steamcmdArgs"; \
    echo "[UPDATE] Updating game"; \
    i=0; \
    while [ "$i" -le $(( $install_count-1 )) ]; do \
        echo "[UPDATE] Current install count: $(( i+1 ))"; \
        steamcmd.sh $steamcmdArgs; \
        i=$(( i+1 )); \
    done; \
    fi