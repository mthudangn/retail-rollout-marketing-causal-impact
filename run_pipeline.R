required_directories <- c("results", "figures")
for (directory in required_directories) {
  if (!dir.exists(directory)) dir.create(directory, recursive = TRUE)
}

source("scripts/01_match_controls.R")
source("scripts/02_fit_did_models.R")
source("scripts/03_generate_figures.R")

message("Pipeline completed. Outputs are available in results/ and figures/.")
