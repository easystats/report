#' Create Tables for Bayesian Linear Models
#
#' @param model Bayesian models.
#' @param parameters Parameters table \link{model_parameters}.
#' @param performance Performance table \link{model_performance}.
#' @param performance_in_table Add performance metrics on table.
#' @param ... Arguments passed to or from other methods (see \link{model_parameters} and \link{model_performance}).
#'
#' @keywords internal
model_table_bayesian <- function(model, parameters, performance, performance_in_table = TRUE, ...) {
  table_full <- table_simple <- parameters
  table_simple <- table_simple[, !colnames(table_simple) %in% c("MAD", "SD", "Std_MAD", "Std_SD", "Std_CI_low", "Std_CI_high", "ROPE_Equivalence", "Effective_Sample", "Rhat", "Effect_Size_Median")]

  if (performance_in_table) {
    tabs <- .create_performance_table(
      performance,
      table_full,
      table_simple,
      elements = c('R2', 'R2_adjusted', 'R2_Median', 'R2_Fixed_Median', 'R2_LOO_adjusted')
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
