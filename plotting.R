plot_effect_vs_threshold <- function(effect_summary, output_path) {
  plot_data <- effect_summary |>
    dplyr::filter(.data$estimate_type != "Raw pilot-store lift")

  chart <- ggplot2::ggplot(
    plot_data,
    ggplot2::aes(x = .data$estimate_type, y = .data$incremental_units)
  ) +
    ggplot2::geom_col(width = 0.65) +
    ggplot2::geom_hline(
      yintercept = unique(plot_data$threshold_units),
      linetype = "dashed"
    ) +
    ggplot2::labs(
      title = "Estimated rollout effect versus break-even threshold",
      x = NULL,
      y = "Incremental unit sales"
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 15, hjust = 1))

  ggplot2::ggsave(output_path, chart, width = 8, height = 5, dpi = 160)
}
