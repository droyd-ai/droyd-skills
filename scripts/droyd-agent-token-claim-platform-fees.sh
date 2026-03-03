#!/usr/bin/env bash
# Claim platform trading fees from agent token bonding curve
# Usage: droyd-agent-token-claim-platform-fees.sh <agent_id> <platform_wallet_id>
# Example: droyd-agent-token-claim-platform-fees.sh "123" "platform_wallet_db_id"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

AGENT_ID="${1:-}"
PLATFORM_WALLET_ID="${2:-}"

if [[ -z "$AGENT_ID" || -z "$PLATFORM_WALLET_ID" ]]; then
  echo "Usage: droyd-agent-token-claim-platform-fees.sh <agent_id> <platform_wallet_id>" >&2
  exit 1
fi

DATA=$(jq -n --arg agent_id "$AGENT_ID" --arg wallet_id "$PLATFORM_WALLET_ID" \
  '{agent_id: $agent_id, platform_wallet_id: $wallet_id}')

droyd_request "POST" "/api/v1/agent-token/claim-platform-fees" "$DATA"
