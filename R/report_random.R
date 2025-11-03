#' Report random effects and factors
#'
#' Reports random effects of mixed models (see list of supported objects in
#' [report()]).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return An object of class [report_random()].
#'
#' @examplesIf requireNamespace("lme4", quietly = TRUE)
#' \donttest{
#' # Mixed models
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' r <- report_random(model)
#' r
#' summary(r)
#' }
#'
#' @examplesIf requireNamespace("rstanarm", quietly = TRUE)
#' \donttest{
#' # Bayesian models
#' library(rstanarm)
#' model <- suppressWarnings(stan_lmer(
#'   mpg ~ disp + (1 | cyl),
#'   data = mtcars, refresh = 0, iter = 1000
#' ))
#' r <- report_random(model)
#' r
#' summary(r)
#' }
#'
#' @examplesIf requireNamespace("brms", quietly = TRUE) && packageVersion("rstan") >= "2.26.0"
#' \donttest{
#' library(brms)
#' model <- suppressWarnings(brm(mpg ~ disp + (1 | cyl), data = mtcars, refresh = 0, iter = 1000))
#' r <- report_random(model)
#' r
#' summary(r)
#' }
#' @export
report_random <- function(x, ...) {
  UseMethod("report_random")
}


# METHODS -----------------------------------------------------------------

#' @rdname as.report
#' @export
as.report_random <- function(x, summary = NULL, ...) {
  class(x) <- unique(c("report_random", class(x)))
  attributes(x) <- c(attributes(x), list(...))

  if (!is.null(summary)) {
    attr(x, "summary") <- summary
  }
  x
}


#' @export
summary.report_random <- function(object, ...) {
  if (is.null(attributes(object)$summary)) {
    object
  } else {
    attributes(object)$summary
  }
}

#' @export
print.report_random <- function(x, ...) {
  cat(paste(x, collapse = "\n"))
}
