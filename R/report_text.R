#' Report a textual description of an object
#'
#' Creates text containing a description of the parameters of R objects (see
#' list of supported objects in \code{\link{report}}).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @param table A table obtained via \code{report_table()}. If not provided,
#'   will run it.
#'
#' @return A \code{character} string.
#'
#' @examples
#' library(report)
#'
#' # Miscellaneous
#' r <- report_text(sessionInfo())
#' r
#' summary(r)
#'
#' # Data
#' report_text(iris$Sepal.Length)
#' report_text(as.character(round(iris$Sepal.Length, 1)))
#' report_text(iris$Species)
#' report_text(iris)
#'
#' # h-tests
#' report_text(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report_text(cor.test(iris$Sepal.Width, iris$Sepal.Length))
#'
#' # ANOVA
#' r <- report_text(aov(Sepal.Length ~ Species, data = iris))
#' r
#' summary(r)
#'
#' # GLMs
#' r <- report_text(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' r
#' summary(r)
#'
#' \donttest{
#' if (require("lme4")) {
#'   model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#'   r <- report_text(model)
#'   r
#'   summary(r)
#' }
#'
#' # Bayesian models
#' if (require("rstanarm")) {
#'   model <- stan_glm(mpg ~ cyl + wt, data = mtcars, refresh = 0, iter = 600)
#'   r <- report_text(model)
#'   r
#'   summary(r)
#' }
#' }
#' @export
report_text <- function(x, table = NULL, ...) {
  UseMethod("report_text")
}




# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_text <- function(x, ...) {
  UseMethod("as.report_text")
}

#' @export
as.report_text.default <- function(x, summary = NULL, ...) {
  class(x) <- unique(c("report_text", class(x)))
  attributes(x) <- c(attributes(x), list(...))
  if (!is.null(summary)) {
    class(summary) <- unique(c("report_text", class(summary)))
    attr(x, "summary") <- summary
  }
  x
}

#' @export
as.report_text.report <- function(x, summary = NULL, ...) {
  class(x) <- class(x)[class(x) != "report"]

  if (is.null(summary) | isFALSE(summary)) {
    x
  } else if (isTRUE(summary)) {
    summary(x)
  }
}




#' @export
summary.report_text <- function(object, ...) {
  if (is.null(attributes(object)$summary)) {
    object
  } else {
    attributes(object)$summary
  }
}

#' @export
print.report_text <- function(x, width = NULL, ...) {
  x <- format_text(as.character(x), width = width, ...)
  cat(x)
}


#' @export
print.report <- print.report_text
