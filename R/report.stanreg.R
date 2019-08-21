#' Bayesian Models Report
#'
#' Create a report of Bayesian models.
#'
#' @inheritParams report.lm
#' @inheritParams parameters::model_parameters.stanreg
#'
#' @examples
#' library(report)
#' library(rstanarm)
#'
#' \donttest{
#' model <- rstanarm::stan_glm(Sepal.Length ~ Petal.Length * Species,
#'   data = iris, iter = 500, refresh = 0
#' )
#' r <- report(model)
#' to_text(r)
#' to_fulltext(r)
#' to_table(r)
#' to_fulltable(r)
#'
#'
#' model <- rstanarm::stan_lmer(Sepal.Length ~ Petal.Length + (1 | Species),
#'   data = iris, iter = 100, refresh = 0
#' )
#' report(model)
#' }
#'
#' @export
report.stanreg <- function(model, effsize = "default", ci = 0.89, standardize = "smart", standardize_robust = FALSE, centrality = "median", dispersion = FALSE, ci_method = "hdi", test = c("pd", "rope"), rope_range = "default", rope_ci = 1, bf_prior = NULL, diagnostic = c("ESS", "Rhat"), performance_metrics = "all", ...) {
  .report_regressions(model, effsize = effsize, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = FALSE, iterations = 0, performance_metrics = performance_metrics, centrality = centrality, dispersion = dispersion, ci_method = ci_method, test = test, rope_range = rope_range, rope_ci = rope_ci, bf_prior = bf_prior, diagnostic = diagnostic, ...)
}
