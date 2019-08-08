#' (General) Linear Models Report
#'
#' Create a report of a (general) linear model.
#'
#' @inheritParams parameters::model_parameters.lm
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

  # Sanity checks -----------------------------------------------------------
  if(length(c(ci)) > 1){
    warning(paste0("report does not support multiple `ci` values yet. Using ci = ", ci[1]), ".")
    ci <- ci[1]
  }

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
  text <- paste0(text_model$text, text_perf$text, text_intercept$text, " Whithin this model:\n\n", text_params$text)
  text_full <- paste0(text_model$text_full, text_perf$text_full, text_intercept$text_full, " Whithin this model:\n\n", text_params$text_full)


  out <- list(
    table = table,
    table_full = table_full,
    text = text,
    text_full = text_full,
    values = c(to_values(parameters), as.list(performance))
  )

  rep <- as.report(out, effsize = effsize, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, performance_metrics = performance_metrics, ...)
  rep
}








#' @export
report.glm <- report.lm








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
