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
  .report_regressions(model, effsize = effsize, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, performance_metrics = performance_metrics, ...)
}




#' @rdname report.lm
#' @export
report.glm <- function(model, effsize = "chen2010", ci = 0.95, standardize = "refit", standardize_robust = FALSE,  bootstrap = FALSE, iterations = 500, performance_metrics = "all", ...) {
  .report_regressions(model, effsize = effsize, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, performance_metrics = performance_metrics, ...)
}