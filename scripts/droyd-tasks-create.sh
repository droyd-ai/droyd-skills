#!/usr/bin/env bash
# Create a scheduled task with cron schedule
# Usage: droyd-tasks-create.sh <task_title> <cron_string> [action_type] [instructions] [portfolio_budget_percent]
# action_type: research (default), trading
# Example: droyd-tasks-create.sh "Daily DeFi Research" "30 9 * * *" "research" "Research latest DeFi trends on Solana"
# Example: droyd-tasks-create.sh "Weekly Trading Scan" "0 12 * * 1,3,5" "trading" "" 0.05

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/droyd.sh"

TITLE="${1:-}"
CRON="${2:-}"
ACTION_TYPE="${3:-}"
INSTRUCTIONS="${4:-}"
BUDGET_PCT="${5:-}"

if [[ -z "$TITLE" || -z "$CRON" ]]; then
  echo "Usage: droyd-tasks-create.sh <task_title> <cron_string> [action_type] [instructions] [portfolio_budget_percent]" >&2
  echo "  action_type: research (default), trading" >&2
  exit 1
fi

# Build request with required fields
DATA=$(jq -n --arg title "$TITLE" --arg cron "$CRON" \
  '{task_title: $title, cron_string: $cron}')

[[ -n "$ACTION_TYPE" ]] && DATA=$(echo "$DATA" | jq --arg v "$ACTION_TYPE" '. + {action_type: $v}')
[[ -n "$INSTRUCTIONS" ]] && DATA=$(echo "$DATA" | jq --arg v "$INSTRUCTIONS" '. + {instructions: $v}')
[[ -n "$BUDGET_PCT" ]] && DATA=$(echo "$DATA" | jq --argjson v "$BUDGET_PCT" '. + {portfolio_budget_percent: $v}')

droyd_request "POST" "/api/v1/tasks/create" "$DATA"
