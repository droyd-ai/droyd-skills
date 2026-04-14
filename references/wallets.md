# Wallet Analytics

Analyze wallet PnL by token, smart money flows, and top PnL traders across chains.

## Endpoints

- `POST /api/v1/data/wallets/pnl-details` - Wallet PnL broken down by token
- `POST /api/v1/data/wallets/smart-money` - Smart money token list
- `POST /api/v1/data/wallets/pnl-leaders` - Top PnL gainers and losers

---

## Wallet PnL Details

`POST /api/v1/data/wallets/pnl-details`

Retrieve PnL of a Solana wallet broken down by token. Each token can be enriched with Droyd project intelligence via `include_attributes`.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `wallet` | string | Yes | - | Solana wallet address |
| `token_addresses` | string[] | No | - | Filter to specific token addresses (max 100) |
| `duration` | string | No | `all` | `24h`, `7d`, `30d`, `90d`, `all` |
| `sort_type` | string | No | `desc` | Sort direction: `asc`, `desc` |
| `sort_by` | string | No | `last_trade` | Sort field |
| `limit` | number | No | `10` | Max tokens to return (1-100) |
| `offset` | number | No | `0` | Pagination offset (0-10000) |
| `include_attributes` | string[] | No | `[]` | `project_description`, `recent_content`, `technical_analysis`, `mindshare`, `developments` |
| `recent_content_limit` | number | No | `10` | Max content items when `recent_content` is included |
| `recent_content_days_back` | number | No | `30` | Days back for content lookback |

### Examples

**Basic wallet PnL:**
```bash
scripts/droyd-wallets-pnl.sh "5Q544fKrFoe6tsEbD7S8EmxGTJYAKtTVhAW5Q5pge4j1"
```

**With enrichment attributes:**
```bash
scripts/droyd-wallets-pnl.sh "5Q544fKrFoe6tsEbD7S8EmxGTJYAKtTVhAW5Q5pge4j1" "30d" 20 "technical_analysis,mindshare"
```

### Response

```json
{
  "success": true,
  "data": {
    "tokens": [
      {
        "symbol": "JUP",
        "address": "JUPyiwrYJFskUPiHa7hkeR8VUtAeFoSYbKedZNsDvCN",
        "counts": { "total_buy": 5, "total_sell": 3, "total_trade": 8 },
        "pnl": { "realized_profit_usd": 130.90, "realized_profit_percent": 30.86, "total_usd": 130.90 },
        "project_id": 1234,
        "technical_analysis": { "momentum_score": 62, "rsi": 55.3 },
        "mindshare": { "total_mentions": 142, "mindshare_pct": 0.8 }
      }
    ],
    "summary": {
      "unique_tokens": 7,
      "counts": { "total_buy": 19, "total_sell": 19, "win_rate": 0.57 },
      "pnl": { "realized_profit_usd": 130.90, "realized_profit_percent": 30.86 }
    }
  }
}
```

---

## Smart Money Token List

`POST /api/v1/data/wallets/smart-money`

Returns tokens identified via smart money traders, segmented by trader risk level. Each token is enriched with Droyd project data when a matching project is found.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `interval` | string | No | `7d` | `1d`, `7d`, `30d` |
| `trader_risk_level` | string | No | `all` | `all`, `low`, `medium`, `high` |
| `sort_by` | string | No | `net_flow` | `net_flow`, `smart_traders_no`, `market_cap` |
| `sort_type` | string | No | `desc` | `asc`, `desc` |
| `offset` | number | No | `0` | Pagination offset (0-10000) |
| `limit` | number | No | `10` | Max tokens (1-20) |
| `include_attributes` | string[] | No | `["developments", "mindshare", "market_data"]` | `developments`, `recent_content`, `technical_analysis`, `market_data`, `mindshare`, `detailed_description`, `metadata` |
| `recent_content_limit` | number | No | `5` | Max content items per project (1-25) |
| `recent_content_days_back` | number | No | `7` | Content lookback days (1-30) |

### Risk Levels

| Level | Birdeye Trader Style | Description |
|-------|---------------------|-------------|
| `low` | Risk averse | Conservative traders |
| `medium` | Risk balancers | Moderate risk traders |
| `high` | Trenchers | Aggressive degen traders |

### Examples

**High-risk smart money by net flow:**
```bash
scripts/droyd-wallets-smart-money.sh '{"interval":"7d","trader_risk_level":"high","sort_by":"net_flow","limit":10}'
```

**With enrichment attributes:**
```bash
scripts/droyd-wallets-smart-money.sh '{"interval":"1d","sort_by":"smart_traders_no","include_attributes":["market_data","technical_analysis","mindshare"]}'
```

### Response

```json
{
  "success": true,
  "projects": [
    {
      "project_id": 1234,
      "project_name": "Jupiter",
      "symbol": "JUP",
      "smart_money": {
        "token_address": "JUPyiwrYJFskUPiHa7hkeR8VUtAeFoSYbKedZNsDvCN",
        "net_flow": 520000,
        "smart_traders_no": 42,
        "trader_style": "trenchers",
        "volume_usd": 45000000
      },
      "market_data": { ... },
      "mindshare": { ... }
    }
  ]
}
```

---

## PnL Leaders

`POST /api/v1/data/wallets/pnl-leaders`

Retrieve the top PnL gainers or losers across wallets. Supports daily, yesterday, and weekly timeframes with multi-chain support.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `type` | string | Yes | - | `yesterday`, `today`, `1W` |
| `sort_type` | string | No | `desc` | `desc` (gainers), `asc` (losers) |
| `limit` | number | No | `10` | Max results (1-10) |
| `offset` | number | No | `0` | Pagination offset (0-10000) |
| `chain` | string | No | `solana` | Blockchain network (solana, ethereum, base, arbitrum, bsc, polygon, etc.) |

### Examples

**Today's top gainers:**
```bash
scripts/droyd-wallets-pnl-leaders.sh "today"
```

**Weekly losers on Ethereum:**
```bash
scripts/droyd-wallets-pnl-leaders.sh "1W" "asc" 10 "ethereum"
```

### Response

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "network": "solana",
        "address": "FciNKwZAvSzepKH1nFEGeejzbP4k87dJiP9BAzGt2Sm3",
        "pnl": 675542.13,
        "trade_count": 74194,
        "volume": 1372626.71
      }
    ]
  }
}
```

---

## Notes

- PnL Details and Smart Money are Solana-only
- PnL Leaders supports all major chains
- `project_id` is always included on wallet tokens — null if no Droyd project match found
- The `recent_content` attribute incurs additional x402 cost
- PnL Leaders max 10 results per request (Birdeye API limit)
