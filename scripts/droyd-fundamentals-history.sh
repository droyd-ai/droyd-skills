#!/usr/bin/env bash
# Get historical on-chain fundamentals (TVL, fees, revenue, volume) from DefiLlama
# Accepts JSON matching the /api/v1/data/fundamentals/history POST body
# Usage: droyd-fundamentals-history.sh '<json>'
# Example: droyd-fundamentals-history.sh '{"metric":"tvl","group_by":"protocol","entity_limit":10}'
# Example: droyd-fundamentals-history.sh '{"metric":"fees","categories":["DEXes"],"date_grouping":"weekly","start_date":"2025-01-01","end_date":"2025-03-01"}'

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

DATA="${1:-}"

if [[ -z "$DATA" ]]; then
  echo "Usage: droyd-fundamentals-history.sh '<json>'" >&2
  echo '  droyd-fundamentals-history.sh '\''{"metric":"tvl","group_by":"protocol","entity_limit":10}'\''' >&2
  exit 1
fi

# Validate JSON
if ! echo "$DATA" | jq empty 2>/dev/null; then
  echo "Error: Invalid JSON" >&2
  exit 1
fi

droyd_request "POST" "/api/v1/data/fundamentals/history" "$DATA"
