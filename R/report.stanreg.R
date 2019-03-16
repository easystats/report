#' Bayesian Models Values
#'
#' Extract all values of Bayesian models.
#'
#' @inheritParams report.stanreg
#'
#' @importFrom insight model_info
#' @importFrom parameters model_parameters
#' @importFrom performance model_performance
#' @export
model_values.stanreg <- function(model, ci = 0.90, standardize = FALSE, effsize = NULL, performance_in_table = TRUE, performance_metrics = c("R2", "R2_adjusted"), parameters_estimate = "median", parameters_test = c("pd", "rope"), parameters_diagnostic = TRUE, parameters_priors = TRUE, rope_range = "default", rope_full = TRUE, ...) {

  # Sanity checks
  if(length(c(ci)) > 1){
    warning(paste0("report does not support multiple `ci` values yet. Using ci = ", ci[1]), ".")
    ci <- ci[1]
  }

  # Information
  out <- list()
  out$info <- insight::model_info(model)

  # Core Tables
  if (!is.null(effsize)) {
    if (standardize == FALSE) {
      warning("The effect sizes are computed from standardized coefficients. Setting `standardize` to TRUE.")
    }
    out$table_parameters <- parameters::model_parameters(model, standardize = TRUE, ci = ci, estimate = tolower(parameters_estimate), test = tolower(parameters_test), rope_range = rope_range, rope_full = rope_full, diagnostic = parameters_diagnostic, priors = parameters_priors, ...)
  } else {
    out$table_parameters <- parameters::model_parameters(model, ci = ci, standardize = standardize, estimate = tolower(parameters_estimate), test = tolower(parameters_test), rope_range = rope_range, rope_full = rope_full, diagnostic = parameters_diagnostic, priors = parameters_priors, ...)
  }
  out$table_parameters$Parameter <- as.character(out$table_parameters$Parameter)
  out$table_performance <- performance::model_performance(model, metrics = performance_metrics)

  # Text
  text_description <- model_text_description(model, effsize = effsize, ci = ci, standardize = standardize, test = tolower(parameters_test), rope_range = rope_range, rope_full = rope_full, ...)
  text_priors <- model_text_priors(out$table_parameters)
  text_performance <- model_text_performance_bayesian(out$table_performance)
  text_initial <- model_text_initial_bayesian(model, out$table_parameters, ci = ci)
  text_parameters <- model_text_parameters_bayesian(model, out$table_parameters, ci = ci, effsize = effsize, ...)

  out$text <- paste(
    text_description$text,
    text_priors,
    "\n\n",
    text_performance$text,
    text_initial$text,
    text_parameters$text
  )
  out$text_full <- paste(
    text_description$text_full,
    text_priors,
    "\n\n",
    text_performance$text_full,
    text_initial$text_full,
    text_parameters$text_full
  )

  # Tables
  modeltable <- model_table_bayesian(model, out$table_parameters, out$table_performance, performance_in_table = performance_in_table, ...)
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

  return(out)
}































#' Bayesian Models Report
#'
#' Create a report of a linear model.
#'
#' @param model Object of class \link{lm}.
#' @param ci \href{https://easystats.github.io/bayestestR/articles/1_IndicesDescription.html#hdi---the-credible-interval-ci}{Credible Interval} (CI) level. Default to 0.90 (90\%).
#' @param standardize Standardized coefficients. See \code{\link[parameters:model_parameters.lm]{model_parameters}}.
#' @param effsize \href{https://easystats.github.io/report/articles/interpret_metrics.html}{Interpret the standardized parameters} using a set of rules. Can be "cohen1988" (default for linear models), "chen2010" (default for logistic models), "sawilowsky2009", NULL, or a custom set of \link{rules}.
#' @param performance_in_table Add performance metrics in table.
#' @param performance_metrics Can be \code{"all"} or a list of metrics to be computed (some of \code{c("LOO", "R2", "R2_adj")}).
#' @param parameters_estimate The \href{https://easystats.github.io/bayestestR/articles/2_IndicesEstimationComparison.html}{point-estimate(s)} to compute. Can be a character or a list with "median", "mean" or "MAP".
#' @param parameters_test What \href{https://easystats.github.io/bayestestR/articles/3_IndicesExistenceComparison.html}{indices of effect existence} to compute. Can be a character or a list with "p_direction", "rope" or "p_map".
#' @param parameters_diagnostic Include sampling diagnostic metrics (effective sample, Rhat and MCSE). \code{Effective Sample} should be as large as possible, altough for most applications, an effective sample size greater than 1,000 is sufficient for stable estimates (Bürkner, 2017). \code{Rhat} should not be larger than 1.1.
#' @param parameters_priors Include priors specifications information. If set to true (current \code{rstanarm}' default), automatically adjusted priors' scale during fitting  will be displayed.
#' @param rope_range \href{https://easystats.github.io/bayestestR/articles/1_IndicesDescription.html#rope}{ROPE's} lower and higher limits Should be a list of two values (e.g., \code{c(-0.1, 0.1)}) or \code{"default"}. If \code{"default"}, the bounds are set to \code{x +- 0.1*SD(response)}.
#' @param rope_full If TRUE, use the proportion of the entire posterior distribution for the equivalence test. Otherwise, use the proportion of HDI as indicated by the \code{ci} argument.
#' @param ... Arguments passed to or from other methods.
#'
#' @examples
#' \dontrun{
#' library(rstanarm)
#' model <- rstanarm::stan_glm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' r <- report(model)
#' to_text(r)
#' to_fulltext(r)
#' to_table(r)
#' to_fulltable(r)
#'
#' model <- rstanarm::stan_lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' report(model)
#' }
#' @export
report.stanreg <- function(model, ci = 0.90, standardize = FALSE, effsize = NULL, performance_in_table = TRUE, performance_metrics = c("R2", "R2_adjusted"), parameters_estimate = "median", parameters_test = c("pd", "rope"), parameters_diagnostic = TRUE, parameters_priors = TRUE, rope_range = "default", rope_full = TRUE, ...) {
  values <- model_values(model,
    ci = ci,
    standardize = standardize,
    effsize = effsize,
    performance_in_table = performance_in_table,
    performance_metrics = performance_metrics,
    parameters_estimate = parameters_estimate,
    parameters_test = parameters_test,
    rope_range = rope_range,
    rope_full = rope_full,
    parameters_diagnostic = parameters_diagnostic,
    parameters_priors = parameters_priors,
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
