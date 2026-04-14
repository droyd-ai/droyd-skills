#!/usr/bin/env bash
# Get smart money token list with project enrichment
# Accepts JSON matching the /api/v1/data/wallets/smart-money POST body
# Usage: droyd-wallets-smart-money.sh '<json>'
# Example: droyd-wallets-smart-money.sh '{"interval":"7d","trader_risk_level":"high","sort_by":"net_flow","limit":10}'
# Example: droyd-wallets-smart-money.sh '{"interval":"1d","sort_by":"smart_traders_no","include_attributes":["market_data","technical_analysis","mindshare"]}'

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

DATA="${1:-}"

if [[ -z "$DATA" ]]; then
  echo "Usage: droyd-wallets-smart-money.sh '<json>'" >&2
  echo '  droyd-wallets-smart-money.sh '\''{"interval":"7d","trader_risk_level":"high","sort_by":"net_flow","limit":10}'\''' >&2
  exit 1
fi

# Validate JSON
if ! echo "$DATA" | jq empty 2>/dev/null; then
  echo "Error: Invalid JSON" >&2
  exit 1
fi

droyd_request "POST" "/api/v1/data/wallets/smart-money" "$DATA"
