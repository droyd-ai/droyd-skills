#!/usr/bin/env bash
# Buy or sell an agent's token via Jupiter
# Usage: droyd-agent-token-trade.sh <agent_id> <amount> <action> [base_token]
# Actions: buy, sell
# Base token: SOL (default), USDC
# Example: droyd-agent-token-trade.sh "123" 1000000 "buy"
# Example: droyd-agent-token-trade.sh "123" 5000000 "sell"
# Example: droyd-agent-token-trade.sh "123" 1000000 "buy" "USDC"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

AGENT_ID="${1:-}"
AMOUNT="${2:-}"
ACTION="${3:-}"
BASE_TOKEN="${4:-}"

if [[ -z "$AGENT_ID" || -z "$AMOUNT" || -z "$ACTION" ]]; then
  echo "Usage: droyd-agent-token-trade.sh <agent_id> <amount> <action> [base_token]" >&2
  echo "  action: buy or sell" >&2
  echo "  base_token: SOL (default) or USDC" >&2
  exit 1
fi

if [[ "$ACTION" != "buy" && "$ACTION" != "sell" ]]; then
  echo "Error: action must be 'buy' or 'sell'" >&2
  exit 1
fi

DATA=$(jq -n --arg agent_id "$AGENT_ID" --argjson amount "$AMOUNT" --arg action "$ACTION" \
  '{agent_id: $agent_id, amount: $amount, action: $action}')

[[ -n "$BASE_TOKEN" ]] && DATA=$(echo "$DATA" | jq --arg v "$BASE_TOKEN" '. + {base_token: $v}')

droyd_request "POST" "/api/v1/agent-token/trade" "$DATA"
