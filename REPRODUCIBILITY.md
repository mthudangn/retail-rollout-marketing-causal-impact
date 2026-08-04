# Reproducibility

## Local execution

```bash
Rscript requirements.R
Rscript run_pipeline.R
```

## Docker

```bash
docker build -t retail-rollout-causal-impact .
docker run --rm -v "$PWD/results:/project/results" retail-rollout-causal-impact
```

## Custom data

```bash
DATA_PATH=/absolute/path/store_panel.csv Rscript run_pipeline.R
```

The code uses a fixed analytical definition of the post period and writes all generated tables to `results/`. The synthetic sample is deterministic and intended only as a smoke-test dataset.
