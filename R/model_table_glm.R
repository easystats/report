#' Create Tables for Linear Models
#
#' @param model Object of class \link{lm}.
#' @param parameters Parameters table \link{model_parameters}.
#' @param performance Performance table \link{model_performance}.
#' @param performance_in_table Add performance metrics on table.
#' @param ... Arguments passed to or from other methods (see \link{model_parameters} and \link{model_performance}).
#'
#' @keywords internal
model_table_glm <- function(model, parameters, performance, performance_in_table = TRUE, ...) {
  table_full <- table_simple <- parameters
  table_simple <- table_simple[, colnames(table_simple) %in% c("Parameter", "beta", "CI_low", "CI_high", "p", "Std_beta", "Effect_Size")]

  if (performance_in_table) {
    tabs <- .create_performance_table(
      performance,
      table_full,
      table_simple,
      elements = c('R2', 'R2_adjusted', 'R2_Tjur', 'R2_Nagelkerke', 'R2_McFadden', 'R2_conditional', 'R2_marginal')
    )
    table_full <- tabs$table_full
    table_simple <- tabs$table_simple
  }

  class(table_full) <- c("report_table", class(table_full))
  class(table_simple) <- c("report_table", class(table_simple))

  list(
    "table_full" = table_full,
    "table" = table_simple
  )
}






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
