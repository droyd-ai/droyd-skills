#!/usr/bin/env bash
# Get wallet PnL broken down by token with project enrichment
# Usage: droyd-wallets-pnl.sh <wallet> [duration] [limit] [include_attributes] [sort_type]
# Example: droyd-wallets-pnl.sh "5Q544fKrFoe6tsEbD7S8EmxGTJYAKtTVhAW5Q5pge4j1"
# Example: droyd-wallets-pnl.sh "5Q544fKrFoe6tsEbD7S8EmxGTJYAKtTVhAW5Q5pge4j1" "30d" 20 "technical_analysis,mindshare"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

WALLET="${1:-}"
DURATION="${2:-}"
LIMIT="${3:-}"
ATTRIBUTES="${4:-}"
SORT_TYPE="${5:-}"

if [[ -z "$WALLET" ]]; then
  echo "Usage: droyd-wallets-pnl.sh <wallet> [duration] [limit] [include_attributes] [sort_type]" >&2
  echo "  duration: 24h, 7d, 30d, 90d, all (default: all)" >&2
  exit 1
fi

# Convert comma-separated to JSON array
to_json_array() {
  echo "$1" | tr ',' '\n' | jq -R . | jq -s .
}

DATA=$(jq -n --arg w "$WALLET" '{wallet: $w}')

[[ -n "$DURATION" ]] && DATA=$(echo "$DATA" | jq --arg v "$DURATION" '. + {duration: $v}')
[[ -n "$LIMIT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$LIMIT" '. + {limit: $v}')
[[ -n "$ATTRIBUTES" ]] && DATA=$(echo "$DATA" | jq --argjson v "$(to_json_array "$ATTRIBUTES")" '. + {include_attributes: $v}')
[[ -n "$SORT_TYPE" ]] && DATA=$(echo "$DATA" | jq --arg v "$SORT_TYPE" '. + {sort_type: $v}')

droyd_request "POST" "/api/v1/data/wallets/pnl-details" "$DATA"
