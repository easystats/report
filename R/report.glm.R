#' (General) Linear Models Report
#'
#' Create a report of a (general) linear model.
#'
#' @inheritParams parameters::model_parameters.default
#' @param interpretation \href{https://easystats.github.io/effectsize/articles/interpret.html}{Interpret the standardized parameters} using a set of rules. Default corresponds to "funder2019" for linear models and "chen2010" for logistic models.
#' @param performance_metrics See \code{\link[performance:model_performance.lm]{model_performance}}.
#' @param standardize_robust  Logical, if \code{TRUE}, robust standard errors are calculated (if possible), and confidence intervals and p-values are based on these robust standard errors.
#'
#' @examples
#' library(report)
#'
#' model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' r <- report(model)
#' text_short(r)
#' text_long(r)
#' table_short(r)
#' table_long(r)
#'
#'
#' model <- glm(vs ~ disp, data = mtcars, family = "binomial")
#' r <- report(model)
#' text_short(r)
#' text_long(r)
#' table_short(r)
#' table_long(r)
#' @export
report.lm <- function(model, interpretation = "default", ci = 0.95, standardize = "refit", standardize_robust = FALSE, bootstrap = FALSE, iterations = 500, performance_metrics = "all", ...) {
  tables <- model_table(model, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, performance_metrics = performance_metrics, ...)
  texts <- model_text(model, interpretation = interpretation, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, performance_metrics = performance_metrics, ...)

  out <- list(
    texts = texts,
    tables = tables
  )

  as.report(out, interpretation = interpretation, ...)
}


#' @export
report.glm <- report.lm
