# On-Chain Fundamentals

Historical and current on-chain fundamentals (TVL, fees, revenue, volume) sourced from DefiLlama.

## Endpoints

- `POST /api/v1/data/fundamentals/history` - Historical fundamentals timeseries
- `POST /api/v1/data/fundamentals/snapshot` - Current fundamentals with change percentages

---

## Fundamentals History

`POST /api/v1/data/fundamentals/history`

Get historical on-chain fundamentals with daily, weekly, or monthly granularity. Supports grouping by protocol, chain, or category.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `metric` | string | Yes | - | `tvl`, `fees`, `revenue`, or `volume` |
| `ecosystem_ids` | number[] | No | - | Filter by ecosystem IDs |
| `project_ids` | number[] | No | - | Filter by project IDs |
| `categories` | string[] | No | - | Filter by categories (e.g., `DEXes`, `Lending`) |
| `group_by` | string | No | `protocol` | `protocol`, `chain`, or `category` |
| `date_grouping` | string | No | `daily` | `daily`, `weekly`, or `monthly` |
| `start_date` | string | No | 30 days ago | Start date (YYYY-MM-DD) |
| `end_date` | string | No | today | End date (YYYY-MM-DD) |
| `entity_limit` | number | No | `10` | Max entities to return (1-50) |

### Examples

**Top protocols by TVL:**
```bash
scripts/droyd-fundamentals-history.sh '{"metric":"tvl","group_by":"protocol","entity_limit":10}'
```

**Weekly DEX fees over a date range:**
```bash
scripts/droyd-fundamentals-history.sh '{"metric":"fees","categories":["DEXes"],"date_grouping":"weekly","start_date":"2025-01-01","end_date":"2025-03-01"}'
```

### Response

```json
{
  "success": true,
  "data_source": "defi_llama",
  "data": [
    {
      "entity_name": "Aave",
      "entity_id": 123,
      "date": "2025-03-01",
      "value": 12500000000.50
    }
  ],
  "metadata": {
    "metric": "tvl",
    "group_by": "protocol",
    "date_grouping": "daily",
    "entity_limit": 10,
    "total_periods": 30
  }
}
```

---

## Fundamentals Snapshot

`POST /api/v1/data/fundamentals/snapshot`

Get current on-chain fundamentals with change percentages across multiple timeframes.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `metrics` | string[] | No | all | `tvl`, `fees`, `revenue` (omit for all) |
| `ecosystem_ids` | number[] | No | - | Filter by ecosystem IDs |
| `project_ids` | number[] | No | - | Filter by project IDs |
| `categories` | string[] | No | - | Filter by categories (e.g., `DEXes`, `Lending`) |
| `group_by` | string | No | `protocol` | `protocol`, `chain`, or `category` |
| `timeframes` | string[] | No | `["7d", "30d"]` | `1d`, `7d`, `30d`, `90d`, `180d`, `1y` |
| `entity_limit` | number | No | `25` | Max entities to return (1-100) |

### Examples

**Protocol snapshot with all metrics:**
```bash
scripts/droyd-fundamentals-snapshot.sh '{"metrics":["tvl","fees","revenue"],"group_by":"protocol","timeframes":["7d","30d"],"entity_limit":25}'
```

**Lending protocols only:**
```bash
scripts/droyd-fundamentals-snapshot.sh '{"metrics":["tvl"],"categories":["Lending"],"entity_limit":10}'
```

### Response

```json
{
  "success": true,
  "data_source": "defi_llama",
  "data": [
    {
      "entity_name": "Aave",
      "entity_id": 123,
      "tvl": 12500000000,
      "fees": 850000,
      "revenue": 425000,
      "changes": {
        "tvl_7d": 5.2,
        "tvl_30d": 12.8,
        "fees_7d": -2.1,
        "fees_30d": 8.5
      }
    }
  ]
}
```

---

## Notes

- Data sourced from DefiLlama, refreshed twice daily, cached 20 minutes
- Rate limits: 30 requests per 15 minutes (API/Casual), 100 (Pro)
- All endpoints support x402 pay-per-request pricing
