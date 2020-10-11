#' Report a textual description of an object
#'
#' Creates text containing a description of the parameters of R objects (see list of supported objects in \code{\link{report}}).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @param table A table obtained via \code{report_table()}. If not provided, will run it.
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
#' @export
report_text <- function(x, table=NULL, ...) {
  UseMethod("report_text")
}


#' @export
report_text.default <- function(x, ...) {
  stop(paste0("report_text() is not available for objects of class ", class(x)))
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
  attributes(object)$summary
}

#' @export
print.report_text <- function(x, width = NULL, ...) {
  x <- format_text(as.character(x), width = width, ...)
  cat(x)
}


#' @export
print.report <- print.report_text
