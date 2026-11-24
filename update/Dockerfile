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
    echo "[UPDATE] Performing cleanup"; \
    cd "$STEAMCMD_DIR" && rm -rf \
        package \
        public \
        siteserverui \
        steam \
        linux32/libtier0_s.so \
        linux32/libvstdlib_s.so \
        linux32/logs \
        linux32/steamconsole.so \
        linux64/crashhandler.so \
        linux64/libtier0_s.so \
        linux64/libvstdlib_s.so \
        linux64/steamcmd \
        linux64/steamconsole.so \
        linux64/steamerrorreporter \
        update_hosts_cached.vdf; \
    if [ ! "$APPID" = 730 ]; then \
        cd "$STEAMCMD_DIR" && rm -rf \
            linux64; \
    fi; \
    rm -rf /root/.steam; \
    if [ "$APPID" = 90 ]; then \
        # Retain `/root/Steam/appcache` to prevent `steamcmd` from re-downloading `hlds` game entirely on game updates
        rm -rf $( find /root/Steam -mindepth 1 -maxdepth 1 | grep -v '^/root/Steam/appcache' ); \
    else \
        # Cleanup. This also cleans up user data
        rm -rf /root/Steam; \
    fi;

# Apply game fixes
RUN echo "[UPDATE] Applying game fixes"; \
    # Create steam_appid.txt containing the game's appid to prevent crashes on first run
    echo "[UPDATE] CLIENT_APPID: $CLIENT_APPID"; \
    echo "$CLIENT_APPID" > "$SERVER_DIR/steam_appid.txt"; \
    if [ "$APPID" = 730 ]; then \
        # Fix error for 64-bit games: /root/.steam/sdk64/steamclient.so: cannot open shared object file: No such file or directory
        mkdir -p /root/.steam/sdk64; \
        ln -sfnv "$STEAMCMD_DIR/linux64/steamclient.so" /root/.steam/sdk64/steamclient.so; \
    fi; \
    # Fix error for 32-bit games: /root/.steam/sdk32/steamclient.so: cannot open shared object file: No such file or directory
    mkdir -p /root/.steam/sdk32; \
    ln -sfnv "$STEAMCMD_DIR/linux32/steamclient.so" /root/.steam/sdk32/steamclient.so;
