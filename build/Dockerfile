# syntax=docker/dockerfile:1

# Builds a clean image containing the latest version of the specified game.

FROM startersclan/steamcmd:git-20190605.0.0

ARG SERVER_DIR=/server
ARG APPMANIFEST_AR_URL=https://github.com/startersclan/hlds-appmanifest/archive/refs/tags/v2.0.0.tar.gz
ARG APPID
ARG MOD
ARG FIX_APPMANIFEST=false
ARG CLIENT_APPID
ARG INSTALL_COUNT
ARG STEAM_LOGIN
ARG CACHE_KEY

# Download game
RUN --mount=type=secret,id=STEAM_USERNAME \
    --mount=type=secret,id=STEAM_PASSWORD \
    STEAM_USERNAME=$( cat /run/secrets/STEAM_USERNAME ); \
    STEAM_PASSWORD=$( cat /run/secrets/STEAM_PASSWORD ); \
    if [ -z "$INSTALL_COUNT" ]; then \
        echo "[BUILD] INSTALL_COUNT is null. Using default values"; \
        if [ "$APPID" = 90 ]; then \
            INSTALL_COUNT=3; \
        else \
            INSTALL_COUNT=1; \
        fi; \
    fi; \
    echo "[BUILD] SERVER_DIR: $SERVER_DIR"; \
    echo "[BUILD] APPMANIFEST_AR_URL: $APPMANIFEST_AR_URL"; \
    echo "[BUILD] APPID: $APPID"; \
    echo "[BUILD] MOD: $MOD"; \
    echo "[BUILD] FIX_APPMANIFEST: $FIX_APPMANIFEST"; \
    echo "[BUILD] INSTALL_COUNT: $INSTALL_COUNT"; \
    echo "[BUILD] STEAM_LOGIN: $STEAM_LOGIN"; \
    if [ "$STEAM_LOGIN" = 'true' ]; then \
        echo "[BUILD] STEAM_LOGIN is true. Will log in via user"; \
        steamcmdLoginArgs="$STEAM_USERNAME $STEAM_PASSWORD"; \
    else \
        echo "[BUILD] STEAM_LOGIN is null or not true. Will connect anonymously"; \
        steamcmdLoginArgs='anonymous'; \
    fi; \
    if [ "$APPID" = 90 ] && [ -n "$MOD" ]; then \
        steamcmdArgs="+force_install_dir $SERVER_DIR +login $steamcmdLoginArgs +app_set_config $APPID mod $MOD +app_update $APPID validate +quit"; \
    else \
        steamcmdArgs="+force_install_dir $SERVER_DIR +login $steamcmdLoginArgs +app_update $APPID validate +quit"; \
    fi; \
    if [ "$APPID" = 90 ]; then \
        if [ "$FIX_APPMANIFEST" = 'true' ]; then \
            echo "[BUILD] APPID is 90 and FIX_APPMANIFEST is true. Will apply appmanifest fix"; \
        else \
            echo "[BUILD] APPID is 90 but FIX_APPMANIFEST is null or not true. Will not apply appmanifest fix"; \
        fi; \
    else \
        echo "[BUILD] APPID is not 90. Will not apply appmanifest fix"; \
    fi; \
    echo "[BUILD] Downloading game"; \
    i=0; \
    while [ "$i" -le $(( $INSTALL_COUNT-1 )) ]; do \
        echo "[BUILD] Install count: [$(( i+1 ))/$INSTALL_COUNT]"; \
        steamcmd.sh $steamcmdArgs; \
        ls -al "$SERVER_DIR/steamapps"; \
        i=$(( i+1 )); \
        if [ "$i" -eq 1 ] && [ "$APPID" = 90 ] && [ "$FIX_APPMANIFEST" = 'true' ]; then \
            if [ -n "$MOD" ]; then \
                WILDCARD_PATTERN="*/$MOD/*"; \
            else \
                WILDCARD_PATTERN='*/valve/*'; \
            fi; \
            echo "[BUILD] Applying appmanifest fix"; \
            curl -sqL "$APPMANIFEST_AR_URL" | tar -zxvf - -C "$SERVER_DIR/steamapps" --wildcards "$WILDCARD_PATTERN" --strip-components=2; \
            ls -al "$SERVER_DIR/steamapps"; \
        fi; \
    done; \
    echo "[BUILD] Performing cleanup"; \
    cd "$STEAMCMD_DIR" && rm -rf \
        linux64 \
        package \
        public \
        siteserverui \
        steam \
        linux32/libtier0_s.so \
        linux32/libvstdlib_s.so \
        linux32/steamclient.so \
        linux32/steamconsole.so \
        update_hosts_cached.vdf; \
    rm -rf /root/.steam; \
    if [ "$APPID" = 90 ]; then \
        # Retain `/root/Steam/appcache` to prevent `steamcmd` from re-downloading `hlds` game entirely on game updates
        rm -rf $( find /root/Steam -mindepth 1 -maxdepth 1 | grep -v '^/root/Steam/appcache' ); \
    else \
        rm -rf /root/Steam; \
    fi;

# Apply game fixes
RUN echo "[BUILD] Applying game fixes"; \
    # Create steam_appid.txt containing the game's appid to prevent crashes on first run
    echo "[BUILD] CLIENT_APPID: $CLIENT_APPID"; \
    echo "$CLIENT_APPID" > "$SERVER_DIR/steam_appid.txt"

# For directly running the hlds_linux / srcds_linux binary
ENV LD_LIBRARY_PATH .:bin:$LD_LIBRARY_PATH

ENV APPID $APPID
ENV MOD $MOD
ENV CLIENT_APPID $CLIENT_APPID
ENV SERVER_DIR $SERVER_DIR
ENV PATH $PATH:$SERVER_DIR

WORKDIR $SERVER_DIR

ENTRYPOINT ["/bin/bash", "-c"]
CMD [""]
