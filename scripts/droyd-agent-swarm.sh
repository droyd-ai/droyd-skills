#!/usr/bin/env bash
# Get authenticated user's swarm agents
# Accepts optional JSON matching the /api/v1/agent/swarm POST body
# Usage: droyd-agent-swarm.sh ['<json>']
# Example: droyd-agent-swarm.sh
# Example: droyd-agent-swarm.sh '{"limit":10,"sort_by":"pnl","timeperiod":"30d"}'
# Example: droyd-agent-swarm.sh '{"include_attributes":["token_details","recent_trades"],"attribute_limit":5}'

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

DATA="${1:-{}}"

# Validate JSON
if ! echo "$DATA" | jq empty 2>/dev/null; then
  echo "Error: Invalid JSON" >&2
  exit 1
fi

droyd_request "POST" "/api/v1/agent/swarm" "$DATA"
