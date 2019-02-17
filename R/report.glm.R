#' General Linear Models Values
#'
#' Extract all values of general linear models.
#'
#' @inheritParams report.glm
#'
#' @importFrom insight model_info
#' @importFrom parameters model_parameters
#' @importFrom performance model_performance
#' @export
model_values.glm <- function(model, ci = 0.95, standardize = TRUE, effsize = "chen2010", performance_in_table = TRUE, performance_metrics = "all", bootstrap = FALSE, ...) {

  # Information
  out <- list()
  out$info <- insight::model_info(model)

  # Core Tables
  if (!is.null(effsize)) {
    if (standardize == FALSE) {
      warning("The effect sizes are computed from standardized coefficients. Setting `standardize` to TRUE.")
    }
    out$table_parameters <- parameters::model_parameters(model, standardize = TRUE, ci = ci, bootstrap = bootstrap, ...)
  } else {
    out$table_parameters <- parameters::model_parameters(model, ci = ci, standardize = standardize, bootstrap = bootstrap, ...)
  }
  out$table_parameters$Parameter <- as.character(out$table_parameters$Parameter)
  out$table_performance <- performance::model_performance(model, metrics = performance_metrics, ...)


  if (bootstrap == FALSE) {
    # Text
    text_description <- model_text_description(model, effsize = effsize, ci = ci, bootstrap = bootstrap, ...)
    text_performance <- model_text_performance_logistic(out$table_performance)
    text_initial <- model_text_initial_logistic(out$table_parameters, ci = ci)
    text_parameters <- model_text_parameters_logistic(model, out$table_parameters, ci = ci, effsize = effsize, ...)

    out$text <- paste(
      text_description$text,
      text_performance$text,
      text_initial$text,
      text_parameters$text
    )
    out$text_full <- paste(
      text_description$text_full,
      text_performance$text_full,
      text_initial$text_full,
      text_parameters$text_full
    )

    # Tables
    modeltable <- model_table_lm(model, out$table_parameters, out$table_performance, performance_in_table = performance_in_table, ...)
    out$table <- modeltable$table
    out$table_full <- modeltable$table_full
  } else {
    # Text
    text_description <- model_text_description(model, effsize = effsize, ci = ci, bootstrap = bootstrap, ...)
    text_performance <- model_text_performance_logistic(out$table_performance)
    text_initial <- model_text_initial_bayesian(out$table_parameters, ci = ci)
    text_parameters <- model_text_parameters_bayesian(model, out$table_parameters, ci = ci, effsize = effsize, ...)

    out$text <- paste(
      text_description$text,
      text_performance$text,
      text_initial$text,
      text_parameters$text
    )
    out$text_full <- paste(
      text_description$text_full,
      text_performance$text_full,
      text_initial$text_full,
      text_parameters$text_full
    )

    # Tables
    modeltable <- model_table_bayesian(model, out$table_parameters, out$table_performance, performance_in_table = performance_in_table, ...)
    out$table <- modeltable$table
    out$table_full <- modeltable$table_full
  }


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
#' @param ci Confidence Interval (CI) level. Default to 0.95 (95\%).
#' @param standardize Standardized coefficients. See \code{\link[parameters:model_parameters.lm]{model_parameters}}.
#' @param effsize Interpret the log odds ratio using a set of rules. Can be "chen2010" (default), "cohen1988", NULL, or a custom set of \link{rules}.
#' @param performance_in_table Add performance metrics on table.
#' @param performance_metrics See \code{\link[performance:model_performance.lm]{model_performance}}.
#' @param bootstrap See \code{\link[parameters:model_parameters.lm]{model_parameters}}.
#' @param ... Arguments passed to or from other methods.
#'
#' @examples
#' model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' r <- report(model)
#' to_text(r)
#' to_fulltext(r)
#' to_table(r)
#' to_fulltable(r)
#' @export
report.glm <- function(model, ci = 0.95, standardize = TRUE, effsize = "chen2010", performance_in_table = TRUE, performance_metrics = "all", bootstrap = FALSE, ...) {
  values <- model_values(model,
    ci = ci,
    standardize = standardize,
    effsize = effsize,
    performance_in_table = performance_in_table,
    performance_metrics = performance_metrics,
    bootstrap = bootstrap,
    ...
  )


  out <- list(
    table = values$table,
    table_full = values$table_full,
    text = values$text,
    text_full = values$text_full,
    values = values
  )
  return(as.report(out))
}
