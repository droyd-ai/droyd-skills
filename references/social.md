# Social Intelligence

Discover projects mentioned by Twitter influencers and find handles discussing specific projects, ranked by relevance.

## Endpoints

- `POST /api/v1/social/top-projects-by-handle` - Projects mentioned by handles
- `POST /api/v1/social/top-handles-by-project` - Handles mentioning projects (POST only)

---

## Top Projects by Handle

`POST /api/v1/social/top-projects-by-handle`

Given an array of Twitter handles, returns projects those handles have mentioned — ranked by aggregate relevance.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `handles` | string[] | Yes | - | Twitter handles to analyze |
| `days_back` | number | No | `30` | Lookback period in days |
| `limit` | number | No | `50` | Results per page |
| `offset` | number | No | `0` | Pagination offset |
| `sort_by` | string | No | `total_relevance` | `total_relevance`, `post_count`, `avg_relevance`, `market_cap` |
| `included_attributes` | string[] | No | `[]` | `market_data`, `mindshare`, `project_info`, `token_details`, `recent_posts`, `technical_analysis` |
| `attribute_limit` | number | No | `5` | Max items per array attribute (1-25) |
| `include_retweets` | boolean | No | `true` | Whether to include retweets |
| `min_relevance` | number | No | - | Minimum relevance score threshold |

### Examples

**Projects mentioned by CT influencers:**
```bash
scripts/droyd-social-projects.sh "inversebrah,DefiIgnas,Route2FI" 30 20 "total_relevance" "market_data,mindshare,recent_posts" 3
```

**Simple lookup:**
```bash
scripts/droyd-social-projects.sh "inversebrah"
```

### Response

```json
{
  "success": true,
  "projects": [
    {
      "project_id": 123,
      "name": "Example Protocol",
      "symbol": "EXM",
      "total_relevance": 8.75,
      "post_count": 12,
      "avg_relevance": 0.73,
      "market_data": { ... },
      "mindshare": { ... },
      "recent_posts": [ ... ]
    }
  ],
  "metadata": {
    "handles": ["inversebrah", "DefiIgnas", "Route2FI"],
    "days_back": 30,
    "sort_by": "total_relevance",
    "total_results": 20
  }
}
```

---

## Top Handles by Project

`POST /api/v1/social/top-handles-by-project` (POST only)

Given an array of project IDs, returns Twitter handles that have mentioned those projects — ranked by aggregate relevance.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `project_ids` | number[] | Yes | - | Project IDs to find mentioning handles for |
| `days_back` | number | No | `30` | Lookback window in days (1-365) |
| `limit` | number | No | `50` | Max handles to return (1-100) |
| `offset` | number | No | `0` | Pagination offset |
| `sort_by` | string | No | `total_relevance` | `total_relevance`, `post_count`, `avg_relevance`, `follower_count` |
| `included_attributes` | string[] | No | `[]` | `twitter_profile`, `recent_posts`, `project_breakdown` |
| `attribute_limit` | number | No | `5` | Max items per array attribute (1-25) |
| `include_retweets` | boolean | No | `true` | Whether to include retweets |
| `person_only` | boolean | No | `true` | Filter to person-classified handles only |
| `min_relevance` | number | No | - | Minimum relevance score threshold |

### Examples

**Handles discussing a project:**
```bash
scripts/droyd-social-handles.sh "1790" 7 30 "total_relevance" true "twitter_profile,recent_posts" 5
```

**Multiple projects, include bots:**
```bash
scripts/droyd-social-handles.sh "1790,6193" 30 50 "follower_count" false
```

### Response

```json
{
  "success": true,
  "data": [
    {
      "handle": "example_user",
      "display_name": "Example User",
      "total_relevance": 45.23,
      "post_count": 12,
      "avg_relevance": 3.77,
      "avg_sentiment": 0.65,
      "twitter_profile": { "follower_count": 100000, "bio": "..." },
      "recent_posts": [{ "post_id": 123, "title": "...", "relevance_score": 8.5 }],
      "project_breakdown": [{ "project_id": 1790, "project_name": "...", "total_relevance": 45.23 }]
    }
  ]
}
```

---

## Notes

- Handles are matched case-insensitively; leading `@` is stripped automatically
- `person_only` filters to accounts classified as real people (excludes bots, projects)
- The `project_breakdown` attribute shows per-project stats when querying multiple project IDs
- Use `min_relevance` to filter out low-signal mentions
