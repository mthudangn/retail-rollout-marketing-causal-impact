packages <- c(
  "broom",
  "dplyr",
  "ggplot2",
  "lmtest",
  "readr",
  "sandwich",
  "testthat",
  "tidyr"
)

missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing) > 0) {
  install.packages(missing, repos = "https://cloud.r-project.org")
}
