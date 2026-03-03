# Scheduled Tasks

Create, read, update, and delete scheduled tasks. Tasks run on cron schedules and can perform research or trading actions automatically.

---

## Get Tasks

`POST /api/v1/tasks/get` or `GET /api/v1/tasks/get`

Retrieve scheduled tasks for your agent. Returns active tasks with recent execution history.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `task_types` | string | No | `all` | Filter: `all`, `general`, or `trading` |
| `scheduled_task_ids` | number[] | No | - | Fetch specific tasks by ID |
| `limit` | number | No | `50` | Max tasks to return (1-100) |

### Examples

```bash
# Get all active tasks
scripts/droyd-tasks-get.sh

# Get trading tasks only
scripts/droyd-tasks-get.sh "trading"

# Get specific tasks by ID
scripts/droyd-tasks-get.sh "" "123,456"

# Get general tasks, limited to 10
scripts/droyd-tasks-get.sh "general" "" 10
```

### Response

```json
{
  "success": true,
  "data": [
    {
      "scheduled_task_id": 123,
      "task_title": "Daily DeFi Research",
      "status": "active",
      "action_type": "research",
      "instructions": "Research the latest DeFi trends on Solana",
      "cron_string": "30 9 * * *",
      "notification_destinations": [],
      "default_strategy_legs": null,
      "portfolio_budget_percent": null,
      "recent_tasks": [
        {
          "completed_at": "2025-01-15T09:35:00Z",
          "task_title": "Daily DeFi Research",
          "result_summary": "Found 5 trending protocols..."
        }
      ]
    }
  ]
}
```

### Notes

- Only returns active tasks
- `general` maps to research-type tasks internally
- Response includes compact task config + recent execution summaries

---

## Create Task

`POST /api/v1/tasks/create`

Create a new scheduled task with a cron schedule.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `task_title` | string | Yes | - | Task title (1-200 characters) |
| `cron_string` | string | Yes | - | Cron schedule (e.g. `"30 9 * * *"`) |
| `action_type` | string | No | `research` | `research` or `trading` |
| `instructions` | string | Conditional | - | Task instructions (1-5000 chars). Required for research, optional for trading |
| `notification_destinations` | string[] | No | `[]` | Notification channels |
| `portfolio_budget_percent` | number | No | - | Portfolio budget allocation (0-1, trading tasks) |
| `default_strategy_legs` | object | No | - | Default trading strategy legs |

### Examples

```bash
# Daily research task
scripts/droyd-tasks-create.sh "Daily DeFi Research" "30 9 * * *" "research" "Research latest DeFi trends on Solana"

# Trading scan on weekdays
scripts/droyd-tasks-create.sh "Weekly Trading Scan" "0 12 * * 1,3,5" "trading" "" 0.05

# Minimal research task (defaults to research type)
scripts/droyd-tasks-create.sh "Morning Briefing" "0 8 * * *" "" "Summarize overnight crypto developments"
```

### Response (201)

```json
{
  "success": true,
  "data": {
    "scheduled_task_id": 123,
    "owner_id": 1,
    "agent_id": 5,
    "task_title": "Daily DeFi Research",
    "action_type": "research",
    "instructions": "Research latest DeFi trends...",
    "status": "active",
    "cron_string": "30 9 * * *",
    "schedule_id": "sched_abc123"
  }
}
```

### Notes

- Task creation is subject to plan limits (free: 1, pro: 10 active tasks)
- Returns `403` if task limit reached
- Trading tasks get default strategy legs and instructions if not provided
- Tasks begin executing at the next scheduled time

---

## Update Task

`POST /api/v1/tasks/update`

Update properties of an existing scheduled task.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `scheduled_task_id` | number | Yes | ID of the task to update |
| `patch` | object | Yes | Fields to update (at least one required) |

### Patch Fields

| Field | Type | Description |
|-------|------|-------------|
| `task_title` | string | Task title (1-200 characters) |
| `instructions` | string | Task instructions (1-5000 characters) |
| `status` | string | `active` or `paused` |
| `action_type` | string | `research` or `trading` |
| `cron_string` | string | Cron schedule expression |
| `notification_destinations` | string[] | Notification channels |
| `portfolio_budget_percent` | number | Portfolio budget (0-1) |
| `default_strategy_legs` | object | Trading strategy legs |

### Examples

```bash
# Pause a task
scripts/droyd-tasks-update.sh 123 '{"status":"paused"}'

# Resume and change schedule
scripts/droyd-tasks-update.sh 123 '{"status":"active","cron_string":"0 14 * * 1,3,5"}'

# Update instructions
scripts/droyd-tasks-update.sh 123 '{"instructions":"Research DeFi trends on Solana and Base"}'
```

### Notes

- Changing `cron_string` automatically updates the schedule
- Pausing removes the schedule; resuming recreates it
- Returns `404` if the task doesn't exist or doesn't belong to your agent

---

## Delete Task

`POST /api/v1/tasks/delete`

Soft-delete a scheduled task.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `scheduled_task_id` | number | Yes | ID of the task to delete |

### Examples

```bash
scripts/droyd-tasks-delete.sh 123
```

### Response

```json
{
  "success": true
}
```

### Notes

- Performs soft delete (sets status to `cancelled`)
- Automatically removes the associated schedule
- Returns `404` if the task doesn't exist or doesn't belong to your agent

---

## Task Types

| Type | Description |
|------|-------------|
| `research` | AI research tasks — content analysis, report generation |
| `trading` | Autonomous trading scans with budget allocation |

## Common Cron Patterns

| Pattern | Schedule |
|---------|----------|
| `0 9 * * *` | Daily at 9:00 UTC |
| `30 9 * * *` | Daily at 9:30 UTC |
| `0 */4 * * *` | Every 4 hours |
| `0 12 * * 1,3,5` | Mon/Wed/Fri at 12:00 UTC |
| `0 8 * * 1-5` | Weekdays at 8:00 UTC |
| `0 0 * * 0` | Weekly on Sunday at midnight |
| `0 0 1 * *` | Monthly on the 1st at midnight UTC |
