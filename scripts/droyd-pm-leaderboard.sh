#!/usr/bin/env bash
# Get prediction market leaderboard across Polymarket and Kalshi
# Accepts JSON matching the /api/v1/prediction-markets/leaderboard POST body
# Usage: droyd-pm-leaderboard.sh '<json>'
# Example: droyd-pm-leaderboard.sh '{"venue":"both","limit":25,"polymarket_time_period":"month","polymarket_order_by":"PNL"}'
# Example: droyd-pm-leaderboard.sh '{"venue":"kalshi","limit":50,"kalshi_since":7}'

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

DATA="${1:-}"

if [[ -z "$DATA" ]]; then
  echo "Usage: droyd-pm-leaderboard.sh '<json>'" >&2
  echo '  droyd-pm-leaderboard.sh '\''{"venue":"both","limit":25,"polymarket_time_period":"month"}'\''' >&2
  exit 1
fi

# Validate JSON
if ! echo "$DATA" | jq empty 2>/dev/null; then
  echo "Error: Invalid JSON" >&2
  exit 1
fi

droyd_request "POST" "/api/v1/prediction-markets/leaderboard" "$DATA"
