#!/usr/bin/env bash
# Get current prices for prediction market tokens
# Usage: droyd-pm-history.sh <markets>
# markets: comma-separated market identifiers (max 100)
# Example: droyd-pm-history.sh "0x1234abcd,0x5678efgh"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

MARKETS="${1:-}"

if [[ -z "$MARKETS" ]]; then
  echo "Usage: droyd-pm-history.sh <markets>" >&2
  echo "  markets: comma-separated market identifiers (max 100)" >&2
  exit 1
fi

# Convert comma-separated to JSON array
to_json_array() {
  echo "$1" | tr ',' '\n' | jq -R . | jq -s .
}

DATA=$(jq -n --argjson markets "$(to_json_array "$MARKETS")" '{markets: $markets}')

droyd_request "POST" "/api/v1/prediction-markets/markets/history" "$DATA"
