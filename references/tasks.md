# Scheduled Tasks

Create, manage, and monitor scheduled agent tasks with cron-based scheduling.

## Endpoints

- `POST /api/v1/tasks/get` or `GET /api/v1/tasks/get` - Get scheduled tasks
- `POST /api/v1/tasks/create` - Create a scheduled task
- `POST /api/v1/tasks/update` - Update a scheduled task
- `POST /api/v1/tasks/delete` - Delete a scheduled task

---

## Get Scheduled Tasks

`POST /api/v1/tasks/get` or `GET /api/v1/tasks/get`

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `task_types` | string | No | `all` | `all`, `general`, or `trading` |
| `scheduled_task_ids` | number[] | No | - | Fetch specific tasks by ID |
| `limit` | number | No | `50` | Max results (1-100) |

### Examples

```bash
# Get all active tasks
scripts/droyd-tasks-get.sh

# Get trading tasks only
scripts/droyd-tasks-get.sh "trading"

# Get specific tasks by ID
scripts/droyd-tasks-get.sh "" "123,456" 10
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

---

## Create Scheduled Task

`POST /api/v1/tasks/create`

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `task_title` | string | Yes | - | Task title (1-200 chars) |
| `cron_string` | string | Yes | - | Cron schedule (e.g. `"30 9 * * *"`) |
| `action_type` | string | No | `research` | `research` or `trading` |
| `instructions` | string | Conditional | - | Task instructions (1-5000 chars). Required for research tasks. |
| `notification_destinations` | string[] | No | `[]` | Notification channels |
| `portfolio_budget_percent` | number | No | - | Budget allocation for trading (0-1) |

### Examples

```bash
# Create a daily research task
scripts/droyd-tasks-create.sh "Morning Research" "0 9 * * *" "research" "Analyze top DeFi trends on Solana"

# Create a trading task
scripts/droyd-tasks-create.sh "Weekly Scan" "0 12 * * 1,3,5" "trading" "Find momentum plays" "" 0.05

# Simple research task (action_type defaults to research)
scripts/droyd-tasks-create.sh "Evening Report" "0 18 * * *" "" "Summarize daily crypto news"
```

### Response (201)

```json
{
  "success": true,
  "data": {
    "scheduled_task_id": 123,
    "owner_id": 1,
    "agent_id": 5,
    "task_title": "Morning Research",
    "action_type": "research",
    "instructions": "Analyze top DeFi trends on Solana",
    "status": "active",
    "cron_string": "0 9 * * *",
    "schedule_id": "sched_abc123"
  }
}
```

---

## Update Scheduled Task

`POST /api/v1/tasks/update`

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `scheduled_task_id` | number | Yes | ID of the task to update |
| `patch` | object | Yes | Fields to update (at least one required) |

### Patch Fields

| Field | Type | Description |
|-------|------|-------------|
| `task_title` | string | Task title (1-200 chars) |
| `instructions` | string | Task instructions (1-5000 chars) |
| `status` | string | `active` or `paused` |
| `action_type` | string | `research` or `trading` |
| `cron_string` | string | New cron schedule |
| `notification_destinations` | string[] | Notification channels |
| `portfolio_budget_percent` | number | Budget allocation (0-1) |

### Examples

```bash
# Update instructions
scripts/droyd-tasks-update.sh 123 '{"instructions":"Research DeFi trends on Solana and Base"}'

# Pause a task
scripts/droyd-tasks-update.sh 123 '{"status":"paused"}'

# Resume and change schedule
scripts/droyd-tasks-update.sh 123 '{"status":"active","cron_string":"0 14 * * 1,3,5"}'
```

### Response

```json
{
  "success": true,
  "data": {
    "scheduled_task_id": 123,
    "task_title": "Morning Research",
    "status": "active",
    "cron_string": "0 14 * * 1,3,5"
  }
}
```

---

## Delete Scheduled Task

`POST /api/v1/tasks/delete`

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

---

## Cron String Reference

| Expression | Meaning |
|-----------|---------|
| `0 9 * * *` | Daily at 9:00 AM UTC |
| `30 9 * * *` | Daily at 9:30 AM UTC |
| `0 */4 * * *` | Every 4 hours |
| `0 12 * * 1,3,5` | Mon/Wed/Fri at noon UTC |
| `0 0 * * 1` | Weekly on Monday at midnight UTC |
| `0 0 1 * *` | Monthly on the 1st at midnight UTC |

## Notes

- Only active tasks are returned by the get endpoint
- `general` maps to research-type tasks internally
- Task creation is subject to plan limits (free: 1, pro: 10 active tasks)
- Returns `403` if the task limit is reached
- Pausing a task removes its schedule; resuming recreates it
- Deleting performs a soft delete (sets status to `cancelled`)
