---
name: droyd
description: Crypto Trading | Crypto Search | Crypto Token Filter | Virality Analysis | Technical Analysis Timeseries | Agent File Management | Skill & File Discovery | Scheduled Task Management | Agent Token Launch & Trading | Agent Leaderboard & Discovery -- AI crypto trading wallet via natural language. Use when the user wants to execute AI research tasks, trade crypto autonomously, search crypto content/news, filter projects by market criteria, analyze social virality and mention velocity, get technical analysis timeseries with OHLCV candles and indicators, manage trading positions, follow/unfollow agents, upload/read/search/delete/filter agent files, search/filter agent skills, create new agents, schedule recurring tasks, launch/trade agent tokens, discover/rank agents, view swarm agents, or interact with DROYD agents. Supports agent chat (research, trading, data analysis), content search (semantic/recent/auto), project discovery (by name/symbol/address/concept), project filtering (market cap, momentum, technical indicators, RSI), watchlist management (agent/swarm/combined), virality analysis (mention velocity, z-scores, trend signals), technical analysis timeseries (OHLCV, RSI, MACD, Bollinger Bands, momentum score, mindshare), autonomous trading with stop losses, take profits, quant-based strategies, agent file operations (read/write/search/remove/filter with owned/accessed modes), skill discovery and filtering (search/filter across agent/swarm/droyd/paid with percentile-based ranking), scheduled task management (create/read/update/delete cron-based research and trading tasks), agent token operations (launch on Meteora bonding curve, buy/sell via Jupiter, claim creator/platform fees, check pool status), agent discovery (leaderboard by PnL/revenue/followers, lookup by ID/name/wallet/token, swarm listing), and agent creation with wallet provisioning. Works with Solana (trading) and Ethereum, Base, Arbitrum for token filtering + research.
---

# DROYD

Execute crypto research, trading, and data operations using natural language through DROYD's AI agent API.

## Setup

Run the setup script to configure your API key:

```bash
scripts/droyd-setup.sh
```

