evaluate_profitability <- function(
  effect_units,
  threshold_units = 1100,
  profit_per_unit = 30,
  pilot_stores = 50,
  total_stores = 134
) {
  data.frame(
    effect_units = effect_units,
    threshold_units = threshold_units,
    threshold_met = effect_units >= threshold_units,
    incremental_profit_per_store = effect_units * profit_per_unit,
    pilot_incremental_profit = effect_units * profit_per_unit * pilot_stores,
    network_scaled_profit = effect_units * profit_per_unit * total_stores
  )
}
