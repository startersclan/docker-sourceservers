#/bin/sh

command -v curl || apk add --no-cache curl
command -v jq || apk add --no-cache jq
JOB=$( curl -s -X GET "https://gitlab.com/api/v4/projects/$CI_PROJECT_ID/pipelines/$CI_PIPELINE_ID/jobs" | jq -r '.[] | select(.name == "build-image")' )
date
echo "JOB:" $JOB
if [ -z "$JOB" ]; then
    echo "No job name matching 'build-image'"
    exit 1
fi
export JOB_STATUS=$( echo -n "$JOB" | jq -r '.status' )
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
        "NO_PUSH": "$NO_PUSH"
    },
    "status": "$JOB_STATUS"
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
