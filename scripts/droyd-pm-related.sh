#!/usr/bin/env bash
# Get related prediction markets for a given event or market
# Usage: droyd-pm-related.sh <slug> [limit]
# Example: droyd-pm-related.sh "will-bitcoin-hit-100k-2025"
# Example: droyd-pm-related.sh "will-bitcoin-hit-100k-2025" 10

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

SLUG="${1:-}"
LIMIT="${2:-}"

if [[ -z "$SLUG" ]]; then
  echo "Usage: droyd-pm-related.sh <slug> [limit]" >&2
  exit 1
fi

DATA=$(jq -n --arg s "$SLUG" '{slug: $s}')

[[ -n "$LIMIT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$LIMIT" '. + {limit: $v}')

droyd_request "POST" "/api/v1/prediction-markets/markets/related" "$DATA"
