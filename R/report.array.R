#' Reporting Arrays
#'
#' Create reports for arrays.
#'
#' @inheritParams report.data.frame
#'
#' @examples
#' library(report)
#'
#' r <- report(iris3)
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#' @return An object of class [report()].
#' @export
report.array <- function(x, ...) {
  x <- as.data.frame(x)
  report(x, ...)
}
