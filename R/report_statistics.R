#' Report the statistics of a model
#'
#' Creates a list containing a description of the parameters' values of R
#' objects (see list of supported objects in [report()]). Useful to
#' insert in parentheses in plots or reports.
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return An object of class [report_statistics()].
#'
#' @examples
#' \donttest{
#' library(report)
#'
#' # Data
#' report_statistics(iris$Sepal.Length)
#' report_statistics(as.character(round(iris$Sepal.Length, 1)))
#' report_statistics(iris$Species)
#' report_statistics(iris)
#'
#' # h-tests
#' report_statistics(t.test(iris$Sepal.Width, iris$Sepal.Length))
#'
#' # ANOVA
#' report_statistics(aov(Sepal.Length ~ Species, data = iris))
#'
#' # GLMs
#' report_statistics(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' report_statistics(glm(vs ~ disp, data = mtcars, family = "binomial"))
#' }
#'
#' @examplesIf requireNamespace("lme4", quietly = TRUE)
#' \donttest{
#' # Mixed models
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' report_statistics(model)
#' }
#'
#' @examplesIf requireNamespace("rstanarm", quietly = TRUE)
#' \donttest{
#' # Bayesian models
#' library(rstanarm)
#' model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
#' report_statistics(model)
#' }
#' @export

report_statistics <- function(x, table = NULL, ...) {
  UseMethod("report_statistics")
}


# METHODS -----------------------------------------------------------------

#' @rdname as.report
#' @export
as.report_statistics <- function(x, summary = NULL, prefix = "  - ", ...) {
  class(x) <- unique(c("report_statistics", class(x)))
  attributes(x) <- c(attributes(x), list(...))
  attr(x, "prefix") <- prefix

  if (!is.null(summary)) {
    class(summary) <- unique(c("report_statistics", class(summary)))
    attr(summary, "prefix") <- prefix
    attr(x, "summary") <- summary
  }
  x
}

#' @export
summary.report_statistics <- summary.report_parameters

#' @export
print.report_statistics <- function(x, ...) {
  cat(paste0(x, collapse = "\n"))
}
