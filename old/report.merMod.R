#' Mixed Models Report
#'
#' Create a report of a mixed model (lme4).
#'
#' @inheritParams report.lm
#' @inheritParams parameters::model_parameters.merMod
#'
#' @examples
#' library(lme4)
#' library(report)
#'
#' model <- lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' r <- report(model)
#' to_text(r)
#' to_fulltext(r)
#' to_table(r)
#' to_fulltable(r)
#'
#'
#' model <- glmer(vs ~ disp + (1 | am), data = mtcars, family = "binomial")
#' r <- report(model)
#' to_text(r)
#' to_fulltext(r)
#' to_table(r)
#' to_fulltable(r)
#' @export
report.lmerMod <- function(model, effsize = "default", ci = 0.95, standardize = "refit", standardize_robust = FALSE, bootstrap = FALSE, iterations = 500, performance_metrics = "all", p_method = "wald", ci_method = "wald", ...) {
  .report_regressions(model, effsize = effsize, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, performance_metrics = performance_metrics, p_method = p_method, ci_method = ci_method, ...)
}




#' @export
report.merMod <- report.lmerMod
