#' Create Tables for Linear Models
#
#' @param model Object of class \link{lm}.
#' @param parameters Parameters table \link{model_parameters}.
#' @param performance Performance table \link{model_performance}.
#' @param performance_in_table Add performance metrics on table.
#' @param ... Arguments passed to or from other methods (see \link{model_parameters} and \link{model_performance}).
#'
#' @keywords internal
model_table_lm <- function(model, parameters, performance, performance_in_table = TRUE, ...) {
  table_full <- table_simple <- parameters
  table_simple <- table_simple[, colnames(table_simple) %in% c("Parameter", "beta", "CI_low", "CI_high", "p", "Std_beta", "Effect_Size")]

  if (performance_in_table) {
    tabs <- create_performance_table(
      performance,
      table_full,
      table_simple,
      elements = c('R2', 'R2_adjusted', 'R2_Tjur', 'R2_Nagelkerke', 'R2_McFadden')
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
