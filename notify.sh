#!/bin/sh
set -eu

usage() {
    echo "notify.sh: Send build status to a webhook. Requires git and curl"
    echo "Examples: "
    echo "  ./notify.sh"
}
if [ "${1:-}" = '-h' ] || [ "${1:-}" = '--help' ]; then
    usage
    exit 0
fi

# CI variables
CI_JOB_ID=${CI_JOB_ID:?err}
CI_PROJECT_NAMESPACE=${CI_PROJECT_NAMESPACE:?err}
CI_PROJECT_NAME=${CI_PROJECT_NAME:-$( git rev-parse --show-toplevel | xargs basename )}
CI_COMMIT_BRANCH=${CI_COMMIT_BRANCH:-$( git rev-parse --abbrev-ref HEAD )}
CI_COMMIT_SHORT_SHA=${CI_COMMIT_SHORT_SHA:-$( git rev-parse HEAD | head -c7 )}

# Read .build.state file
echo "Reading .build.state file"
. ./.build.state

# Build state
BUILD_STATUS=${BUILD_STATUS:?err}
BASE_SIZE=${BASE_SIZE:-0}
LAYERED_SIZE=${LAYERED_SIZE:-0}

# Secrets
X_GITLAB_WEBHOOK_SECRET=${X_GITLAB_WEBHOOK_SECRET:?err}
NOTIFICATION_WEBHOOK=${NOTIFICATION_WEBHOOK:?err}

# Send a webhook notification
date -Iseconds
echo "Sending notification"
BODY=$( cat <<EOF
{
    "build_num": "$CI_JOB_ID",
    "username": "$CI_PROJECT_NAMESPACE",
    "reponame": "$CI_PROJECT_NAME",
    "branch": "$CI_COMMIT_BRANCH",
    "commit_sha": "$CI_COMMIT_SHORT_SHA",
    "status": "$BUILD_STATUS",
    "state": {
        "BUILD_STATUS": "$BUILD_STATUS",
        "BASE_SIZE": "$BASE_SIZE",
        "LAYERED_SIZE": "$LAYERED_SIZE"
    }
}
EOF
)
echo "BODY: $BODY"
date -Iseconds
STATUS=$( curl -s -o /dev/null -w '%{http_code}' -X POST -H 'Content-Type: application/json' -H "x-gitlab-webhook-secret: $X_GITLAB_WEBHOOK_SECRET" --data "$BODY" "$NOTIFICATION_WEBHOOK" || true )
echo "STATUS: $STATUS"
if [ "$STATUS" -eq 200 ] || [ "$STATUS" -eq 201 ]; then
    echo "Notification sent"
    exit 0
else
    echo "Failed to send notification"
    exit 1
fi
