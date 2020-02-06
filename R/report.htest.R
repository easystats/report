#' h-test (Correlation, t-test...) Report
#'
#' Create a report of an h-test object.
#'
#' @param model Object of class htest.
#' @param effsize Effect size interpretation set of rules.
#' @param ... Arguments passed to or from other methods.
#'
#'
#'
#' @examples
#' report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "spearman"))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length, var.equal = TRUE))
#' report(t.test(mtcars$mpg ~ mtcars$vs))
#' report(t.test(iris$Sepal.Width, mu = 1))
#' @seealso report
#'
#' @importFrom insight format_ci
#'
#' @export
report.htest <- function(model, effsize = "cohen1988", ...) {

  table <- model_table(model)
  text <- model_text(model, effsize=effsize)

  out <- list(
    text = text,
    table = table
  )

  return(as.report(out, effsize = effsize, ...))
}
