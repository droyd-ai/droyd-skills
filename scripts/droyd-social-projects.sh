#!/usr/bin/env bash
# Get projects mentioned by specific Twitter handles, ranked by relevance
# Usage: droyd-social-projects.sh <handles> [days_back] [limit] [sort_by] [included_attributes] [attribute_limit] [include_retweets]
# Example: droyd-social-projects.sh "inversebrah,DefiIgnas,Route2FI"
# Example: droyd-social-projects.sh "inversebrah,DefiIgnas" 30 20 "total_relevance" "market_data,mindshare,recent_posts" 3 true

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

HANDLES="${1:-}"
DAYS_BACK="${2:-}"
LIMIT="${3:-}"
SORT_BY="${4:-}"
ATTRIBUTES="${5:-}"
ATTR_LIMIT="${6:-}"
RETWEETS="${7:-}"

if [[ -z "$HANDLES" ]]; then
  echo "Usage: droyd-social-projects.sh <handles> [days_back] [limit] [sort_by] [included_attributes] [attribute_limit] [include_retweets]" >&2
  exit 1
fi

# Convert comma-separated to JSON array
to_json_array() {
  echo "$1" | tr ',' '\n' | jq -R . | jq -s .
}

DATA=$(jq -n --argjson handles "$(to_json_array "$HANDLES")" '{handles: $handles}')

[[ -n "$DAYS_BACK" ]] && DATA=$(echo "$DATA" | jq --argjson v "$DAYS_BACK" '. + {days_back: $v}')
[[ -n "$LIMIT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$LIMIT" '. + {limit: $v}')
[[ -n "$SORT_BY" ]] && DATA=$(echo "$DATA" | jq --arg v "$SORT_BY" '. + {sort_by: $v}')
[[ -n "$ATTRIBUTES" ]] && DATA=$(echo "$DATA" | jq --argjson v "$(to_json_array "$ATTRIBUTES")" '. + {included_attributes: $v}')
[[ -n "$ATTR_LIMIT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$ATTR_LIMIT" '. + {attribute_limit: $v}')
[[ -n "$RETWEETS" ]] && DATA=$(echo "$DATA" | jq --argjson v "$RETWEETS" '. + {include_retweets: $v}')

droyd_request "POST" "/api/v1/social/top-projects-by-handle" "$DATA"
