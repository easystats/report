#' Report additional information
#'
#' Reports additional information relevant to the report (see list of supported
#' objects in [report()]).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return An object of class [report_info()].
#'
#' @examples
#' library(report)
#'
#' # h-tests
#' report_info(t.test(iris$Sepal.Width, iris$Sepal.Length))
#'
#' # ANOVAs
#' report_info(aov(Sepal.Length ~ Species, data = iris))
#' \donttest{
#' # GLMs
#' report_info(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' report_info(lm(Sepal.Length ~ Petal.Length * Species, data = iris), include_effectsize = TRUE)
#' report_info(glm(vs ~ disp, data = mtcars, family = "binomial"))
#' }
#'
#' @examplesIf requireNamespace("lme4", quietly = TRUE)
#' \donttest{
#' # Mixed models
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' report_info(model)
#' }
#'
#' @examplesIf requireNamespace("rstanarm", quietly = TRUE)
#' \donttest{
#' # Bayesian models
#' library(rstanarm)
#' model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 300))
#' report_info(model)
#' }
#' @export
report_info <- function(x, ...) {
  UseMethod("report_info")
}


# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_info <- function(x, summary = NULL, ...) {
  class(x) <- unique(c("report_info", class(x)))
  attributes(x) <- c(attributes(x), list(...))

  if (!is.null(summary)) {
    attr(x, "summary") <- summary
  }
  x
}


#' @export
summary.report_info <- function(object, ...) {
  summary_attr <- attributes(object)$summary
  if (is.null(summary_attr)) object else summary_attr
}

#' @export
print.report_info <- function(x, ...) {
  cat(paste(x, collapse = "\n"))
}


# Utils -------------------------------------------------------------------

#' @keywords internal
.info_df <- function(ci, ci_method = NULL, test_statistic = NULL, bootstrap = FALSE) {
  if (is.null(ci_method)) {
    return("")
  }

  text_output <- paste0(
    insight::format_value(ci * 100, protect_integers = TRUE),
    "% Confidence Intervals (CIs) and p-values were computed using "
  )

  ci_method <- tolower(ci_method)
  string_method <- switch(ci_method,
    bci = ,
    bcai = "bias-corrected accelerated bootstrap",
    si = ,
    ci = ,
    quantile = ,
    eti = ,
    hdi = ifelse(isTRUE(bootstrap), "na\u0131ve bootstrap", "MCMC"),
    normal = "Wald normal",
    boot = "parametric bootstrap",
    "Wald"
  )

  if (ci_method %in% c("kenward", "kr", "kenward-roger", "kenward-rogers", "satterthwaite")) {
    string_approx <- paste0("with ", parameters::format_df_adjust(ci_method, approx_string = "", dof_string = ""), " ")
  } else {
    string_approx <- ""
  }

  if (!is.null(test_statistic) && ci_method != "normal" && !isTRUE(bootstrap)) {
    string_statistic <- switch(tolower(test_statistic),
      "t-statistic" = "t",
      "chi-squared statistic" = ,
      "z-statistic" = "z",
      ""
    )
    string_method <- paste0(string_method, " ", string_statistic, "-")
  } else {
    string_method <- paste0(string_method, " ")
  }

  # bootstrapped intervals
  if (isTRUE(bootstrap)) {
    text_output <- paste0(text_output, string_method, "intervals.")
  } else {
    text_output <- paste0(text_output, "a ", string_method, "distribution ", string_approx, "approximation.")
  }
  text_output
}

#' @keywords internal
.info_effectsize <- function(x, effectsize = NULL, include_effectsize = FALSE) {
  text_output <- ""

  if (!is.null(effectsize)) {
    text_output <- attributes(effectsize)$method
    if (include_effectsize) {
      text_output <- paste0(text_output, attributes(effectsize)$rules)
      text_output <- gsub(".Effect sizes ", " and ", text_output, fixed = TRUE)
    }
  }

  text_output
}
