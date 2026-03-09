# [Metric Name] — Metric Spec

**Author:** Farid
**Created:** YYYY-MM-DD
**Last Updated:** YYYY-MM-DD
**Metric ID:** [e.g., permits_monthly_count]

---

## Metric Name

**Name:** [Short, snake_case identifier]
**One-liner:** [One sentence describing what this metric measures.]

---

## Purpose

[What question does this metric answer? What decision would someone make with it?]

**Example:**
> How many permits were issued per planning district per month, to track construction activity over time?

---

## Numerator / Denominator

**Numerator:** [What is being counted or summed in the top of the calculation. Write N/A if this is a simple count with no ratio.]

**Denominator:** [What the numerator is divided by. Write N/A if this metric is not a rate or ratio.]

---

## Formula

```
[metric_name] = [formula expressed clearly, e.g. COUNT(permit_id) or numerator / denominator]
```

**Aggregation type:** [additive / semi-additive / non-additive]
**SQL sketch (optional):**
```sql
-- Example:
SELECT
    district_key,
    date_month_key,
    COUNT(permit_id) AS permits_monthly_count
FROM fact_permits
GROUP BY district_key, date_month_key
```

---

## Grain

**Grain statement:** One row per [unit] per [time period].

**Example:**
> One row per planning district per calendar month.

---

## Dimensions

[What dimensions can this metric be sliced or filtered by?]

| Dimension | Table | Notes |
|-----------|-------|-------|
| [e.g., Planning District] | [e.g., dim_district] | [e.g., 18 districts; conformed] |
| [e.g., Month] | [e.g., dim_date] | [e.g., joined via EOY date surrogate for year-grain] |
| [e.g., Permit Type] | [e.g., dim_permit_type] | |

---

## Source Tables

| Table | Role | Key Fields Used |
|-------|------|-----------------|
| [e.g., fact_permits] | [e.g., primary fact source] | [e.g., permit_id, issue_date, district_key] |
| [e.g., dim_district] | [e.g., district lookup] | [e.g., district_key, district_name] |

---

## Test Ideas

[How would you verify this metric is calculating correctly? List lightweight checks.]

- [ ] [e.g., Sum across all districts equals citywide total]
- [ ] [e.g., No district has a negative count]
- [ ] [e.g., No nulls in district_key or date_month_key]
- [ ] [e.g., Row count matches expected grain (one row per district × month)]

---

## Caveats / Limitations

[What should users know before interpreting this metric? What could mislead them?]

- [e.g., Counts reflect permit issuance date, not construction completion]
- [e.g., Permits cancelled after issuance are still counted]
- [e.g., District boundaries reflect current vintage; historical comparisons may be affected by boundary changes]

---

## Links

**Related Metrics:**
- [Link to related metric specs if applicable]

**Source Specs:**
- [Grain spec]: [`docs/modeling/grain_spec.md`](../modeling/grain_spec.md)
- [Table inventory]: [`docs/modeling/table_inventory.md`](../modeling/table_inventory.md)

---

## Change Log

| Date       | Change Description          | Author |
|------------|-----------------------------|--------|
| YYYY-MM-DD | Initial spec created        | Farid  |