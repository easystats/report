#' Report the effect size(s) of a model or a test
#'
#' Computes, interpret and formats the effect sizes of a variety of models and statistical tests (see list of supported objects in \code{\link{report}}).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return An object of class \code{report_effectsize}.
#'
#' @examples
#' library(report)
#'
#' # h-tests
#' report_effectsize(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' @export
report_effectsize <- function(x, ...) {
  UseMethod("report_effectsize")
}


#' @export
report_effectsize.default <- function(x, ...) {
  stop(paste0("report_effectsize() is not available for objects of class ", class(x)))
}

# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_effectsize <- function(x, summary = NULL, prefix = "  - ", ...) {
  class(x) <- unique(c("report_effectsize", class(x)))
  attributes(x) <- c(attributes(x), list(...))
  attr(x, "prefix") <- prefix

  if (!is.null(summary)) {
    class(summary) <- unique(c("report_effectsize", class(summary)))
    attr(summary, "prefix") <- prefix
    attr(x, "summary") <- summary
  }
  x
}


#' @export
summary.report_effectsize <- summary.report_parameters


#' @export
print.report_effectsize <- function(x, ...) {
  cat(paste0(x, collapse = "\n"))
}
