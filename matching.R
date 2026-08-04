compute_pre_treatment_features <- function(data, intervention_year = 2013L) {
  pre <- data |>
    dplyr::filter(.data$year <= intervention_year) |>
    dplyr::arrange(.data$store_id, .data$year)

  pre |>
    dplyr::group_by(.data$store_id, .data$province, .data$treated) |>
    dplyr::summarise(
      baseline_sales = dplyr::last(.data$sales),
      mean_pre_sales = mean(.data$sales),
      pre_growth = (dplyr::last(.data$sales) - dplyr::first(.data$sales)) /
        pmax(abs(dplyr::first(.data$sales)), 1),
      .groups = "drop"
    )
}

match_controls <- function(features, same_province = TRUE, replace = FALSE) {
  treated <- features |> dplyr::filter(.data$treated == 1)
  controls <- features |> dplyr::filter(.data$treated == 0)

  scale_columns <- c("baseline_sales", "mean_pre_sales", "pre_growth")
  combined <- dplyr::bind_rows(treated, controls)
  scaled <- scale(combined[scale_columns])
  combined[paste0(scale_columns, "_z")] <- scaled

  treated <- combined |> dplyr::filter(.data$treated == 1)
  controls <- combined |> dplyr::filter(.data$treated == 0)
  used_controls <- character(0)
  matches <- list()

  for (i in seq_len(nrow(treated))) {
    candidates <- controls
    if (same_province) {
      candidates <- candidates |> dplyr::filter(.data$province == treated$province[i])
    }
    if (!replace) {
      candidates <- candidates |> dplyr::filter(!.data$store_id %in% used_controls)
    }
    if (nrow(candidates) == 0) next

    distances <- sqrt(
      (candidates$baseline_sales_z - treated$baseline_sales_z[i])^2 +
      (candidates$mean_pre_sales_z - treated$mean_pre_sales_z[i])^2 +
      (candidates$pre_growth_z - treated$pre_growth_z[i])^2
    )
    selected_index <- which.min(distances)
    selected <- candidates[selected_index, ]

    matches[[length(matches) + 1L]] <- data.frame(
      match_id = length(matches) + 1L,
      treated_store_id = treated$store_id[i],
      control_store_id = selected$store_id,
      province = as.character(treated$province[i]),
      distance = distances[selected_index]
    )
    used_controls <- c(used_controls, selected$store_id)
  }

  dplyr::bind_rows(matches)
}

matched_store_ids <- function(match_table) {
  unique(c(match_table$treated_store_id, match_table$control_store_id))
}
