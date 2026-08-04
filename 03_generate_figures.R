source("R/plotting.R")

effects <- readr::read_csv("results/overall_effect_summary.csv", show_col_types = FALSE)
plot_effect_vs_threshold(effects, "figures/overall-effect-vs-threshold-r.png")
