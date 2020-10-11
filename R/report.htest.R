#' Report of h-tests (Correlation, t-test...)
#'
#' Create a report of an h-test object (\code{t.test(), \code{cor.test()}}).
#'
#' @param x Object of class htest.
#' @param interpretation Effect size interpretation set of rules (see \link[effectsize]{interpret_d} and \link[effectsize]{interpret_r}).
#' @inheritParams report
#' @inherit report return seealso
#'
#' @examples
#' report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "spearman"))
#' report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "pearson"))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length, var.equal = TRUE))
#' report(t.test(mtcars$mpg ~ mtcars$vs))
#' report(t.test(iris$Sepal.Width, mu = 1))
#' @importFrom insight format_ci
#' @export
report.htest <- function(x, ...) {
  print("SOON")
}





# report_effectsize -------------------------------------------------------


#' @seealso report
#' @importFrom effectsize effectsize
#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_effectsize.htest <- function(x, ...) {

  # For t-tests, or correlations
  if (insight::model_info(x)$is_ttest) {
    table <- effectsize::effectsize(x, ...)
    interpret <- effectsize::interpret_d(table$d, ...)
    table$Size <- interpret
  } else{
    table <- parameters::model_parameters(x, ...)[c("r", "CI_low", "CI_high")]
    interpret <- effectsize::interpret_r(table$r, ...)
    table$Size <- interpret
  }
  rules <- attributes(interpret)$rules

  # Return output
  as.report_effectsize(table, summary=table)
}






#' @seealso report
#' @importFrom effectsize effectsize
#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
# report_table.htest <- function(x, ...) {
#   table_full <- parameters::model_parameters(model, ...)
#
#   # If t-test, effect size
#   if (insight::model_info(model)$is_ttest) {
#     table_full$Cohens_d <- effectsize::effectsize(x, ...)
#   }
#
#
#   table <- data_remove(table_full, c("Parameter", "Group", "Mean_Group1", "Mean_Group2", "Method"))
#   # Return output
#   as.report_table(table_full, summary=table)
# }
