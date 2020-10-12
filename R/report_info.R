#' Report additional information
#'
#' Reports additional information relevant to the report (see list of supported objects in \code{\link{report}}).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return A \code{character} string.
#'
#' @examples
#' library(report)
#'
#' # h-tests
#' report_info(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report_info(cor.test(iris$Sepal.Width, iris$Sepal.Length))
#' @export
report_info <- function(x, ...) {
  UseMethod("report_info")
}


#' @export
report_info.default <- function(x, ...) {
  stop(paste0("report_info() is not available for objects of class ", class(x)))
}

# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_info <- function(x, summary = NULL, ...) {
  class(x) <- unique(c("report_info", class(x)))
  attributes(x) <- c(attributes(x), list(...))

  if (!is.null(summary)) {
    attr(x, "summary") <- summary
  }
  x
}


#' @export
summary.report_info <- function(object, ...) {
  if(is.null(attributes(object)$summary)){
    object
  } else{
    attributes(object)$summary
  }
}

#' @export
print.report_info <- function(x, ...) {
  cat(paste0(x, collapse = "\n"))
}
