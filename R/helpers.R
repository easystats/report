#' @keywords internal
.create_performance_table <- function(performance, table_full, table_simple, elements) {
  table_full[nrow(table_full) + 1, ] <- NA
  table_simple[nrow(table_simple) + 1, ] <- NA
  # Full ----
  perf <- data.frame(
    "Parameter" = colnames(performance),
    "Fit" = as.numeric(performance[1, ]),
    stringsAsFactors = FALSE
  )
  table_full <- merge(table_full, perf, by = "Parameter", all = TRUE, sort = FALSE)

  # replaces
  # table_full <- dplyr::full_join(table_full, perf, by = "Parameter")

  # Mini ----
  perf <- perf[perf$Parameter %in% elements, ]
  table_simple <- merge(table_simple, perf, by = "Parameter", all = TRUE, sort = FALSE)

  # replaces
  # table <- dplyr::full_join(table, perf, by = "Parameter")

  list(table_full = table_full, table_simple = table_simple)
}
