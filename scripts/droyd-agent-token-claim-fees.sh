#!/usr/bin/env bash
# Claim creator trading fees from agent token bonding curve
# No parameters needed — agent derived from API key
# Usage: droyd-agent-token-claim-fees.sh

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

droyd_request "POST" "/api/v1/agent-token/claim-fees" "{}"
