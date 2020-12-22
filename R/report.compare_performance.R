#' Reporting models comparison
#'
#' Create reports for model comparison as obtained by the \code{\link[performance:compare_performance]{performance::compare_performance()}} function in the \code{performance} package.
#'
#' @param x Object of class \code{NEW OBJECT}.
#' @inheritParams report
#'
#' @inherit report return seealso
#'
#' @examples
#' library(report)
#'
#' m1 <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' m2 <- lm(Sepal.Length ~ Petal.Length + Species, data = iris)
#' m3 <- lm(Sepal.Length ~ Petal.Length, data = iris)
#'
#' if(require("performance")){
#'   x <- performance::compare_performance(m1, m2, m3)
#'   r <- report(x)
#'   r
#'   # summary(r)
#'   # as.data.frame(r)
#'   # summary(as.data.frame(r))
#' }
#'
#' @export
report.compare_performance <- function(x, ...) {
  print("Support for compare_performance not fully implemented yet :(")
}


#' @rdname report.compare_performance
#' @export
report_table.compare_performance <- function(x, ...) {
  table <- x
  table_short <- x
  as.report_table(table, summary = table_short)
}