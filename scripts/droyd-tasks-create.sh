#!/usr/bin/env bash
# Create a DROYD scheduled task
# Usage: droyd-tasks-create.sh <title> <cron> [action_type] [instructions] [notifications] [budget_pct]
# Action types: research (default), trading
# Example: droyd-tasks-create.sh "Morning Research" "0 9 * * *" "research" "Analyze top DeFi trends"
# Example: droyd-tasks-create.sh "Weekly Scan" "0 12 * * 1,3,5" "trading" "Find momentum plays" "" 0.05

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

TITLE="${1:-}"
CRON="${2:-}"
ACTION_TYPE="${3:-research}"
INSTRUCTIONS="${4:-}"
NOTIFICATIONS="${5:-}"
BUDGET_PCT="${6:-}"

if [[ -z "$TITLE" || -z "$CRON" ]]; then
  echo "Usage: droyd-tasks-create.sh <title> <cron> [action_type] [instructions] [notifications] [budget_pct]" >&2
  echo "Action types: research (default), trading" >&2
  exit 1
fi

# Convert comma-separated to JSON array
to_json_array() {
  echo "$1" | tr ',' '\n' | jq -R . | jq -s .
}

DATA=$(jq -n \
  --arg title "$TITLE" \
  --arg cron "$CRON" \
  --arg action "$ACTION_TYPE" \
  '{task_title: $title, cron_string: $cron, action_type: $action}')

[[ -n "$INSTRUCTIONS" ]] && DATA=$(echo "$DATA" | jq --arg v "$INSTRUCTIONS" '. + {instructions: $v}')
[[ -n "$NOTIFICATIONS" ]] && DATA=$(echo "$DATA" | jq --argjson v "$(to_json_array "$NOTIFICATIONS")" '. + {notification_destinations: $v}')
[[ -n "$BUDGET_PCT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$BUDGET_PCT" '. + {portfolio_budget_percent: $v}')

droyd_request "POST" "/api/v1/tasks/create" "$DATA"
