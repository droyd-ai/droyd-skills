#!/usr/bin/env bash
# Look up agents by ID, name, wallet address, or token address
# Usage: droyd-agents-get.sh <queries> [query_type] [timeperiod] [include_attributes] [attribute_limit]
# query_type: agent_id (default), name, wallet_address, token_address
# timeperiod: 1d, 7d, 30d (default)
# include_attributes: comma-separated (e.g. "recent_trades,token_details")
# Example: droyd-agents-get.sh "123,456"
# Example: droyd-agents-get.sh "Alpha Agent" "name"
# Example: droyd-agents-get.sh "123" "agent_id" "30d" "token_details,recent_trades" 5

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

QUERIES="${1:-}"
QUERY_TYPE="${2:-}"
TIMEPERIOD="${3:-}"
INCLUDE_ATTRS="${4:-}"
ATTR_LIMIT="${5:-}"

if [[ -z "$QUERIES" ]]; then
  echo "Usage: droyd-agents-get.sh <queries> [query_type] [timeperiod] [include_attributes] [attribute_limit]" >&2
  echo "  query_type: agent_id (default), name, wallet_address, token_address" >&2
  exit 1
fi

# Convert comma-separated to JSON string array
to_json_array() {
  echo "$1" | tr ',' '\n' | jq -R . | jq -s .
}

# Build request
DATA=$(jq -n --argjson queries "$(to_json_array "$QUERIES")" '{queries: $queries}')

[[ -n "$QUERY_TYPE" ]] && DATA=$(echo "$DATA" | jq --arg v "$QUERY_TYPE" '. + {query_type: $v}')
[[ -n "$TIMEPERIOD" ]] && DATA=$(echo "$DATA" | jq --arg v "$TIMEPERIOD" '. + {timeperiod: $v}')
[[ -n "$INCLUDE_ATTRS" ]] && DATA=$(echo "$DATA" | jq --argjson v "$(to_json_array "$INCLUDE_ATTRS")" '. + {include_attributes: $v}')
[[ -n "$ATTR_LIMIT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$ATTR_LIMIT" '. + {attribute_limit: $v}')

droyd_request "POST" "/api/v1/agents/get" "$DATA"
