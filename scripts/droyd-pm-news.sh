#!/usr/bin/env bash
# Get news articles for a prediction market event
# Usage: droyd-pm-news.sh <event_id> [limit]
# Example: droyd-pm-news.sh "12345"
# Example: droyd-pm-news.sh "12345" 20

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

EVENT_ID="${1:-}"
LIMIT="${2:-}"

if [[ -z "$EVENT_ID" ]]; then
  echo "Usage: droyd-pm-news.sh <event_id> [limit]" >&2
  exit 1
fi

DATA=$(jq -n --arg id "$EVENT_ID" '{event_id: $id}')

[[ -n "$LIMIT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$LIMIT" '. + {limit: $v}')

droyd_request "POST" "/api/v1/prediction-markets/markets/news" "$DATA"
