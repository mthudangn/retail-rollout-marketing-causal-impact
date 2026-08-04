required_panel_columns <- c("store_id", "province", "year", "sales", "treated")

validate_store_panel <- function(data) {
  missing_columns <- setdiff(required_panel_columns, names(data))
  if (length(missing_columns) > 0) {
    stop("Missing required columns: ", paste(missing_columns, collapse = ", "))
  }

  if (anyNA(data$store_id)) stop("store_id contains missing values.")
  if (anyNA(data$year)) stop("year contains missing values.")
  if (anyNA(data$sales)) stop("sales contains missing values.")
  if (!all(data$treated %in% c(0, 1))) stop("treated must contain only 0 and 1.")
  if (any(data$sales < 0)) warning("Negative sales values detected.")

  duplicate_rows <- duplicated(data[c("store_id", "year")])
  if (any(duplicate_rows)) {
    stop("Duplicate store-year observations detected.")
  }

  invisible(TRUE)
}

prepare_store_panel <- function(data, intervention_year = 2013L) {
  validate_store_panel(data)
  data |>
    dplyr::mutate(
      store_id = as.character(.data$store_id),
      province = as.factor(.data$province),
      year = as.integer(.data$year),
      sales = as.numeric(.data$sales),
      treated = as.integer(.data$treated),
      post = as.integer(.data$year > intervention_year)
    ) |>
    dplyr::arrange(.data$store_id, .data$year)
}
