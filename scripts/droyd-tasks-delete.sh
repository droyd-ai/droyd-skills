#!/usr/bin/env bash
# Delete a DROYD scheduled task
# Usage: droyd-tasks-delete.sh <scheduled_task_id>
# Example: droyd-tasks-delete.sh 123

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

TASK_ID="${1:-}"

if [[ -z "$TASK_ID" ]]; then
  echo "Usage: droyd-tasks-delete.sh <scheduled_task_id>" >&2
  exit 1
fi

DATA=$(jq -n --argjson id "$TASK_ID" '{scheduled_task_id: $id}')

droyd_request "POST" "/api/v1/tasks/delete" "$DATA"
