#' Report the statistics of a model
#'
#' Creates a list containing a description of the parameters' values of R objects (see list of supported objects in \code{\link{report}}). Useful to insert in parentheses in plots or reports.
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return A \code{vector}.
#'
#' @examples
#' library(report)
#'
#' # Data
#' report_statistics(iris$Sepal.Length)
#' report_statistics(as.character(round(iris$Sepal.Length, 1)))
#' report_statistics(iris$Species)
#' report_statistics(iris)
#' @export
report_statistics <- function(x, table = NULL, ...) {
  UseMethod("report_statistics")
}


#' @export
report_statistics.default <- function(x, ...) {
  stop(paste0("report_statistics() is not available for objects of class ", class(x)))
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
