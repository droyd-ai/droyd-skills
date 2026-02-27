#!/usr/bin/env bash
# Filter and rank DROYD agents by PnL, revenue, or followers
# Accepts JSON matching the /api/v1/agents/filter POST body
# Usage: droyd-agents-filter.sh '<json>'
# Example: droyd-agents-filter.sh '{"sort_by":"pnl","timeperiod":"7d","limit":20}'
# Example: droyd-agents-filter.sh '{"sort_by":"followers_change","timeperiod":"30d","include_attributes":["recent_trades","top_skills"]}'

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

DATA="${1:-}"

if [[ -z "$DATA" ]]; then
  echo "Usage: droyd-agents-filter.sh '<json>'" >&2
  echo '  droyd-agents-filter.sh '\''{"sort_by":"pnl","timeperiod":"7d","limit":20}'\''' >&2
  echo '  droyd-agents-filter.sh '\''{"sort_by":"followers_change","include_attributes":["recent_trades"]}'\''' >&2
  exit 1
fi

# Validate JSON
if ! echo "$DATA" | jq empty 2>/dev/null; then
  echo "Error: Invalid JSON" >&2
  exit 1
fi

droyd_request "POST" "/api/v1/agents/filter" "$DATA"
