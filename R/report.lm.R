#' Linear Models Values
#'
#' Extract all values of linear models.
#'
#' @inheritParams report.lm
#'
#' @importFrom insight model_info
#' @importFrom parameters model_parameters
#' @importFrom performance model_performance
#' @export
model_values.lm <- function(model, effsize = "cohen1988", ci = 0.95, performance_in_table = TRUE, ...) {

  # Information
  out <- list()
  out$info <- insight::model_info(model)

  # Core Tables
  if (!is.null(effsize)) {
    out$table_parameters <- parameters::model_parameters(model, standardize = TRUE, ci = ci, ...)
    out$table_parameters$Effect_Size <- interpret_d(out$table_parameters$Std_beta, rules = effsize)
  } else {
    out$table_parameters <- parameters::model_parameters(model, ci = ci, ...)
  }
  out$table_performance <- performance::model_performance(model, ...)
  out$table_parameters$Parameter <- as.character(out$table_parameters$Parameter)


  # Text
  modeltext <- model_text(model, performance = out$table_performance, parameters = out$table_parameters, ci = ci, effsize = effsize, ...)
  out$text <- modeltext$text
  out$text_full <- modeltext$text_full

  # Tables
  modeltable <- model_table(model, out$table_parameters, out$table_performance, performance_in_table = performance_in_table, ...)
  out$table <- modeltable$table
  out$table_full <- modeltable$table_full

  # tables to values
  out$parameters <- list()
  for (param in out$table_parameters$Parameter) {
    out$parameters[[param]] <- as.list(out$table_parameters[out$table_parameters$Parameter == param, ])
  }

  out$performance <- list()
  for (perf in names(out$table_performance)) {
    out$performance[[perf]] <- out$table_performance[[perf]]
  }


  class(out) <- c("values_lm", class(out))
  return(out)
}































#' Linear Models Report
#'
#' Create a report of a linear model.
#'
#' @param model Object of class \link{lm}.
#' @param effsize Compute standardized parameters and interpret them using a set of rules. Can be "cohen1988" (default), "sawilowsky2009", NULL, or a custom set of \link{rules}.
#' @param ci Confidence Interval (CI) level. Default to 0.95 (95\%).
#' @param performance_in_table Add performance metrics on table.
#' @param ... Arguments passed to or from other methods (see \link{model_parameters} and \link{model_performance}).
#'
#' @examples
#' model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' r <- report(model)
#' to_text(r)
#' to_fulltext(r)
#' to_table(r)
#' to_fulltable(r)
#' @export
report.lm <- function(model, ci = 0.95, effsize = "cohen1988", performance_in_table = TRUE, ...) {
  values <- model_values(model, ci = ci, effsize = effsize, performance_in_table = performance_in_table, ...)


  out <- list(
    table = values$table,
    table_full = values$table_full,
    text = values$text,
    text_full = values$text_full,
    values = values
  )
  return(as.report(out))
}
