#!/usr/bin/env bash
# Get Twitter handles that have mentioned specific projects, ranked by relevance
# Usage: droyd-social-handles.sh <project_ids> [days_back] [limit] [sort_by] [person_only] [included_attributes] [attribute_limit]
# Example: droyd-social-handles.sh "1790"
# Example: droyd-social-handles.sh "1790,6193" 7 30 "total_relevance" true "twitter_profile,recent_posts" 5

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

PROJECT_IDS="${1:-}"
DAYS_BACK="${2:-}"
LIMIT="${3:-}"
SORT_BY="${4:-}"
PERSON_ONLY="${5:-}"
ATTRIBUTES="${6:-}"
ATTR_LIMIT="${7:-}"

if [[ -z "$PROJECT_IDS" ]]; then
  echo "Usage: droyd-social-handles.sh <project_ids> [days_back] [limit] [sort_by] [person_only] [included_attributes] [attribute_limit]" >&2
  exit 1
fi

# Convert comma-separated to JSON number array
to_json_num_array() {
  echo "$1" | tr ',' '\n' | jq -R 'tonumber' | jq -s .
}

# Convert comma-separated to JSON string array
to_json_array() {
  echo "$1" | tr ',' '\n' | jq -R . | jq -s .
}

DATA=$(jq -n --argjson ids "$(to_json_num_array "$PROJECT_IDS")" '{project_ids: $ids}')

[[ -n "$DAYS_BACK" ]] && DATA=$(echo "$DATA" | jq --argjson v "$DAYS_BACK" '. + {days_back: $v}')
[[ -n "$LIMIT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$LIMIT" '. + {limit: $v}')
[[ -n "$SORT_BY" ]] && DATA=$(echo "$DATA" | jq --arg v "$SORT_BY" '. + {sort_by: $v}')
[[ -n "$PERSON_ONLY" ]] && DATA=$(echo "$DATA" | jq --argjson v "$PERSON_ONLY" '. + {person_only: $v}')
[[ -n "$ATTRIBUTES" ]] && DATA=$(echo "$DATA" | jq --argjson v "$(to_json_array "$ATTRIBUTES")" '. + {included_attributes: $v}')
[[ -n "$ATTR_LIMIT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$ATTR_LIMIT" '. + {attribute_limit: $v}')

droyd_request "POST" "/api/v1/social/top-handles-by-project" "$DATA"
