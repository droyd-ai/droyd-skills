#!/usr/bin/env bash
# Update a DROYD scheduled task
# Usage: droyd-tasks-update.sh <scheduled_task_id> '<patch_json>'
# Example: droyd-tasks-update.sh 123 '{"task_title":"New Title","status":"paused"}'
# Example: droyd-tasks-update.sh 123 '{"cron_string":"0 14 * * 1,3,5","instructions":"Updated instructions"}'

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

TASK_ID="${1:-}"
PATCH="${2:-}"

if [[ -z "$TASK_ID" || -z "$PATCH" ]]; then
  echo "Usage: droyd-tasks-update.sh <scheduled_task_id> '<patch_json>'" >&2
  echo '  droyd-tasks-update.sh 123 '\''{"status":"paused"}'\''' >&2
  echo '  droyd-tasks-update.sh 123 '\''{"cron_string":"0 14 * * 1,3,5"}'\''' >&2
  exit 1
fi

# Validate patch JSON
if ! echo "$PATCH" | jq empty 2>/dev/null; then
  echo "Error: Invalid JSON patch" >&2
  exit 1
fi

DATA=$(jq -n \
  --argjson id "$TASK_ID" \
  --argjson patch "$PATCH" \
  '{scheduled_task_id: $id, patch: $patch}')

droyd_request "POST" "/api/v1/tasks/update" "$DATA"
