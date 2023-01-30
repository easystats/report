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
#' report_table(t.test(mtcars$mpg ~ mtcars$am))
#'
#' # ANOVAs
#' report_table(aov(Sepal.Length ~ Species, data = iris))
#'
#' # GLMs
#' report_table(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' report_table(glm(vs ~ disp, data = mtcars, family = "binomial"))
#' }
#'
#' @examplesIf requireNamespace("lme4", quietly = TRUE)
#' \donttest{
#' # Mixed models
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' report_table(model)
#' }
#'
#' @examplesIf requireNamespace("rstanarm", quietly = TRUE)
#' \donttest{
#' # Bayesian models
#' library(rstanarm)
#' model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
#' report_table(model, effectsize_method = "basic")
#' }
#'
#' @examplesIf requireNamespace("lavaan", quietly = TRUE)
#' \donttest{
#' # Structural Equation Models (SEM)
#' library(lavaan)
#' structure <- "ind60 =~ x1 + x2 + x3
#'               dem60 =~ y1 + y2 + y3
#'               dem60 ~ ind60"
#' model <- lavaan::sem(structure, data = PoliticalDemocracy)
#' suppressWarnings(report_table(model))
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
  # remove unwanted columns
  x$Method <- NULL
  x$Alternative <- NULL

  insight::format_table(x, ...)
}


#' @export
print.report_table <- function(x, ...) {
  # try to guess appropriate caption and footer
  caption <- .report_table_caption(x)
  footer <- .report_table_footer(x)

  cat(insight::export_table(format(x, ...), caption = caption, footer = footer, ...))
}


#' @export
c.report_table <- function(...) {
  x <- list(...)

  out <- x[[1]]
  for (i in 2:length(x)) {
    out <- datawizard::data_join(out, x[[i]], join = "bind")
  }
  out
}


#' @export
display.report_table <- function(object, ...) {
  # fix caption
  if (is.null(list(...)$caption)) {
    attr(object, "no_caption") <- TRUE
  }
  class(object) <- c("report_table", "parameters_model", "data.frame")
  NextMethod()
}


# helper to create table captions and footer -----------------------

.report_table_caption <- function(x) {
  caption <- NULL

  # footer for htest objects
  if (!is.null(x$Method)) {
    caption <- x$Method
  }

  caption
}


.report_table_footer <- function(x) {
  footer <- NULL

  # footer for htest objects
  if (!is.null(x$Alternative)) {
    footer <- "Alternative hypothesis: "
    if (!is.null(x$null.value)) {
      if (length(x$null.value) == 1L) {
        alt.char <- switch(x$Alternative,
          two.sided = "not equal to",
          less = "less than",
          greater = "greater than"
        )
        footer <- paste0(footer, "true ", names(x$null.value), " is ", alt.char, " ", x$null.value)
      } else {
        footer <- paste0(footer, x$Alternative)
      }
    } else {
      footer <- paste0(footer, x$Alternative)
    }

    footer <- c(paste0("\n", footer), "blue")
  }

  footer
}


# Reexports models ------------------------

#' @importFrom insight display
#' @export
insight::display
