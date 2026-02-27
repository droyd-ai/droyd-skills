#!/usr/bin/env bash
# Look up DROYD agents by ID, name, wallet, or token address
# Usage: droyd-agents-get.sh <query_type> <queries> [timeperiod] [attributes] [attribute_limit]
# Types: agent_id, name, wallet_address, token_address
# Example: droyd-agents-get.sh "name" "AlphaBot,TraderX" "7d"
# Example: droyd-agents-get.sh "agent_id" "123,456" "30d" "recent_trades,top_files,followers" 10

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

QUERY_TYPE="${1:-agent_id}"
QUERIES="${2:-}"
TIMEPERIOD="${3:-30d}"
ATTRIBUTES="${4:-}"
ATTR_LIMIT="${5:-}"

if [[ -z "$QUERIES" ]]; then
  echo "Usage: droyd-agents-get.sh <query_type> <queries> [timeperiod] [attributes] [attribute_limit]" >&2
  echo "Types: agent_id, name, wallet_address, token_address" >&2
  exit 1
fi

# Convert comma-separated to JSON array
to_json_array() {
  echo "$1" | tr ',' '\n' | jq -R . | jq -s .
}

DATA=$(jq -n \
  --arg type "$QUERY_TYPE" \
  --argjson queries "$(to_json_array "$QUERIES")" \
  --arg tp "$TIMEPERIOD" \
  '{query_type: $type, queries: $queries, timeperiod: $tp}')

[[ -n "$ATTRIBUTES" ]] && DATA=$(echo "$DATA" | jq --argjson v "$(to_json_array "$ATTRIBUTES")" '. + {include_attributes: $v}')
[[ -n "$ATTR_LIMIT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$ATTR_LIMIT" '. + {attribute_limit: $v}')

droyd_request "POST" "/api/v1/agents/get" "$DATA"
