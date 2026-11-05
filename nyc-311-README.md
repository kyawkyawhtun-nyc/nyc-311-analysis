# NYC 311 — Damaged Tree Complaints: Who Waits Longest?

**Question:** Where in New York City do damaged-tree complaints wait the longest for service — and are the problem spots the same every year?

**Tools:** SQL (Google BigQuery), SoQL / Socrata API (NYC Open Data), spreadsheets
**Data:** NYC 311 Service Requests — 3,456,770 requests in 2024 (NYC Open Data); 2021 records in BigQuery's `bigquery-public-data.new_york_311` copy

---

## Key findings

### 1. The worst ZIP code per borough (2024, "Damaged Tree" complaints)

| Borough | Top ZIP | Complaints |
|---|---|---|
| Brooklyn | 11234 | 973 |
| Queens | 11385 | 693 |
| Staten Island | 10312 | 674 |
| Bronx | 10469 | 336 |
| Manhattan | 10031 | 112 |

### 2. Hotspots are sticky — 2021 vs 2024
Running the same top-per-borough query in BigQuery for 2021 gave: Bronx 10465, Brooklyn **11234**, Manhattan **10031**, Queens **11385**, Staten Island 10314.
**Three of the five boroughs have the exact same worst ZIP in both years.** Damaged-tree complaints follow trees, not people — the same neighborhoods keep reporting the most damage.

### 3. Speed follows damage already done
By complaint descriptor (closed cases, 2024):
- Slowest: **"Tree Alive – in Poor Condition" — 129.6 days** average on Staten Island
- Fastest: **"Entire Tree Has Fallen Down" — 36.1 days**

Staten Island is the slowest borough overall (18.5 days average across all complaint types). The pattern is the same citywide: a tree already on the ground gets cleared quickly; a tree that is dying but still standing waits.

### 4. Volume is seasonal, speed never recovers (Staten Island)
June surges to 841 Damaged Tree cases vs ~110–210 in winter months — but resolution time never drops below ~36 days in any month, and is worst in September (91.2 days). The queue is seasonal on volume, chronic on speed.

### 5. Raw counts mislead — per-capita flips the ranking
Ranked by complaints per 1,000 residents instead of raw counts, Staten Island's order changes completely: 10308 leads, then 10312, with 10306 third. Raw-count rankings mostly reflect where the people (and trees) are.

---

## How I checked my work
- **Two platforms, same answer:** queried the live NYC Open Data API (SoQL) and BigQuery independently and cross-checked the results.
- **"No data" debugging:** when a query returned zero rows, I verified (a) whether the data exists in that table at all — the BigQuery copy is frozen at 2021 (last modified Nov 9, 2021), so a 2024 filter returns nothing — and (b) whether the spelling was exact — a misspelled "Damaged Tree" silently returns zero rows.
- **Top-per-group in SQL:** used a CTE with `ROW_NUMBER() OVER (PARTITION BY borough ORDER BY n DESC)` to get the #1 ZIP per borough in one query (see `queries.sql`).

## Files
- `queries.sql` — the BigQuery SQL used for the top-per-borough analysis
- Data sources: [NYC Open Data — 311 Service Requests](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9) · BigQuery public dataset `bigquery-public-data.new_york_311`
