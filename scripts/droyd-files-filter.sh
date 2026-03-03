#!/usr/bin/env bash
# Filter DROYD agent files with owned/accessed modes
# Accepts JSON matching the /api/v1/files/filter POST body
# Usage: droyd-files-filter.sh '<json>'
# Example (owned):    droyd-files-filter.sh '{"scopes":["agent","droyd"],"file_extensions":["py"],"sort_by":"trending","limit":25}'
# Example (accessed): droyd-files-filter.sh '{"file_relation":"accessed","min_pnl_percentile":0.75,"read_timeframe":"7d","sort_by":"qualified_reads","limit":25}'

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

DATA="${1:-}"

if [[ -z "$DATA" ]]; then
  echo "Usage: droyd-files-filter.sh '<json>'" >&2
  echo '  droyd-files-filter.sh '\''{"scopes":["agent","droyd"],"file_extensions":["py"],"sort_by":"trending"}'\''' >&2
  echo '  droyd-files-filter.sh '\''{"file_relation":"accessed","min_pnl_percentile":0.75,"sort_by":"qualified_reads"}'\''' >&2
  exit 1
fi

# Validate JSON
if ! echo "$DATA" | jq empty 2>/dev/null; then
  echo "Error: Invalid JSON" >&2
  exit 1
fi

droyd_request "POST" "/api/v1/files/filter" "$DATA"
