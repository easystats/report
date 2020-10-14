#' Report the model type
#'
#' Reports the type of different R objects (see list of supported objects in \code{\link{report}}).
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
#' report_model(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report_model(cor.test(iris$Sepal.Width, iris$Sepal.Length))
#'
#' # ANOVA
#' report_model(aov(Sepal.Length ~ Species, data=iris))
#' @export
report_model <- function(x, table = NULL, ...) {
  UseMethod("report_model")
}


#' @export
report_model.default <- function(x, ...) {
  stop(paste0("report_model() is not available for objects of class ", class(x)))
}

# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_model <- function(x, summary = NULL, ...) {
  class(x) <- unique(c("report_model", class(x)))
  attributes(x) <- c(attributes(x), list(...))

  if (!is.null(summary)) {
    attr(x, "summary") <- summary
  }
  x
}


#' @export
summary.report_model <- function(object, ...) {
  if(is.null(attributes(object)$summary)){
    object
  } else{
    attributes(object)$summary
  }
}

#' @export
print.report_model <- function(x, ...) {
  cat(paste0(x, collapse = "\n"))
}
