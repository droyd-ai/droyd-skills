# Agent Token Operations

Launch, trade, and manage agent tokens on Solana. Tokens are created as SPL tokens on Meteora's Dynamic Bonding Curve and auto-migrate to Meteora DAMM v2 at graduation.

---

## Launch Token

`POST /api/v1/agent-token/launch`

Launch a new agent token on Meteora bonding curve.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `symbol` | string | Yes | Token ticker (e.g. "MYTOKEN") |
| `name` | string | Yes | Token display name |
| `image_uri` | string | Yes | URI to token image/metadata |

### Examples

```bash
scripts/droyd-agent-token-launch.sh "MYTOKEN" "My Agent Token" "https://example.com/token.png"
```

### Response (201)

```json
{
  "success": true,
  "data": {
    "launch_status": "success",
    "tx_signature": "5abc123...",
    "token_mint": "So1...",
    "pool_address": "Pool1...",
    "token_name": "My Agent Token",
    "token_symbol": "MYTOKEN",
    "token_image_uri": "https://example.com/token.png"
  }
}
```

### Notes

- Agent must not already have a token launched
- Token is created on Solana as an SPL token
- Pool starts on bonding curve, auto-migrates to DAMM v2 at graduation

---

## Trade Token

`POST /api/v1/agent-token/trade`

Buy or sell an agent's token via Jupiter DEX aggregator.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `agent_id` | string | Yes | - | Target agent whose token is being traded |
| `amount` | number | Yes | - | Token amount in UI format (e.g. 100000 = 100k tokens) |
| `action` | string | Yes | - | `buy` or `sell` |
| `base_token` | string | No | `SOL` | Base token for swap: `SOL` or `USDC` |

### Examples

```bash
# Buy tokens with SOL
scripts/droyd-agent-token-trade.sh "123" 1000000 "buy"

# Sell tokens
scripts/droyd-agent-token-trade.sh "123" 5000000 "sell"

# Buy with USDC
scripts/droyd-agent-token-trade.sh "123" 1000000 "buy" "USDC"
```

### Response (201)

```json
{
  "success": true,
  "data": {
    "trade_status": "success",
    "tx_signature": "5abc123...",
    "tx_confirmation": "confirmed",
    "action": "buy",
    "token": "So1...",
    "amount": 1000000
  }
}
```

### Notes

- Target agent must have a launched token
- For buys, system estimates SOL/USDC input with 5% overshoot to ensure target amount is met
- For sells, `amount` is the exact number of agent tokens to sell
- Gas is sponsored by the platform

---

## Claim Creator Fees

`POST /api/v1/agent-token/claim-fees`

Claim accumulated trading fees, migration fees, and surplus tokens from your agent's bonding curve pool. No parameters needed — agent derived from API key.

### Examples

```bash
scripts/droyd-agent-token-claim-fees.sh
```

### Response

```json
{
  "success": true,
  "data": {
    "claim_status": "success",
    "tx_signature": "5abc123...",
    "migration_fee_signature": null,
    "surplus_signature": null,
    "fees": {
      "base": "1000000",
      "quote": "500000000"
    },
    "pool_state": {
      "is_migrated": false,
      "migration_progress": 0.45
    }
  }
}
```

### Notes

- Returns `claim_status: "no_fees"` if nothing to claim
- Creator receives 60% of bonding curve trading fees
- After pool migration, also claims one-time migration fee and surplus tokens

---

## Claim Platform Fees

`POST /api/v1/agent-token/claim-platform-fees`

Claim platform's accumulated trading fees from an agent's bonding curve pool.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `agent_id` | string | Yes | Agent identifier |
| `platform_wallet_id` | string | Yes | Database wallet ID of the platform wallet |

### Examples

```bash
scripts/droyd-agent-token-claim-platform-fees.sh "123" "platform_wallet_db_id"
```

### Notes

- Platform receives 40% of bonding curve trading fees
- After migration, also claims one-time migration fee (50% split) and surplus tokens

---

## Token Status

`GET /api/v1/agent-token/status`

Get current pool state, fee balances, migration status, and claim flags for an agent's token.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `agent_id` | string | Yes | Agent identifier (query param) |

### Examples

```bash
scripts/droyd-agent-token-status.sh "123"
```

### Response

```json
{
  "success": true,
  "data": {
    "pool_state": {
      "is_migrated": false,
      "migration_progress": 0.45,
      "curve_progress": 0.67
    },
    "fees": {
      "creator": { "unclaimed_base": "1000000", "unclaimed_quote": "500000000" },
      "partner": { "unclaimed_base": "400000", "unclaimed_quote": "300000000" },
      "total": { "base": "1400000", "quote": "800000000" }
    },
    "migration_claims": {
      "creator_migration_fee_claimed": false,
      "partner_migration_fee_claimed": false,
      "creator_surplus_claimed": false,
      "partner_surplus_claimed": false
    },
    "addresses": {
      "primary_pool": "Pool1...",
      "bonding_curve_pool": "Pool1...",
      "damm_pool": null,
      "token": "So1..."
    }
  }
}
```

### Notes

- Read-only endpoint — no transactions executed
- `curve_progress` (0-1) shows proximity to DAMM v2 graduation
- Fee amounts are stringified BN values (base = agent token, quote = SOL)

---

## Fee Structure

| Recipient | Trading Fees | Migration Fee | Surplus |
|-----------|-------------|--------------|---------|
| Creator | 60% | 50% | 50% |
| Platform | 40% | 50% | 50% |
