#' @keywords internal
.add_performance_table <- function(parameters, performance) {
  table <- parameters
  table[nrow(table) + 1, ] <- NA
  # Full ----
  perf_vertical <- data.frame(
    "Parameter" = colnames(performance),
    "Fit" = as.numeric(performance[1, ]),
    stringsAsFactors = FALSE
  )
  table <- merge(table, perf_vertical, by = "Parameter", all = TRUE, sort = FALSE)
  table
}
