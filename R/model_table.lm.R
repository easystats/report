#' Create Tables for Linear Models
#
#' @param model Object of class \link{lm}.
#' @param performance Add performance metrics on table.
#' @param ... Arguments passed to or from other methods (see \link{model_parameters} and \link{model_performance}).
#'
#' @examples
#' model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' model_table(model)$table
#' @importFrom parameters model_parameters
#' @export
model_table.lm <- function(model, performance=TRUE, ...){

  if(!inherits(model, "values_lm")){
    model <- model_values(model, ...)
  }

  table_full <- model$table_parameters
  table <- table_full
  table <- table[, colnames(table) %in% c("Parameter", "beta", "CI_low", "CI_high", "p", "Std_beta", "Effect_Size")]

  if(performance){
    table_full[nrow(table_full)+1,] <- NA
    table[nrow(table)+1,] <- NA
    # Full ----
    perf <- data.frame(
      "Parameter" = colnames(model$table_performance),
      "Fit" = as.numeric(model$table_performance[1, ]),
      stringsAsFactors = FALSE)
    table_full <- dplyr::full_join(table_full, perf, by="Parameter")
    # Mini ----
    perf <- data.frame(
      "Parameter" = colnames(model$table_performance),
      "Fit" = as.numeric(model$table_performance[1, ]),
      stringsAsFactors = FALSE) %>%
      dplyr::filter_("Parameter %in% c('R2', 'R2_adj')")
    table <- dplyr::full_join(table, perf, by="Parameter")
  }

  class(table_full) <- c("report_table", class(table_full))
  class(table) <- c("report_table", class(table))

  out <- list("table_full" = table_full,
              "table" = table)
  return(out)
}

#' @export
model_table.values_lm <- model_table.lm