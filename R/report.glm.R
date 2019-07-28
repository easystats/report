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
model_values.lm <- function(model, ci = 0.95, standardize = "refit", standardize_robust = FALSE, effsize = "cohen1988", performance_in_table = TRUE, performance_metrics = "all", bootstrap = FALSE, iterations = 500, ...) {

  # Sanity checks -----------------------------------------------------------
  if(length(c(ci)) > 1){
    warning(paste0("report does not support multiple `ci` values yet. Using ci = ", ci[1]), ".")
    ci <- ci[1]
  }


  # Information -----------------------------------------------------------
  out <- list()
  out$info <- insight::model_info(model)

  # Core Tables -----------------------------------------------------------
  if (!is.null(effsize)) {
    if (standardize == FALSE) {
      warning("The effect sizes are computed from standardized coefficients. Setting `standardize` to TRUE.")
    }
    out$table_parameters <- parameters::model_parameters(model, ci = ci, standardize = TRUE, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations=iterations, ...)
  } else {
    out$table_parameters <- parameters::model_parameters(model, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations=iterations, ...)
  }
  out$table_parameters$Parameter <- as.character(out$table_parameters$Parameter)
  out$table_performance <- performance::model_performance(model, metrics = performance_metrics, ...)


  # Text --------------------------------------------------------------------
  # Description
  text_description <- model_text_description(model, effsize = effsize, ci = ci, bootstrap = bootstrap, iterations=iterations, ...)

  # Performance
  if(out$info$is_logit){
    text_performance <- model_text_performance_logistic(out$table_performance)
  } else{
    text_performance <- model_text_performance_lm(out$table_performance)
  }

  # Initial and Parameters
  if (bootstrap == FALSE) {
    text_initial <- model_text_initial_glm(model, out$table_parameters, ci = ci)
    if(out$info$is_linear){
      text_parameters <- model_text_parameters_lm(model, out$table_parameters, ci = ci, effsize = effsize, ...)
    } else if(out$info$is_logit){
      text_parameters <- model_text_parameters_logistic(model, out$table_parameters, ci = ci, effsize = effsize, ...)
    } else{
      text_parameters <- model_text_parameters_glm(model, out$table_parameters, ci = ci, effsize = effsize, ...)
    }

    modeltable <- model_table_glm(model, out$table_parameters, out$table_performance, performance_in_table = performance_in_table, ...)
    out$table <- modeltable$table
    out$table_full <- modeltable$table_full
  } else {
    text_initial <- model_text_initial_bayesian(model, out$table_parameters, ci = ci)
    text_parameters <- model_text_parameters_bayesian(model, out$table_parameters, ci = ci, effsize = effsize, ...)

    modeltable <- model_table_bayesian(model, out$table_parameters, out$table_performance, performance_in_table = performance_in_table, ...)
    out$table <- modeltable$table
    out$table_full <- modeltable$table_full
  }


  # Combine text --------------------------------------------------------------------


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


# To values ---------------------------------------------------------------

  out$parameters <- list()
  for (param in out$table_parameters$Parameter) {
    out$parameters[[param]] <- as.list(out$table_parameters[out$table_parameters$Parameter == param, ])
  }

  out$performance <- list()
  for (perf in names(out$table_performance)) {
    out$performance[[perf]] <- out$table_performance[[perf]]
  }

  #
  #   class(out) <- c("values_lm", class(out))
  return(out)
}

#' @export
model_values.glm <- model_values.lm





























#' (General) Linear Models Report
#'
#' Create a report of a (general) linear model.
#'
#' @inheritParams parameters::model_parameters.lm
#'
#' @param effsize \href{https://easystats.github.io/report/articles/interpret_metrics.html}{Interpret the standardized parameters} using a set of rules. Can be "cohen1988" (default for linear models), "chen2010" (default for logistic models), "sawilowsky2009", NULL, or a custom set of \link{rules}.
#' @param performance_metrics See \code{\link[performance:model_performance.lm]{model_performance}}.

#'
#' @examples
#' library(report)
#'
#' model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' r <- report(model)
#' to_text(r)
#' to_fulltext(r)
#' to_table(r)
#' to_fulltable(r)
#'
#'
#' model <- glm(vs ~ disp, data = mtcars, family = "binomial")
#' r <- report(model)
#' to_text(r)
#' to_fulltext(r)
#' to_table(r)
#' to_fulltable(r)
#' @export
report.lm <- function(model, effsize = "funder2019", ci = 0.95, standardize = "refit", standardize_robust = FALSE, bootstrap = FALSE, iterations = 500, performance_metrics = "all", ...) {

  # Tables -------------------
  performance <- performance::model_performance(model, metrics = performance_metrics, ...)
  parameters <- parameters::model_parameters(model, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, ...)


  table_full <- .add_performance_table(parameters, performance)
  table <- .add_performance_table(parameters[names(parameters) %in% c("Parameter", "Coefficient", "Median", "Mean", "MAP", "CI_low", "CI_high", "p", "pd", "ROPE_Percentage", "BF", "Std_Coefficient", "Std_Median", "Std_Mean", "Std_MAP")],
                                  performance[names(performance) %in%  c('R2', 'R2_adjusted', 'R2_Tjur', 'R2_Nagelkerke', 'R2_McFadden', 'R2_conditional', 'R2_marginal')])



  # Text -------------------
  # Description
  text_model <- text_model(model, ci = ci, standardize = standardize, standardize_robust = standardize_robust, effsize = effsize, bootstrap = bootstrap, iterations = iterations)

  # Performance
  text_perf <- text_performance(model, performance = performance)

  # Intercept
  text_intercept <- text_initial(model, parameters = parameters, ci = ci)

  # Params
  text_params <- text_parameters(model, parameters = parameters, prefix = "  - ", ci = ci, effsize = effsize)

  # Combine text
  text <- paste0(text_model$text, "\n\n", text_perf$text, text_intercept$text, "Whithin this model:\n\n", text_params$text)
  text_full <- paste0(text_model$text_fullt, "\n\n", text_perf$text_full, text_intercept$text_full, "Whithin this model:\n\n", text_params$text_full)


  out <- list(
    table = table,
    table_full = table_full,
    text = text,
    text_full = text_full,
    values = c(as.list(parameters), as.list(performance))
  )

  rep <- as.report(out)
  class(rep) <- c("report_model", class(rep))
  rep
}

















#' @rdname report.lm
#'
#' @export
# report.glm <- function(model, ci = 0.95, standardize = "refit", standardize_robust = FALSE, effsize = "chen2010", performance_in_table = TRUE, performance_metrics = "all", bootstrap = FALSE, iterations=500, ...) {
#   values <- model_values(model,
#                          ci = ci,
#                          standardize = standardize,
#                          standardize_robust = standardize_robust,
#                          effsize = effsize,
#                          performance_in_table = performance_in_table,
#                          performance_metrics = performance_metrics,
#                          bootstrap = bootstrap,
#                          iterations = iterations,
#                          ...
#   )
#
#
#   out <- list(
#     table = values$table,
#     table_full = values$table_full,
#     text = values$text,
#     text_full = values$text_full,
#     values = values
#   )
#   return(as.report(out))
# }
