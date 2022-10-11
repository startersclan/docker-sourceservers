#/bin/sh

# Process job variables
BUILD_STATUS=${BUILD_STATUS:?err}
GAME_VERSION=${GAME_VERSION:-}
APPID=${APPID:-}
CLIENT_APPID=${CLIENT_APPID:-}
GAME=${GAME:-}
MOD=${MOD:-}
FIX_APPMANIFEST=${FIX_APPMANIFEST:-}
GAME_UPDATE_COUNT=${GAME_UPDATE_COUNT:-}
LATEST=${LATEST:-}
CACHE=${CACHE:-}
NO_TEST=${NO_TEST:-}
NO_PUSH=${NO_PUSH:-}
STEAM_LOGIN=${STEAM_LOGIN:-}

# Send notification
date
echo "Sending notification"
BODY=$( cat <<EOF
{
    "build_num": "$CI_JOB_ID",
    "username": "$CI_PROJECT_NAMESPACE",
    "reponame": "$CI_PROJECT_NAME",
    "branch": "$CI_COMMIT_BRANCH",
    "build_parameters": {
        "GAME_VERSION": "$GAME_VERSION",
        "APPID": "$APPID",
        "CLIENT_APPID": "$CLIENT_APPID",
        "GAME": "$GAME",
        "MOD": "$MOD",
        "FIX_APPMANIFEST": "$FIX_APPMANIFEST",
        "GAME_UPDATE_COUNT": "$GAME_UPDATE_COUNT",
        "LATEST": "$LATEST",
        "CACHE": "$CACHE",
        "NO_TEST": "$NO_TEST",
        "NO_PUSH": "$NO_PUSH",
        "STEAM_LOGIN": "$STEAM_LOGIN"
    },
    "status": "$BUILD_STATUS"
}
EOF
)
echo "BODY: $BODY"
date
STATUS=$( curl -s -o /dev/null -w '%{http_code}' -X POST -H 'Content-Type: application/json' -H "x-gitlab-webhook-secret: $X_GITLAB_WEBHOOK_SECRET" --data "$BODY" "$NOTIFICATION_WEBHOOK" )
echo "STATUS: $STATUS"
if [ $STATUS -eq 200 ] || [ $STATUS -eq 201 ]; then
    echo "Notification sent"
    exit 0
else
    echo "Failed to send notification"
    exit 1
fi
