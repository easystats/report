#' h-test (Correlation, t-test...) Report
#'
#' Create a report of an h-test object.
#'
#' @param model Object of class htest.
#' @param interpretation Effect size interpretation set of rules (see \link[effectsize]{interpret_d} and \link[effectsize]{interpret_r}).
#' @inheritParams report
#'
#'
#'
#' @examples
#' report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "spearman"))
#' report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "pearson"))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length, var.equal = TRUE))
#' report(t.test(mtcars$mpg ~ mtcars$vs))
#' report(t.test(iris$Sepal.Width, mu = 1))
#' @seealso report
#'
#' @importFrom insight format_ci
#'
#' @export
report.htest <- function(model, interpretation = "funder2019", ...) {
  tables <- model_table(model)
  texts <- model_text(model, interpretation = interpretation)

  out <- list(
    texts = texts,
    tables = tables
  )

  as.report(out, interpretation = interpretation, ...)
}
