#!/usr/bin/env bash
# Search prediction markets by text query
# Usage: droyd-pm-search.sh <query> [venue] [sort] [limit] [live]
# Example: droyd-pm-search.sh "bitcoin price"
# Example: droyd-pm-search.sh "ethereum" "polymarket" "volume" 10 true

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

QUERY="${1:-}"
VENUE="${2:-}"
SORT="${3:-}"
LIMIT="${4:-}"
LIVE="${5:-}"

if [[ -z "$QUERY" ]]; then
  echo "Usage: droyd-pm-search.sh <query> [venue] [sort] [limit] [live]" >&2
  exit 1
fi

DATA=$(jq -n --arg q "$QUERY" '{query: $q}')

[[ -n "$VENUE" ]] && DATA=$(echo "$DATA" | jq --arg v "$VENUE" '. + {venue: $v}')
[[ -n "$SORT" ]] && DATA=$(echo "$DATA" | jq --arg v "$SORT" '. + {sort: $v}')
[[ -n "$LIMIT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$LIMIT" '. + {limit: $v}')
[[ -n "$LIVE" ]] && DATA=$(echo "$DATA" | jq --argjson v "$LIVE" '. + {live: $v}')

droyd_request "POST" "/api/v1/prediction-markets/markets/search" "$DATA"
