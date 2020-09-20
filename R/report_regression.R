# GLM ---------------------------------------------------------------------

#' (General) Linear Models Report
#'
#' Create a report of a (general) linear model.
#'
#' @inheritParams parameters::model_parameters.default
#' @param interpretation \href{https://easystats.github.io/effectsize/articles/interpret.html}{Interpret the standardized parameters} using a set of rules. Default corresponds to "funder2019" for linear models and "chen2010" for logistic models.
#' @param performance_metrics See \code{\link[performance:model_performance.lm]{model_performance}}.
#' @param standardize_robust  Logical, if \code{TRUE}, robust standard errors are calculated (if possible), and confidence intervals and p-values are based on these robust standard errors.
#' @inherit report return seealso
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
report.default <- function(model, interpretation = "default", ci = 0.95, standardize = "refit", standardize_robust = FALSE, bootstrap = FALSE, iterations = 500, performance_metrics = "all", ...) {
  out <- tryCatch(
    {
      .report_regression(
        model,
        interpretation = interpretation,
        ci = ci,
        standardize = standardize,
        standardize_robust = standardize_robust,
        bootstrap = bootstrap,
        iterations = iterations,
        performance_metrics = performance_metrics,
        ...
      )
    },
    error = function(e) { NULL }
  )

  if (is.null(out)) {
    warning("Models of class ", class(model)[1], " are not yet supported.", call. = FALSE)
  }

  out
}






# merMod ------------------------------------------------------------------

#' Mixed Models Report
#'
#' Create a report of a mixed model (lme4).
#'
#' @inheritParams report.default
#' @inheritParams parameters::model_parameters.merMod
#' @inherit report return seealso
#'
#' @examples
#' library(lme4)
#' library(report)
#'
#' model <- lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' r <- report(model)
#' text_short(r)
#' text_long(r)
#' table_short(r)
#' table_long(r)
#'
#'
#' model <- glmer(vs ~ disp + (1 | am), data = mtcars, family = "binomial")
#' r <- report(model)
#' text_short(r)
#' text_long(r)
#' table_short(r)
#' table_long(r)
#' @export
report.lmerMod <- function(model, interpretation = "default", ci = 0.95, standardize = NULL, standardize_robust = FALSE, bootstrap = FALSE, iterations = 500, performance_metrics = "all", df_method = "wald", ...) {
  .report_regression(
    model,
    interpretation = interpretation,
    ci = ci,
    standardize = standardize,
    standardize_robust = standardize_robust,
    bootstrap = bootstrap,
    iterations = iterations,
    performance_metrics = performance_metrics,
    df_method = "wald",
    ...
  )
}



#' @export
report.glmmTMB <- report.lmerMod

#' @export
report.MixMod <- report.lmerMod

#' @export
report.merMod <- report.lmerMod

#' @export
report.mixed <- report.lmerMod







# stanreg -----------------------------------------------------------------


#' Bayesian Models Report
#'
#' Create a report of Bayesian models.
#'
#' @inheritParams report.default
#' @inheritParams parameters::model_parameters.stanreg
#' @inherit report return seealso
#'
#' @examples
#' \donttest{
#' library(report)
#' if (require("rstanarm")) {
#'   model <- stan_glm(Sepal.Length ~ Petal.Length * Species,
#'     data = iris, iter = 250, refresh = 0
#'   )
#'   r <- report(model)
#'   text_short(r)
#'   text_long(r)
#'   table_short(r)
#'   table_long(r)
#'   model <- stan_lmer(Sepal.Length ~ Petal.Length + (1 | Species),
#'     data = iris, iter = 100, refresh = 0
#'   )
#'   report(model)
#' }}
#' @export
report.stanreg <- function(model, interpretation = "default", ci = 0.89, standardize = "smart", standardize_robust = FALSE, centrality = "median", dispersion = FALSE, ci_method = "hdi", test = c("pd", "rope"), rope_range = "default", rope_ci = 1, bf_prior = NULL, diagnostic = c("ESS", "Rhat"), performance_metrics = "all", ...) {
  .report_regression(
    model,
    interpretation = interpretation,
    ci = ci,
    standardize = standardize,
    standardize_robust = standardize_robust,
    bootstrap = FALSE,
    iterations = 0,
    performance_metrics = performance_metrics,
    centrality = centrality,
    dispersion = dispersion,
    ci_method = ci_method,
    test = test,
    rope_range = rope_range,
    rope_ci = rope_ci,
    bf_prior = bf_prior,
    diagnostic = diagnostic,
    ...
  )
}


# Internal ----------------------------------------------------------------


#' @keywords internal
.report_regression <- function(model, interpretation = "default", ci = 0.95, standardize = "refit", standardize_robust = FALSE, bootstrap = FALSE, iterations = 500, performance_metrics = "all", ...) {
  tables <- model_table(model, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, performance_metrics = performance_metrics, ...)
  texts <- model_text(model, interpretation = interpretation, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, performance_metrics = performance_metrics, performance_table = attributes(tables)$performance_table, model_table = tables, ...)

  out <- list(
    texts = texts,
    tables = tables
  )

  as.report(out, interpretation = interpretation, ...)
}