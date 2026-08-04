# Methodology

## Identification strategy

The analysis uses a difference-in-differences design. Pilot stores form the treated group and non-pilot stores form the control group. The post indicator begins after the rollout year.

The causal estimand is the interaction between treatment status and the post period. This interaction removes the average pre-existing difference between treated and control stores and the average market-wide time effect.

## Model variants

1. **Unadjusted DiD** - treatment, post period, and their interaction.
2. **Province-adjusted DiD** - adds province indicators to capture persistent regional differences.
3. **Matched DiD** - restricts the sample to treated stores paired with controls that have similar pre-treatment sales levels and growth.
4. **Matched province-adjusted DiD** - combines matching and regional controls.

## Matching

Controls are matched within province using standardised Euclidean distance across baseline sales, mean pre-period sales, and pre-period sales growth. Matching is performed without replacement by default.

## Inference

The pipeline reports store-clustered standard errors because repeated observations from the same location are not independent.

## Decision rule

The estimated effect is compared with a break-even requirement of 1,100 incremental units per store. Commercial viability should be based on the adjusted treatment effect rather than raw pilot-store growth.
