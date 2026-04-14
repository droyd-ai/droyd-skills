#!/usr/bin/env bash
# Get current on-chain fundamentals with change percentages across timeframes
# Accepts JSON matching the /api/v1/data/fundamentals/snapshot POST body
# Usage: droyd-fundamentals-snapshot.sh '<json>'
# Example: droyd-fundamentals-snapshot.sh '{"metrics":["tvl","fees","revenue"],"group_by":"protocol","timeframes":["7d","30d"],"entity_limit":25}'
# Example: droyd-fundamentals-snapshot.sh '{"metrics":["tvl"],"categories":["DEXes","Lending"],"entity_limit":10}'

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

DATA="${1:-}"

if [[ -z "$DATA" ]]; then
  echo "Usage: droyd-fundamentals-snapshot.sh '<json>'" >&2
  echo '  droyd-fundamentals-snapshot.sh '\''{"metrics":["tvl","fees","revenue"],"group_by":"protocol","entity_limit":25}'\''' >&2
  exit 1
fi

# Validate JSON
if ! echo "$DATA" | jq empty 2>/dev/null; then
  echo "Error: Invalid JSON" >&2
  exit 1
fi

droyd_request "POST" "/api/v1/data/fundamentals/snapshot" "$DATA"
