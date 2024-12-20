# syntax=docker/dockerfile:1

# Builds a layered image containing the latest game version based upon the specified game image.

ARG GAME_IMAGE
FROM $GAME_IMAGE

ARG INSTALL_COUNT=1
ARG STEAM_LOGIN
ARG CACHE_KEY

# Update game
RUN --mount=type=secret,id=STEAM_USERNAME \
    --mount=type=secret,id=STEAM_PASSWORD \
    STEAM_USERNAME=$( cat /run/secrets/STEAM_USERNAME ); \
    STEAM_PASSWORD=$( cat /run/secrets/STEAM_PASSWORD ); \
    if [ -z "$INSTALL_COUNT" ]; then \
        INSTALL_COUNT=1; \
    fi; \
    echo "[UPDATE] SERVER_DIR: $SERVER_DIR"; \
    echo "[UPDATE] APPID: $APPID"; \
    echo "[UPDATE] MOD: $MOD"; \
    echo "[UPDATE] INSTALL_COUNT: $INSTALL_COUNT"; \
    echo "[UPDATE] STEAM_LOGIN: $STEAM_LOGIN"; \
    if [ "$STEAM_LOGIN" = 'true' ]; then \
        echo "[UPDATE] STEAM_LOGIN is true. Will log in via user"; \
        steamcmdLoginArgs="$STEAM_USERNAME $STEAM_PASSWORD"; \
    else \
        echo "[UPDATE] STEAM_LOGIN is null or not true. Will connect anonymously"; \
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
        echo "[UPDATE] Install count: [$(( i+1 ))/$INSTALL_COUNT]"; \
        steamcmd.sh $steamcmdArgs; \
        ls -al "$SERVER_DIR/steamapps"; \
        i=$(( i+1 )); \
    done; \
    if [ "$APPID" = 90 ]; then \
        echo "[UPDATE] Applying hotfixes for hlds"; \
        # Hotfix "Error:./libstdc++.so.6: version CXXABI_1.3.8' not found"
        ln -sfnv /usr/lib/x86_64-linux-gnu/libgcc_s.so.1 "$SERVER_DIR/libgcc_s.so.1"; \
        ln -sfnv /usr/lib/x86_64-linux-gnu/libstdc++.so.6 "$SERVER_DIR/libstdc++.so.6"; \
        ln -sfnv /usr/lib/x86_64-linux-gnu/libstdc++.so.6 "$STEAMCMD_DIR/linux32/libstdc++.so.6"; \
    fi;
