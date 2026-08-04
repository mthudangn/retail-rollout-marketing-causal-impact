# Retail Rollout Causal Impact

A reproducible R workflow for evaluating a store-within-store retail rollout using matched controls, difference-in-differences (DiD), province-adjusted regression, and profitability thresholds.

The project separates raw sales growth from incremental program impact. It estimates the treatment effect after accounting for background market growth, compares unmatched and matched-control designs, and converts estimated sales lift into rollout decisions.

## Business question

A retailer piloted a branded store-within-store format across a subset of locations. The decision problem is whether the rollout generated enough incremental unit sales to justify expansion across the full store network.

The analysis addresses four questions:

1. Did pilot stores outperform non-pilot stores after implementation?
2. Does the estimated effect remain after adjusting for regional differences?
3. Does matched-control analysis materially change the result?
4. Does the estimated lift exceed the commercial break-even threshold?

## Technical approach

- Longitudinal store-level panel preparation
- Pre/post treatment indicator construction
- Nearest-neighbour control matching within province
- Difference-in-differences regression
- Province fixed effects
- Store-clustered standard errors
- Sensitivity analysis with unmatched and matched samples
- Profitability and rollout-threshold evaluation
- Reproducible CSV outputs and publication-ready figures

The core DiD specification is:

```text
sales_it = beta0 + beta1 treated_i + beta2 post_t
           + beta3 treated_i x post_t + province controls + error_it
```

The interaction coefficient `beta3` is interpreted as the incremental sales effect associated with the rollout under the parallel-trends assumption.

## Case-study findings

The case-study estimates show a clear difference between raw growth and causal-adjusted lift:

| Estimate | Average incremental units | Break-even threshold | Decision |
|---|---:|---:|---|
| Raw pilot-store lift | 1,318 | 1,100 | Above threshold before control adjustment |
| DiD without matching | 840 | 1,100 | Below threshold |
| DiD with matched controls | 790 | 1,100 | Below threshold |

Neither regression estimate reached statistical significance in the available sample. The evidence therefore does not support an immediate network-wide rollout. A targeted continuation in the strongest regions, combined with redesigned measurement and additional post-period data, is the more defensible decision.

## Repository structure

```text
retail-rollout-causal-impact/
├── README.md
├── requirements.R
├── run_pipeline.R
├── Dockerfile
├── Makefile
├── LICENSE
├── R/
│   ├── data_validation.R
│   ├── matching.R
│   ├── did_models.R
│   ├── profitability.R
│   └── plotting.R
├── scripts/
│   ├── 01_match_controls.R
│   ├── 02_fit_did_models.R
│   └── 03_generate_figures.R
├── data/
│   ├── README.md
│   └── sample_store_panel.csv
├── results/
│   ├── province_effect_summary.csv
│   ├── overall_effect_summary.csv
│   └── profitability_scenarios.csv
├── figures/
├── docs/
│   ├── METHODOLOGY.md
│   ├── RESULTS.md
│   ├── LIMITATIONS.md
│   └── REPRODUCIBILITY.md
└── tests/
    └── testthat/
        └── test-did-models.R
```

## Quick start

### 1. Install dependencies

```bash
Rscript requirements.R
```

### 2. Run the full pipeline

```bash
Rscript run_pipeline.R
```

The default run uses the included synthetic sample dataset. To analyse another panel:

```bash
DATA_PATH=/path/to/store_panel.csv Rscript run_pipeline.R
```

## Required input schema

| Column | Type | Description |
|---|---|---|
| `store_id` | integer/character | Stable store identifier |
| `province` | character | Regional grouping used for controls and matching |
| `year` | integer | Observation year |
| `sales` | numeric | Sales outcome, typically unit volume |
| `treated` | 0/1 | Whether the store received the rollout |

Optional columns such as historical volume, growth rate, or a predefined `match_id` can be retained for matching diagnostics.

## Outputs

The pipeline writes:

- model coefficient tables with conventional and clustered standard errors;
- matched store pairs and covariate-distance diagnostics;
- province-level effect summaries;
- break-even and profitability scenarios;
- effect-comparison and decision-threshold charts.

## Interpretation safeguards

Difference-in-differences is not automatically causal. The estimate depends on credible parallel pre-treatment trends, consistent outcome measurement, limited spillovers, and a control group that approximates the untreated counterfactual. The project therefore reports adjusted and matched estimates together rather than relying on raw pilot-store growth.

## Disclaimer

This repository is an analytical case study and decision-support prototype. The included sample data are synthetic. Results should not be used as audited financial guidance without validating the underlying data, treatment timing, cost structure, and identification assumptions.
