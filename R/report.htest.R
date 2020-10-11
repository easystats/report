#' Report of h-tests (Correlation, t-test...)
#'
#' Create a report of an h-test object (\code{t.test()}, \code{cor.test()}).
#'
#' @param x Object of class htest.
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
#' @importFrom effectsize effectsize interpret_r interpret_d
#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_effectsize.htest <- function(x, ...) {

  # For t-tests, or correlations
  if (insight::model_info(x)$is_ttest) {
    table <- effectsize::effectsize(x, ...)
    interpret <- effectsize::interpret_d(table$d, ...)
    interpretation <- interpret
    statistics <- paste0("d = ",
                         insight::format_value(table$d),
                         ", ",
                         insight::format_ci(table$CI_low, table$CI_high, table$CI))
    table <- data_rename(as.data.frame(table), c("CI_low", "CI_high"), c("d_CI_low", "d_CI_high"))
    table <- data_reorder(table, c("d", "d_CI_low", "d_CI_high"))
  } else{
    table <- parameters::model_parameters(x, ...)
    interpret <- effectsize::interpret_r(table$r, ...)
    interpretation <- interpret
    statistics <- paste0("r = ",
                         insight::format_value(table$r),
                         ", ",
                         insight::format_ci(table$CI_low, table$CI_high, attributes(table)$ci))
    table <- data_reorder(table, c("r", "CI_low", "CI_high"))
  }
  rules <- .text_effectsize(attributes(interpret)$rule_name)
  parameters <- paste0(interpretation, " (", statistics, ")")


  # Return output
  as.report_effectsize(parameters,
                       summary=parameters,
                       table=table[1:3, ],
                       statistics=statistics,
                       rules=rules,
                       ci=unique(table$CI))
}






#' @seealso report
#' @importFrom effectsize effectsize interpret
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
