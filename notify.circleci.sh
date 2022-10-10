#/bin/sh

# Keep checking status of my workflow's sibling job. Once it's completed, send a notification.
SLEEP=5
SLEPT=0
SLEEP_THRESHOLD=7200
while true; do
    JOB=$( curl -s -X GET -H "Circle-Token: $CIRCLE_API_TOKEN" -H 'Accept: application/json' "https://circleci.com/api/v2/workflow/$CIRCLE_WORKFLOW_ID/job" | jq -r '.items[] | select(.name == "build-image")' )
    date
    echo "JOB:" $JOB
    if [ -z "$JOB" ]; then
        echo "No job name matching 'build-image'"
        exit 1
    fi
    export JOB_STATUS=$( echo -n "$JOB" | jq -r '.status' )
    if [ "$JOB_STATUS" == "success" ] || [ "$JOB_STATUS" == "failed" ] || [ "$JOB_STATUS" == "cancelled" ]; then
        echo "Sending notification"
        export JOB_NUMBER=$( echo -n "$JOB" | jq -r '.job_number' )
        BODY=$( cat <<EOF
{
    "build_num": "$JOB_NUMBER",
    "username": "$CIRCLE_PROJECT_USERNAME",
    "reponame": "$CIRCLE_PROJECT_REPONAME",
    "branch": "$CIRCLE_BRANCH",
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
        STATUS=$( curl -s -o /dev/null -w '%{http_code}' -X POST -H 'Content-Type: application/json' -H "x-circleci-webhook-secret: $X_CIRCLECI_WEBHOOK_SECRET" --data "$BODY" "$NOTIFICATION_WEBHOOK" && exit 0 || exit 1 )
        echo "STATUS: $STATUS"
        if [ $STATUS -eq 200 ] || [ $STATUS -eq 201 ]; then
            echo "Notification sent"
            exit 0
        else
            echo "Failed to send notification"
            exit 1
        fi
    else
        SLEPT=$(($SLEPT+$SLEEP))
        if [ "$SLEPT" -ge "$SLEEP_THRESHOLD" ]; then
            echo "Job has been running too long"
            exit 1
        fi
        echo "Sleeping for $SLEEP seconds before checking again"
        sleep $SLEEP
    fi
done
