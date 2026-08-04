source("R/data_validation.R")
source("R/matching.R")

input_path <- Sys.getenv("DATA_PATH", "data/sample_store_panel.csv")
panel <- readr::read_csv(input_path, show_col_types = FALSE)
panel <- prepare_store_panel(panel)
features <- compute_pre_treatment_features(panel)
matches <- match_controls(features)
readr::write_csv(matches, "results/matched_store_pairs.csv")
