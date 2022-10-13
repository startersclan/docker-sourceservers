# syntax=docker/dockerfile:1

# Builds a layered image containing the latest game version based upon the specified game image.

ARG GAME_IMAGE
FROM $GAME_IMAGE

ARG INSTALL_COUNT=1
ARG STEAM_LOGIN

RUN --mount=type=secret,id=STEAM_USERNAME \
    --mount=type=secret,id=STEAM_PASSWORD \
    STEAM_USERNAME=$( cat /run/secrets/STEAM_USERNAME ); \
    STEAM_PASSWORD=$( cat /run/secrets/STEAM_PASSWORD ); \
    echo "[UPDATE] SERVER_DIR: $SERVER_DIR"; \
    echo "[UPDATE] APPID: $APPID"; \
    echo "[UPDATE] MOD: $MOD"; \
    echo "[UPDATE] INSTALL_COUNT: $INSTALL_COUNT"; \
    echo "[UPDATE] STEAM_LOGIN: $STEAM_LOGIN"; \
    if ( [ "$STEAM_LOGIN" = 'true' ] && [ -n "$STEAM_USERNAME" ] && [ -n "$STEAM_PASSWORD" ] || [ "$APPID" = 90 ] ); then \
        steamcmdLoginArgs="$STEAM_USERNAME $STEAM_PASSWORD"; \
    else \
        steamcmdLoginArgs='anonymous'; \
    fi; \
    if [ "$APPID" = 90 ] && [ -n "$MOD" ]; then \
        steamcmdArgs="+force_install_dir $SERVER_DIR +login $steamcmdLoginArgs +app_set_config $APPID mod $MOD +app_update $APPID validate +quit"; \
    else \
        steamcmdArgs="+force_install_dir $SERVER_DIR +login $steamcmdLoginArgs +app_update $APPID validate +quit"; \
    fi; \
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
        siteserverui \
        linux32/libtier0_s.so \
        linux32/libvstdlib_s.so \
        linux32/steamclient.so \
        linux32/steamconsole.so \
        update_hosts_cached.vdf \
        /root/.steam \
        /root/Steam
