# Updates the specified game base image.

ARG GAME_IMAGE
FROM $GAME_IMAGE

ARG INSTALL_COUNT=1

RUN echo "[UPDATE] SERVER_DIR: $SERVER_DIR"; \
    echo "[UPDATE] APPID: $APPID"; \
    echo "[UPDATE] MOD: $MOD"; \
    echo "[UPDATE] INSTALL_COUNT: $INSTALL_COUNT"; \
    if [ "$APPID" = 90 ] && [ -n "$MOD" ]; then \
        steamcmdArgs="+login anonymous +force_install_dir $SERVER_DIR +app_set_config $APPID mod $MOD +app_update $APPID validate +quit"; \
    else \
        steamcmdArgs="+login anonymous +force_install_dir $SERVER_DIR +app_update $APPID validate +quit"; \
    fi; \
    echo "[UPDATE] steamcmd arguments: $steamcmdArgs"; \
    echo "[UPDATE] Updating game"; \
    i=0; \
    while [ "$i" -le $(( $INSTALL_COUNT-1 )) ]; do \
        echo "[UPDATE] Current install count: $(( i+1 ))"; \
        steamcmd.sh $steamcmdArgs; \
        i=$(( i+1 )); \
    done; \
    echo "[UPDATE] Performing cleanup" \
    && cd "$STEAMCMD_DIR" && rm -rf \
        linux64 \
        package \
        public \
        linux32/libtier0_s.so \
        linux32/libvstdlib_s.so \
        linux32/steamclient.so \
        linux32/steamconsole.so \
    && rm -rf "~/Steam" \
    && rm -rf "~/.steam"