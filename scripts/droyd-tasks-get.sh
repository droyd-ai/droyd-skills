#!/usr/bin/env bash
# Get DROYD scheduled tasks
# Usage: droyd-tasks-get.sh [task_types] [scheduled_task_ids] [limit]
# Types: all (default), general, trading
# Example: droyd-tasks-get.sh "all" "" 50
# Example: droyd-tasks-get.sh "trading" "123,456" 10

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

TASK_TYPES="${1:-all}"
TASK_IDS="${2:-}"
LIMIT="${3:-50}"

# Convert comma-separated numbers to JSON array
to_json_num_array() {
  echo "$1" | tr ',' '\n' | jq -R 'tonumber' | jq -s .
}

DATA=$(jq -n \
  --arg types "$TASK_TYPES" \
  --argjson limit "$LIMIT" \
  '{task_types: $types, limit: $limit}')

[[ -n "$TASK_IDS" ]] && DATA=$(echo "$DATA" | jq --argjson v "$(to_json_num_array "$TASK_IDS")" '. + {scheduled_task_ids: $v}')

droyd_request "POST" "/api/v1/tasks/get" "$DATA"
