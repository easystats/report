#' Report a descriptive table
#'
#' Creates tables to describe different objects (see list of supported objects in \code{\link{report}}).
#'
#' @inheritParams report
#'
#' @return A \code{data.frame}.
#'
#' @examples
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
#'
#' # Tests
#' # report_table(t.test(mpg ~ am, data = mtcars))
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
as.report_table.default <- function(x, summary = NULL, ...) {
  class(x) <- unique(c("report_table", class(x)))
  attributes(x) <- c(attributes(x), list(...))

  if (!is.null(summary)) {
    class(summary) <- unique(c("report_table", class(summary)))
    attr(x, "summary") <- summary
  }

  x
}

#' @export
as.report_table.report <- function(x, summary = NULL, ...) {
  if (is.null(summary) | isFALSE(summary)) {
    attributes(x)$table
  } else if (isTRUE(summary)) {
    summary(attributes(x)$table)
  }
}





#' @export
summary.report_table <- function(object, ...) {
  attributes(object)$summary
}


#' @export
print.report_table <- function(x, ...) {
  cat(insight::format_table(x, ...))
}
