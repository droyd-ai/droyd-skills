#!/usr/bin/env bash
# Get top PnL gainers and losers across wallets
# Usage: droyd-wallets-pnl-leaders.sh <type> [sort_type] [limit] [chain]
# type: yesterday, today, 1W
# Example: droyd-wallets-pnl-leaders.sh "today"
# Example: droyd-wallets-pnl-leaders.sh "today" "desc" 10 "solana"
# Example: droyd-wallets-pnl-leaders.sh "1W" "asc" 10 "ethereum"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

TYPE="${1:-}"
SORT_TYPE="${2:-}"
LIMIT="${3:-}"
CHAIN="${4:-}"

if [[ -z "$TYPE" ]]; then
  echo "Usage: droyd-wallets-pnl-leaders.sh <type> [sort_type] [limit] [chain]" >&2
  echo "  type: yesterday, today, 1W" >&2
  echo "  sort_type: desc (gainers), asc (losers)" >&2
  exit 1
fi

DATA=$(jq -n --arg t "$TYPE" '{type: $t}')

[[ -n "$SORT_TYPE" ]] && DATA=$(echo "$DATA" | jq --arg v "$SORT_TYPE" '. + {sort_type: $v}')
[[ -n "$LIMIT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$LIMIT" '. + {limit: $v}')
[[ -n "$CHAIN" ]] && DATA=$(echo "$DATA" | jq --arg v "$CHAIN" '. + {chain: $v}')

droyd_request "POST" "/api/v1/data/wallets/pnl-leaders" "$DATA"
