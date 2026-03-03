#!/usr/bin/env bash
# Launch a new agent token on Meteora bonding curve
# Usage: droyd-agent-token-launch.sh <symbol> <name> <image_uri>
# Example: droyd-agent-token-launch.sh "MYTOKEN" "My Agent Token" "https://example.com/token.png"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

SYMBOL="${1:-}"
NAME="${2:-}"
IMAGE_URI="${3:-}"

if [[ -z "$SYMBOL" || -z "$NAME" || -z "$IMAGE_URI" ]]; then
  echo "Usage: droyd-agent-token-launch.sh <symbol> <name> <image_uri>" >&2
  exit 1
fi

DATA=$(jq -n --arg symbol "$SYMBOL" --arg name "$NAME" --arg image_uri "$IMAGE_URI" \
  '{symbol: $symbol, name: $name, image_uri: $image_uri}')

droyd_request "POST" "/api/v1/agent-token/launch" "$DATA"
