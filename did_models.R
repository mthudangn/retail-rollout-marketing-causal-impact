fit_did_model <- function(data, province_controls = FALSE) {
  formula <- if (province_controls) {
    sales ~ treated * post + province
  } else {
    sales ~ treated * post
  }
  model <- stats::lm(formula, data = data)
  attr(model, "cluster_id") <- data$store_id
  model
}

clustered_coefficient_table <- function(model, cluster) {
  clustered_vcov <- sandwich::vcovCL(model, cluster = cluster, type = "HC1")
  test <- lmtest::coeftest(model, vcov. = clustered_vcov)

  data.frame(
    term = rownames(test),
    estimate = test[, 1],
    std_error = test[, 2],
    statistic = test[, 3],
    p_value = test[, 4],
    row.names = NULL
  )
}

extract_did_effect <- function(model, cluster = NULL) {
  coefficient_table <- if (is.null(cluster)) {
    broom::tidy(model)
  } else {
    clustered_coefficient_table(model, cluster)
  }

  interaction_row <- coefficient_table |>
    dplyr::filter(.data$term %in% c("treated:post", "post:treated"))

  if (nrow(interaction_row) != 1L) {
    stop("Could not identify a unique DiD interaction coefficient.")
  }
  interaction_row
}

fit_did_suite <- function(panel, match_table = NULL) {
  unmatched_basic <- fit_did_model(panel, province_controls = FALSE)
  unmatched_province <- fit_did_model(panel, province_controls = TRUE)

  output <- list(
    unmatched_basic = unmatched_basic,
    unmatched_province = unmatched_province
  )

  if (!is.null(match_table) && nrow(match_table) > 0) {
    ids <- matched_store_ids(match_table)
    matched_panel <- panel |> dplyr::filter(.data$store_id %in% ids)
    output$matched_basic <- fit_did_model(matched_panel, province_controls = FALSE)
    output$matched_province <- fit_did_model(matched_panel, province_controls = TRUE)
  }

  output
}

summarise_did_suite <- function(models) {
  dplyr::bind_rows(lapply(names(models), function(model_name) {
    model <- models[[model_name]]
    result <- extract_did_effect(model, cluster = attr(model, "cluster_id"))
    result$model <- model_name
    result[, c("model", setdiff(names(result), "model"))]
  }))
}
