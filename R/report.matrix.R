#' Reporting Matrices
#'
#' Create reports for matrices.
#'
#' @inheritParams report.data.frame
#'
#' @examples
#' library(report)
#'
#' r <- report(WorldPhones)
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#' @return An object of class [report()].
#' @export
report.matrix <- function(x, ...) {
  x <- as.data.frame(x)
  report(x, ...)
}