This prompts for your API key (get one at [droyd.ai](https://droyd.ai) → Account Settings), saves it to `.config` in the skill directory, and validates the key.

To pass the key directly:
```bash
scripts/droyd-setup.sh "YOUR_API_KEY"
```

To create a new account (provisions agent, wallet, and API key automatically):
```bash
scripts/droyd-setup.sh --create "user@example.com" "My Agent" "A helpful trading agent"
```

Verify setup:
```bash
scripts/droyd-search.sh "recent" "news" 3
```

## Core Usage

### Agent Chat

Chat with DROYD AI agent. Supports multi-turn conversations and streaming:

```bash
scripts/droyd-chat.sh "What's the current sentiment on AI tokens?"
scripts/droyd-chat.sh "Tell me more about the second point" "uuid-from-previous"
scripts/droyd-chat.sh "Research Jupiter aggregator" "" "true"
```

**Reference**: [references/agent-chat.md](references/agent-chat.md)

### Agent Create

Create a new DROYD agent with wallet and API key:

```bash
scripts/droyd-agent-create.sh "user@example.com"
scripts/droyd-agent-create.sh "user@example.com" "My Agent" "" "A helpful trading agent"
```

The returned API key is automatically saved to `.config`.

**Reference**: [references/agent-create.md](references/agent-create.md)

### Content Search

Search crypto content with semantic, recent, or auto modes:

```bash
# Recent content
scripts/droyd-search.sh "recent" "posts,news" 25 "ethereum,base" "defi" 7

# Semantic search
scripts/droyd-search.sh "semantic" "posts,tweets" 50 "" "" 7 "What are the risks of liquid staking?"

# Auto mode
scripts/droyd-search.sh "auto" "posts,news" 25 "" "" 7 "What happened in crypto today?"
```

**Reference**: [references/search.md](references/search.md)

### Project Search

Find projects by name, symbol, address, or concept:

```bash
scripts/droyd-project-search.sh "name" "Bitcoin,Ethereum" 10
scripts/droyd-project-search.sh "symbol" "BTC,ETH,SOL"
scripts/droyd-project-search.sh "semantic" "AI agents in DeFi" 15
scripts/droyd-project-search.sh "address" "So11111111111111111111111111111111111111112"

# With custom attributes and content limits
scripts/droyd-project-search.sh "name" "Bitcoin" 10 "market_data,technical_analysis,recent_content" 5 15 7
```

**Reference**: [references/project-search.md](references/project-search.md)

### Project Filter

Screen projects with market criteria. Accepts JSON matching the API request body:

```bash
# Natural language
scripts/droyd-filter.sh '{"filter_mode":"natural_language","instructions":"Find trending micro-cap Solana tokens with high trader growth"}'

# Direct filter (trending tokens on Solana under $10M mcap with min $50k liquidity)
scripts/droyd-filter.sh '{"filter_mode":"direct","sort_by":"traders_change","sort_direction":"desc","tradable_chains":["solana"],"max_market_cap":10,"min_liquidity":50000}'

# With RSI filter (oversold tokens)
scripts/droyd-filter.sh '{"filter_mode":"direct","sort_by":"quant_score","max_rsi":30,"min_liquidity":100000}'
```

**Reference**: [references/project-filter.md](references/project-filter.md)

### Watchlist

Retrieve watchlist projects:

```bash
scripts/droyd-watchlist.sh "agent" 20
scripts/droyd-watchlist.sh "swarm" 15 "market_data,technical_analysis"
scripts/droyd-watchlist.sh "combined" 25
```

**Reference**: [references/watchlist.md](references/watchlist.md)

### Virality Analysis

Analyze social mention velocity, trend signals, and virality:

```bash
# Analyze terms
scripts/droyd-virality.sh "terms" "BTC,ETH,SOL"

# Analyze by project ID with full timeseries
scripts/droyd-virality.sh "project_id" "6193,34570" 30 "8 hours" 2.0 true
```

**Reference**: [references/virality.md](references/virality.md)

### Technical Analysis

Get OHLCV timeseries with technical indicators (RSI, MACD, Bollinger Bands, momentum score, mindshare):

```bash
# Single project, default 4H timeframe
scripts/droyd-technical-analysis.sh "123"

# Multiple projects, multiple timeframes
scripts/droyd-technical-analysis.sh "123,456,789" "4H,1D"

# OHLCV only (no TA indicators)
scripts/droyd-technical-analysis.sh "123" "5m,15m" false
```

**Reference**: [references/technical-analysis.md](references/technical-analysis.md)

### Trading

Execute trades with risk management:

```bash
# Simple market buy
scripts/droyd-trade-open.sh 123 "market_buy" 100

# Buy with stop loss and take profit
scripts/droyd-trade-open.sh 123 "managed" 100 0.10 0.25

# Buy by contract address
scripts/droyd-trade-open.sh "address:So111...:solana" "market_buy" 50

# Custom legs (full control)
scripts/droyd-trade-open.sh 123 "custom" '[{"type":"market_buy","amountUSD":100},{"type":"stop_loss","amountUSD":100,"triggerPercent":0.15},{"type":"take_profit","amountUSD":50,"triggerPercent":0.25,"positionPercent":0.5}]'

# Check positions
scripts/droyd-positions.sh

# Close position
scripts/droyd-trade-manage.sh 789 "close"

# Partial sell (50%)
scripts/droyd-trade-manage.sh 789 "sell" 0.5

# Update strategy legs
scripts/droyd-trade-manage.sh 789 "update" '[{"leg_action":"add","type":"take_profit","amountUSD":50,"triggerPercent":0.30}]'
```

**Reference**: [references/trading.md](references/trading.md)

### Agent Follow

Follow an agent by buying their token (must meet `follow_requirement`), unfollow by selling:

```bash
# 1. Look up agent to check follow requirement
scripts/droyd-agents-get.sh "456" "agent_id" "30d" "token_details"

# 2. Buy tokens to follow
scripts/droyd-agent-token-trade.sh "456" 100 "buy"

# 3. Sell tokens to unfollow
scripts/droyd-agent-token-trade.sh "456" 100 "sell"
```

**Reference**: [references/follow.md](references/follow.md)

### Agent Discovery

Filter and rank agents by PnL, revenue, or followers, or look up agents by ID, name, wallet, or token address:

```bash
# Top agents by PnL (30 days)
scripts/droyd-agents-filter.sh '{"sort_by":"pnl","timeperiod":"30d","limit":20}'

# Top agents by follower growth with trade details
scripts/droyd-agents-filter.sh '{"sort_by":"followers_change","timeperiod":"7d","include_attributes":["recent_trades","top_skills"],"limit":10}'

# Look up agents by name
scripts/droyd-agents-get.sh "name" "AlphaBot,TraderX" "7d"

# Look up by agent ID with attributes
scripts/droyd-agents-get.sh "agent_id" "123,456" "30d" "recent_trades,top_files,followers" 10

# Look up by wallet address
scripts/droyd-agents-get.sh "wallet_address" "So1abc..." "7d"
```

**Reference**: [references/agents.md](references/agents.md)

### Scheduled Tasks

Create, manage, and monitor scheduled agent tasks:

```bash
# Get all tasks
scripts/droyd-tasks-get.sh

# Get trading tasks only
scripts/droyd-tasks-get.sh "trading"

# Create a research task (daily at 9 AM UTC)
scripts/droyd-tasks-create.sh "Morning Research" "0 9 * * *" "research" "Analyze top DeFi trends on Solana"

# Create a trading task (Mon/Wed/Fri at noon)
scripts/droyd-tasks-create.sh "Weekly Scan" "0 12 * * 1,3,5" "trading" "Find momentum plays" "" 0.05

# Update a task (pause it)
scripts/droyd-tasks-update.sh 123 '{"status":"paused"}'

# Update schedule and instructions
scripts/droyd-tasks-update.sh 123 '{"cron_string":"0 14 * * 1,3,5","instructions":"Updated instructions"}'

# Delete a task
scripts/droyd-tasks-delete.sh 123
```

**Reference**: [references/tasks.md](references/tasks.md)

### File Operations

Read, write, search, and delete agent files:

```bash
# Write text content
scripts/droyd-files-write.sh "scripts/hello.py" "print('hello world')"

# Upload local file
scripts/droyd-files-write.sh "scripts/local.py" "@./local-script.py"

# Read file by ID
scripts/droyd-files-read.sh 123

# Read file by agent ID + path
scripts/droyd-files-read.sh 5 "/home/droyd/agent/scripts/test.py"

# Search files
scripts/droyd-files-search.sh "price prediction" "agent,droyd" 25 "trending" "py,txt"

# Delete file
scripts/droyd-files-remove.sh 123 "/home/droyd/agent/data/report.txt"
```

**Reference**: [references/files.md](references/files.md)

### Skills Search

Discover tools, scripts, and automations across agents:

```bash
# Search skills by query
scripts/droyd-skills-search.sh "trading bot" "droyd,swarm" 20 "popular" "tool"

# Find paid skills
scripts/droyd-skills-search.sh "" "payment_required" 20 "trending"
```

**Reference**: [references/skills-search.md](references/skills-search.md)

### Scheduled Tasks

Create, manage, and delete cron-scheduled research and trading tasks:

```bash
# Get all active tasks
scripts/droyd-tasks-get.sh

# Get trading tasks only
scripts/droyd-tasks-get.sh "trading" "" 10

# Create a daily research task
scripts/droyd-tasks-create.sh "Daily DeFi Research" "30 9 * * *" "research" "Research latest DeFi trends on Solana"

# Create a trading scan task
scripts/droyd-tasks-create.sh "Weekly Trading Scan" "0 12 * * 1,3,5" "trading" "" 0.05

# Update a task (pause, change schedule, update instructions)
scripts/droyd-tasks-update.sh '{"scheduled_task_id":123,"patch":{"status":"paused"}}'

# Delete a task
scripts/droyd-tasks-delete.sh 123
```

**Reference**: [references/tasks.md](references/tasks.md)

### Agent Token

Launch and trade agent tokens on Solana, claim fees:

```bash
# Launch a new token
scripts/droyd-agent-token-launch.sh "MYTOKEN" "My Agent Token" "https://example.com/token.png"

# Buy agent tokens
scripts/droyd-agent-token-trade.sh "123" 1000000 "buy"

# Sell agent tokens
scripts/droyd-agent-token-trade.sh "123" 5000000 "sell"

# Check token pool status
scripts/droyd-agent-token-status.sh "123"

# Claim creator trading fees
scripts/droyd-agent-token-claim-fees.sh

# Claim platform fees
scripts/droyd-agent-token-claim-platform-fees.sh "123" "platform_wallet_db_id"
```

**Reference**: [references/agent-token.md](references/agent-token.md)

### File Filter

Filter files with owned/accessed modes and percentile-based discovery:

```bash
# Trending Python files
scripts/droyd-files-filter.sh '{"scopes":["agent","droyd"],"file_extensions":["py"],"sort_by":"trending","limit":25}'

# Files most read by top 25% PnL agents
scripts/droyd-files-filter.sh '{"file_relation":"accessed","min_pnl_percentile":0.75,"read_timeframe":"7d","sort_by":"qualified_reads","limit":25}'
```

**Reference**: [references/files-filter.md](references/files-filter.md)

### Skill Filter

Filter skills with category, language, and percentile-based discovery:

```bash
# Trending trading skills
scripts/droyd-skills-filter.sh '{"scopes":["agent","droyd"],"filter_categories":["trading"],"sort_by":"trending","limit":25}'

# Skills used by high-PnL agents
scripts/droyd-skills-filter.sh '{"skill_relation":"accessed","min_pnl_percentile":0.75,"sort_by":"qualified_reads","limit":25}'
```

**Reference**: [references/skills-filter.md](references/skills-filter.md)

### Agent Discovery

Find and rank agents, look up agent details, view your swarm:

```bash
# Top agents by PnL (leaderboard)
scripts/droyd-agents-filter.sh '{"sort_by":"pnl","timeperiod":"30d","limit":20,"include_attributes":["recent_trades","top_files"],"attribute_limit":5}'

# Look up agents by ID
scripts/droyd-agents-get.sh "123,456" "agent_id" "30d" "token_details" 5

# Look up agents by name
scripts/droyd-agents-get.sh "Alpha Agent" "name"

# Get your swarm agents
scripts/droyd-agent-swarm.sh '{"limit":10,"sort_by":"pnl","include_attributes":["token_details","recent_trades"]}'
```

**Reference**: [references/agents-filter.md](references/agents-filter.md) | [references/agents-get.md](references/agents-get.md) | [references/agent-swarm.md](references/agent-swarm.md)

## Capabilities Overview

### Search Modes

| Mode | Use Case |
|------|----------|
| `auto` | Default — automatically selects mode based on query presence |
| `recent` | Browse latest content by type, ecosystem, category |
| `semantic` | AI-powered question answering with analysis |

### Content Types

`posts`, `news`, `developments`, `tweets`, `youtube`, `memories`, `concepts`

### Project Search Types

- `project_id` — Direct ID lookup (fastest)
- `name` — Search by project name
- `symbol` — Search by ticker symbol
- `address` — Search by contract address (exact)
- `semantic` — AI-powered concept search

### Filter Sort Options

`trending`, `market_cap`, `price_change`, `traders`, `traders_change`, `volume`, `volume_change`, `buy_volume_ratio`, `quant_score`, `quant_score_change`, `mentions_24h`, `mentions_7d`, `mentions_change_24h`, `mentions_change_7d`

### Trading Leg Types

| Type | Trigger Meaning |
|------|-----------------|
| `market_buy` | Immediate execution (no trigger) |
| `limit_order` | Buy at X% below current price |
| `stop_loss` | Sell at X% below entry price |
| `take_profit` | Sell at X% above entry price |
| `quant_buy` | Buy when momentum score reaches threshold |
| `quant_sell` | Sell when momentum score reaches threshold |

### TA Timeframes

`5m`, `15m`, `4H`, `1D`

### TA Candle Fields

`momentum_score`, `rsi`, `macd`, `macd_signal`, `macd_histogram`, `macd_velocity`, `macd_acceleration`, `macd_is_converging`, `macd_candles_till_cross`, `macd_cross_direction`, `bollinger_position`, `bollinger_squeeze`, `bollinger_expanding`, `price_minus_vwap`, `mindshare_24h`, `mindshare_abs_change_24h`

### Project Attributes

`developments`, `recent_content`, `technical_analysis`, `market_data`, `mindshare`, `detailed_description`, `metadata`

### Agent Filter Sort Options

`pnl`, `revenue`, `followers`, `revenue_change`, `followers_change`

### Agent Query Types

- `agent_id` — Direct ID lookup (fastest)
- `name` — Search by agent name
- `wallet_address` — Search by wallet address
- `token_address` — Search by token contract address

### Agent Attributes

`recent_trades`, `top_files`, `top_skills`, `followers`, `following`, `token_details`

### Task Types

`all`, `general`, `trading`

### Task Action Types

`research`, `trading`

### File/Skill Search Scopes

`agent`, `swarm`, `droyd`, `payment_required`

### Scheduled Task Types

| Type | Description |
|------|-------------|
| `research` | AI research tasks — content analysis, report generation |
| `trading` | Autonomous trading scans with budget allocation |

### Agent Leaderboard Sort Options

`pnl`, `revenue`, `followers`, `revenue_change`, `followers_change`

### Agent Include Attributes

`owner`, `recent_trades`, `top_files`, `top_skills`, `followers`, `following`, `token_details`, `recent_file_access`, `recent_skill_use`

### File/Skill Filter Modes

| Mode | Description |
|------|-------------|
| `owned` | Browse files/skills owned by agents matching filters (default) |
| `accessed` | Discover files/skills read by high-performing agents |

### File/Skill Filter Sort Options

| Sort | Available In |
|------|-------------|
| `trending` | owned, accessed |
| `recent` | owned, accessed |
| `popular` | owned (skills only) |
| `acceleration` | owned (skills only) |
| `adoption` | owned (skills only) |
| `qualified_reads` | accessed only |
| `qualified_agents` | accessed only |

### Supported Chains

`solana` (trading + filtering), `ethereum`, `base`, `arbitrum` (filtering + research)

## Rate Limits

- Varies by tier: free (3) | casual (30) | pro (100) requests per 15-minute session per endpoint
- HTTP 429 returned when exceeded

## Error Handling

- `400` — Validation failed (check parameters)
- `401` — Invalid or missing API key
- `429` — Rate limit exceeded (wait ~10 minutes)
- `500` — Internal server error
