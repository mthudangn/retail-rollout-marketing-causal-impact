source("R/data_validation.R")
source("R/matching.R")
source("R/did_models.R")
source("R/profitability.R")

input_path <- Sys.getenv("DATA_PATH", "data/sample_store_panel.csv")
panel <- readr::read_csv(input_path, show_col_types = FALSE)
panel <- prepare_store_panel(panel)

features <- compute_pre_treatment_features(panel)
matches <- match_controls(features)
models <- fit_did_suite(panel, matches)
coefficients <- summarise_did_suite(models)

readr::write_csv(matches, "results/matched_store_pairs.csv")
readr::write_csv(coefficients, "results/model_coefficients.csv")

best_effect <- coefficients |>
  dplyr::filter(.data$model == "matched_province") |>
  dplyr::pull(.data$estimate)

profitability <- evaluate_profitability(best_effect)
readr::write_csv(profitability, "results/sample_profitability_output.csv")
