#!/usr/bin/env bash
# Browse prediction markets across Polymarket and Kalshi
# Accepts JSON matching the /api/v1/prediction-markets/markets/get POST body
# Usage: droyd-pm-browse.sh '<json>'
# Example: droyd-pm-browse.sh '{"venue":"polymarket","sort":"volume","limit":25,"live":true}'
# Example: droyd-pm-browse.sh '{"sort":"liquidity","limit":50,"min_price":0.1,"max_price":0.9}'

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

DATA="${1:-}"

if [[ -z "$DATA" ]]; then
  echo "Usage: droyd-pm-browse.sh '<json>'" >&2
  echo '  droyd-pm-browse.sh '\''{"venue":"polymarket","sort":"volume","limit":25,"live":true}'\''' >&2
  exit 1
fi

# Validate JSON
if ! echo "$DATA" | jq empty 2>/dev/null; then
  echo "Error: Invalid JSON" >&2
  exit 1
fi

droyd_request "POST" "/api/v1/prediction-markets/markets/get" "$DATA"
