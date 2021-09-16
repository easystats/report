#' Report a descriptive table
#'
#' Creates tables to describe different objects (see list of supported objects
#' in [report()]).
#'
#' @inheritParams report
#'
#' @return An object of class [report_table()].
#'
#' @examples
#' \donttest{
#' library(report)
#'
#' # Miscellaneous
#' r <- report_table(sessionInfo())
#' r
#' summary(r)
#'
#' # Data
#' report_table(iris$Sepal.Length)
#' report_table(as.character(round(iris$Sepal.Length, 1)))
#' report_table(iris$Species)
#' report_table(iris)
#'
#' # h-tests
#' report_table(t.test(mpg ~ am, data = mtcars))
#'
#' # ANOVAs
#' report_table(aov(Sepal.Length ~ Species, data = iris))
#'
#' # GLMs
#' report_table(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' report_table(glm(vs ~ disp, data = mtcars, family = "binomial"))
#'
#' # Mixed models
#' if (require("lme4")) {
#'   model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#'   report_table(model)
#' }
#'
#' # Bayesian models
#' if (require("rstanarm")) {
#'   model <- stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600)
#'   report_table(model, effectsize_method = "basic")
#' }
#'
#' # Structural Equation Models (SEM)
#' if (require("lavaan")) {
#'   structure <- " ind60 =~ x1 + x2 + x3
#'                  dem60 =~ y1 + y2 + y3
#'                  dem60 ~ ind60 "
#'   model <- lavaan::sem(structure, data = PoliticalDemocracy)
#'   report_table(model)
#' }
#' }
#' @export
report_table <- function(x, ...) {
  UseMethod("report_table")
}



# METHODS -----------------------------------------------------------------

#' @rdname as.report
#' @export
as.report_table <- function(x, ...) {
  UseMethod("as.report_table")
}

#' @export
as.report_table.default <- function(x, summary = NULL, as_is = FALSE, ...) {
  if (as_is) {
    class(x) <- unique(c(class(x)[1], "report_table", utils::tail(class(x), -1)))
  } else {
    class(x) <- unique(c("report_table", class(x)))
  }

  attributes(x) <- c(attributes(x), list(...))

  if (!is.null(summary)) {
    if (as_is) {
      class(summary) <- unique(c(class(summary)[1], "report_table", utils::tail(class(summary), -1)))
    } else {
      class(summary) <- unique(c("report_table", class(summary)))
    }
    attr(x, "summary") <- summary
  }

  x
}

#' @export
as.report_table.report <- function(x, summary = NULL, ...) {
  if (is.null(summary) || isFALSE(summary)) {
    attributes(x)$table
  } else if (isTRUE(summary)) {
    summary(attributes(x)$table)
  }
}





#' @export
summary.report_table <- function(object, ...) {
  if (is.null(attributes(object)$summary)) {
    object
  } else {
    attributes(object)$summary
  }
}


#' @export
format.report_table <- function(x, ...) {
  insight::format_table(x, ...)
}

#' @export
print.report_table <- function(x, ...) {
  cat(insight::export_table(format(x, ...), ...))
}
