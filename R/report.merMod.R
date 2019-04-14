#' Mixed Models Values
#'
#' Extract all values of mixed models.
#'
#' @inheritParams report.merMod
#'
#' @examples
#' \dontrun{
#' model <- circus::lmerMod_1
#' }
#'
#' @importFrom insight model_info
#' @importFrom parameters model_parameters
#' @importFrom performance model_performance
#' @export
model_values.lmerMod <- function(model, ci = 0.95, standardize = TRUE, effsize = "cohen1988", performance_in_table = TRUE, performance_metrics = "all", bootstrap = FALSE, p_method = "wald", ci_method="wald", ...) {

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
    out$table_parameters <- parameters::model_parameters(model, standardize = TRUE, ci = ci, bootstrap = bootstrap, p_method = p_method, ci_method=ci_method, ...)
  } else {
    out$table_parameters <- parameters::model_parameters(model, ci = ci, standardize = standardize, bootstrap = bootstrap, p_method = p_method, ci_method=ci_method, ...)
  }
  out$table_parameters$Parameter <- as.character(out$table_parameters$Parameter)
  out$table_performance <- performance::model_performance(model, metrics = performance_metrics, ...)


  # Text --------------------------------------------------------------------
  text_description <- model_text_description(model, effsize = effsize, ci = ci, bootstrap = bootstrap, p_method = p_method, ci_method = ci_method, ...)
  text_performance <- model_text_performance_mixed(out$table_performance)

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
model_values.merMod <- model_values.lmerMod





























#' Mixed Models Report
#'
#' Create a report of a mixed model.
#'
#' @param model Mixed model.
#' @inheritParams report.lm
#' @param p_method Method for computing p values. See \link{p_value}.
#' @param ci_method Method for computing confidence intervals (CI). See \link{ci}.
#'
#' @examples
#' \dontrun{
#' model <- lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' r <- report(model)
#' to_text(r)
#' to_fulltext(r)
#' to_table(r)
#' to_fulltable(r)
#' }
#' @export
report.lmerMod <- function(model, ci = 0.95, standardize = TRUE, effsize = "cohen1988", performance_in_table = TRUE, performance_metrics = "all", bootstrap = FALSE, p_method = "wald", ci_method="wald", ...) {
  values <- model_values(model,
    ci = ci,
    standardize = standardize,
    effsize = effsize,
    performance_in_table = performance_in_table,
    performance_metrics = performance_metrics,
    bootstrap = bootstrap,
    p_method=p_method,
    ci_method=ci_method,
    ...
  )


  out <- list(
    table = values$table,
    table_full = values$table_full,
    text = values$text,
    text_full = values$text_full,
    values = values
  )

  rep <- as.report(out)
  class(rep) <- c("report_model", class(rep))
  rep
}








#' @rdname report.lmerMod
#' @export
report.merMod <- function(model, ci = 0.95, standardize = TRUE, effsize = "chen2010", performance_in_table = TRUE, performance_metrics = "all", bootstrap = FALSE, ci_method="wald", ...) {
  values <- model_values(model,
                         ci = ci,
                         standardize = standardize,
                         effsize = effsize,
                         performance_in_table = performance_in_table,
                         performance_metrics = performance_metrics,
                         bootstrap = bootstrap,
                         ci_method=ci_method,
                         ...
  )


  out <- list(
    table = values$table,
    table_full = values$table_full,
    text = values$text,
    text_full = values$text_full,
    values = values
  )

  rep <- as.report(out)
  class(rep) <- c("report_model", class(rep))
  rep
}

