#!/usr/bin/env bash
# Get scheduled tasks
# Usage: droyd-tasks-get.sh [task_types] [ids] [limit]
# task_types: all (default), general, trading
# ids: comma-separated scheduled_task_ids
# Example: droyd-tasks-get.sh
# Example: droyd-tasks-get.sh "trading" "" 10
# Example: droyd-tasks-get.sh "" "123,456"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

TASK_TYPES="${1:-}"
IDS="${2:-}"
LIMIT="${3:-}"

# Build request
DATA=$(jq -n '{}')

[[ -n "$TASK_TYPES" ]] && DATA=$(echo "$DATA" | jq --arg v "$TASK_TYPES" '. + {task_types: $v}')
[[ -n "$IDS" ]] && DATA=$(echo "$DATA" | jq --argjson v "$(echo "$IDS" | tr ',' '\n' | jq -R 'tonumber' | jq -s .)" '. + {scheduled_task_ids: $v}')
[[ -n "$LIMIT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$LIMIT" '. + {limit: $v}')

droyd_request "POST" "/api/v1/tasks/get" "$DATA"
