source("R/data_validation.R")
source("R/did_models.R")

testthat::test_that("panel validation rejects duplicate store-year records", {
  data <- data.frame(
    store_id = c(1, 1), province = c("A", "A"), year = c(2012, 2012),
    sales = c(100, 110), treated = c(0, 0)
  )
  testthat::expect_error(validate_store_panel(data), "Duplicate")
})

testthat::test_that("DiD coefficient recovers a known treatment effect", {
  data <- expand.grid(store_id = 1:20, year = c(2012, 2014))
  data$province <- ifelse(data$store_id <= 10, "A", "B")
  data$treated <- as.integer(data$store_id %% 2 == 0)
  data$post <- as.integer(data$year > 2013)
  data$sales <- 100 + 10 * data$post + 25 * data$treated * data$post
  model <- fit_did_model(data)
  effect <- extract_did_effect(model)
  testthat::expect_equal(effect$estimate, 25, tolerance = 1e-8)
})
