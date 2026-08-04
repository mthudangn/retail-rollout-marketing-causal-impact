# Data

`sample_store_panel.csv` is a synthetic panel included only to verify that the pipeline runs end to end.

The production workflow expects one row per store and year with the following columns:

- `store_id`
- `province`
- `year`
- `sales`
- `treated`

Raw case-study store data are intentionally not distributed in this repository. This keeps the analytical code reusable and avoids publishing source material with uncertain redistribution rights.
