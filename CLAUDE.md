
## Repo Background

This is a Claude Code skill for interacting with the DROYD AI agent API. It provides natural language interfaces for crypto research, trading, and data operations.

## Key Files

- `SKILL.md` - Main skill documentation and usage guide
- `scripts/` - Bash scripts for all API endpoints
- `references/` - Detailed API reference documentation
- `.api_docs.md` - Comprehensive API documentation

## Key Notes
- We do NOT want to expose `/api/v1/agent/task` (task execution) or `/api/v1/agent/task/events` (task event stream) — those are internal agent runtime endpoints. The `/api/v1/tasks/*` endpoints (get, create, update, delete) are user-facing scheduled task CRUD and ARE exposed.
