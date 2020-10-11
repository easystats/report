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
#' report_table(iris$Species)
#' report_table(iris)
#'
#' # Tests
#' report_table(t.test(mpg ~ am, data = mtcars))
#' report_table(cor.test(iris$Sepal.Length, iris$Sepal.Width))
#' @export
report_table <- function(x, ...) {
  UseMethod("report_table")
}

#' @export
report_table.default <- function(x, ...) {
  stop(paste0("report_table() is not available for objects of class ", class(x)))
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
  if(is.null(attributes(object)$summary)){
    object
  } else{
    attributes(object)$summary
  }
}


#' @export
print.report_table <- function(x, ...) {
  cat(insight::format_table(parameters::parameters_table(x, ...), ...))
}
