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
report.array <- function(x,
                          n = FALSE,
                          centrality = "mean",
                          dispersion = TRUE,
                          range = TRUE,
                          distribution = FALSE,
                          levels_percentage = "auto",
                          digits = 2,
                          n_entries = 3,
                          missing_percentage = "auto",
                          ...) {
  x <- as.data.frame(x)
  report(x)
}
