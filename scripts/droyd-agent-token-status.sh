#!/usr/bin/env bash
# Get agent token pool state, fee balances, and migration status
# Usage: droyd-agent-token-status.sh <agent_id>
# Example: droyd-agent-token-status.sh "123"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

AGENT_ID="${1:-}"

if [[ -z "$AGENT_ID" ]]; then
  echo "Usage: droyd-agent-token-status.sh <agent_id>" >&2
  exit 1
fi

droyd_request "GET" "/api/v1/agent-token/status?agent_id=$AGENT_ID"
