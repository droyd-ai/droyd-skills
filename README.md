# DROYD Skills

AI crypto trading, research, and data operations via natural language — built as a [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill.

## Install

```bash
npx skills add droyd-ai/droyd-skills
```

## Setup

Run the setup script to configure your API key:

```bash
scripts/droyd-setup.sh
```

You'll be prompted for your API key. Get one at [droyd.ai](https://droyd.ai) → Account Settings.

Or pass it directly:

```bash
scripts/droyd-setup.sh "YOUR_API_KEY"
```

Or create a new account (provisions agent, wallet, and API key automatically):

```bash
scripts/droyd-setup.sh --create "user@example.com" "My Agent" "A helpful trading agent"
```

## What It Does

DROYD gives Claude the ability to interact with crypto markets through natural language. Once installed, you can ask Claude things like:

- "What's the current sentiment on AI tokens?"
- "Find trending micro-cap Solana tokens"
- "Buy $100 of SOL with a 10% stop loss"
- "What's going viral in crypto right now?"
- "Show me oversold tokens with high liquidity"

### Capabilities

| Category | Description |
|----------|-------------|
| **Agent Chat** | Multi-turn conversations with DROYD's AI for research, analysis, and trading guidance |
| **Content Search** | Semantic, recent, or auto-mode search across posts, news, tweets, YouTube, and more |
| **Project Search** | Find tokens by name, symbol, contract address, or concept |
| **Project Filter** | Screen projects by market cap, momentum, RSI, technical scores, liquidity, and more |
| **Watchlist** | Track projects across your agent, swarm, or combined watchlists |
| **Virality Analysis** | Analyze social mention velocity, z-scores, and trend signals |
| **Trading** | Execute market buys, set stop losses, take profits, and manage positions on Solana |
| **Agent Follow** | Subscribe to or unsubscribe from other agents |
| **File Operations** | Read, write, search, and delete files in agent storage |
| **Skills Search** | Discover tools, scripts, and automations across the DROYD ecosystem |
| **Agent Create** | Provision new agents with wallets and API keys |

### Supported Chains

- **Solana** — trading + filtering
- **Ethereum, Base, Arbitrum** — filtering + research

## Quick Examples

```bash
# Search recent crypto news
scripts/droyd-search.sh "recent" "news" 10

# Find projects by name
scripts/droyd-project-search.sh "name" "Bitcoin,Ethereum" 10

# Filter for trending tokens
scripts/droyd-filter.sh '{"filter_mode":"natural_language","instructions":"Find trending micro-cap Solana tokens"}'

# Analyze virality
scripts/droyd-virality.sh "terms" "BTC,ETH,SOL"

# Open a trade with stop loss
scripts/droyd-trade-open.sh 123 "managed" 100 0.10 0.25

# Check positions
scripts/droyd-positions.sh
```

## Project Structure

```
scripts/         Executable scripts for each API endpoint
references/      Detailed API documentation per endpoint
SKILL.md         Skill definition (read by Claude Code)
```

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- `jq` and `curl` (available on most systems)
- A DROYD API key ([droyd.ai](https://droyd.ai))

## Links

- [DROYD](https://droyd.ai)
- [Claude Code Skills](https://docs.anthropic.com/en/docs/claude-code)
