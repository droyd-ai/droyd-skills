# Prediction Markets

Browse, search, and analyze prediction markets across Polymarket and Kalshi. Get event news, related markets, current prices, and leaderboards.

## Endpoints

- `POST /api/v1/prediction-markets/markets/get` - Browse markets
- `POST /api/v1/prediction-markets/markets/search` - Search markets by query
- `POST /api/v1/prediction-markets/markets/news` - Get event news
- `POST /api/v1/prediction-markets/markets/related` - Get related markets
- `POST /api/v1/prediction-markets/markets/history` - Get market prices
- `POST /api/v1/prediction-markets/leaderboard` - Leaderboard

---

## Browse Markets

`POST /api/v1/prediction-markets/markets/get`

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `venue` | string | No | - | `polymarket` or `kalshi` |
| `sort` | string | No | - | `liquidity`, `volume`, `created_at`, `ends_at`, `newest` |
| `order` | string | No | - | `ASC` or `DESC` |
| `limit` | number | No | `100` | Results per page (1-250) |
| `offset` | number | No | `0` | Pagination offset (0-10000) |
| `min_price` | number | No | - | Minimum market price (0-1) |
| `max_price` | number | No | - | Maximum market price (0-1) |
| `min_ends_at` | string | No | - | Minimum end date (ISO 8601) |
| `max_ends_at` | string | No | - | Maximum end date (ISO 8601) |
| `rewards` | boolean | No | - | Only reward markets (Polymarket only) |
| `live` | boolean | No | - | Only live markets |
| `bonds` | boolean | No | - | Only bond markets |
| `tags` | string | No | - | Comma-separated tag filter |
| `include_markets` | boolean | No | `true` | Include market details per event |

### Examples

**Browse live markets by volume:**
```bash
scripts/droyd-pm-browse.sh '{"venue":"polymarket","sort":"volume","limit":25,"live":true}'
```

**Filter by price range:**
```bash
scripts/droyd-pm-browse.sh '{"sort":"liquidity","limit":50,"min_price":0.1,"max_price":0.9}'
```

### Response

Returns events with nested market details from both Polymarket and Kalshi.

---

## Search Markets

`POST /api/v1/prediction-markets/markets/search`

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `query` | string | Yes | - | Search text query |
| `venue` | string | No | - | `polymarket` or `kalshi` |
| `labels` | string | No | - | Comma-separated label filter |
| `min_price` | number | No | - | Minimum market price (0-1) |
| `max_price` | number | No | - | Maximum market price (0-1) |
| `rewards` | boolean | No | - | Only reward markets (Polymarket only) |
| `live` | boolean | No | - | Only live markets |
| `sort` | string | No | - | `liquidity`, `volume`, `closes_soon`, `probability`, `newest` |
| `limit` | number | No | `25` | Results per page (1-100) |
| `offset` | number | No | `0` | Pagination offset (0-10000) |

### Examples

**Search for bitcoin markets:**
```bash
scripts/droyd-pm-search.sh "bitcoin price" "polymarket" "volume" 10
```

**Search live markets only:**
```bash
scripts/droyd-pm-search.sh "ethereum" "" "" 25 true
```

---

## Event News

`POST /api/v1/prediction-markets/markets/news`

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `event_id` | string | Yes | - | Event ID to fetch news for |
| `limit` | number | No | `10` | Articles to return (1-100) |
| `offset` | number | No | `0` | Pagination offset (0-10000) |

### Examples

```bash
scripts/droyd-pm-news.sh "12345"
scripts/droyd-pm-news.sh "12345" 20
```

### Response

Returns news articles with source, description, URL, and match scores.

---

## Related Markets

`POST /api/v1/prediction-markets/markets/related`

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `slug` | string | Yes | - | Market or event identifier (slug, market ID, or event ID) |
| `limit` | number | No | `20` | Events to return (1-100) |
| `offset` | number | No | `0` | Pagination offset (0-10000) |

### Examples

```bash
scripts/droyd-pm-related.sh "will-bitcoin-hit-100k-2025"
scripts/droyd-pm-related.sh "will-bitcoin-hit-100k-2025" 10
```

---

## Market Prices

`POST /api/v1/prediction-markets/markets/history`

Get current prices for prediction market tokens by market ID. Supports batch lookups of up to 100 markets.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `markets` | string[] | Yes | - | Market identifiers (max 100) |

### Examples

```bash
scripts/droyd-pm-history.sh "0x1234abcd,0x5678efgh"
```

### Response

Polymarket returns a single number per market. Kalshi returns an object with Yes/No outcomes (e.g., `{"Yes": 0.58, "No": 0.42}`).

---

## Leaderboard

`POST /api/v1/prediction-markets/leaderboard`

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `venue` | string | No | `both` | `polymarket`, `kalshi`, or `both` |
| `limit` | number | No | `50` | Entries per venue (1-100) |
| `offset` | number | No | `0` | Pagination offset (0-10000) |
| `polymarket_time_period` | string | No | `month` | `day`, `week`, `month`, `all` |
| `polymarket_order_by` | string | No | `PNL` | `PNL` or `VOL` |
| `kalshi_metric` | string | No | `volume` | Kalshi leaderboard metric |
| `kalshi_since` | number | No | `30` | Kalshi days of history (1-365) |

### Examples

**Top traders by PnL:**
```bash
scripts/droyd-pm-leaderboard.sh '{"venue":"both","limit":25,"polymarket_time_period":"month","polymarket_order_by":"PNL"}'
```

**Kalshi only, last week:**
```bash
scripts/droyd-pm-leaderboard.sh '{"venue":"kalshi","limit":50,"kalshi_since":7}'
```

### Response

```json
{
  "success": true,
  "polymarket": [
    { "rank": 1, "username": "trader1", "xUsername": "@trader1", "volume": 1500000, "pnl": 250000, "profileImage": "..." }
  ],
  "kalshi": [
    { "rank": 1, "username": "trader2", "volume": 800000, "profit": 120000 }
  ]
}
```

---

## Notes

- All endpoints support both POST and GET methods
- Rate limits: 60 requests per 15 minutes (API/Casual), 200 (Pro)
- All endpoints support x402 pay-per-request pricing
