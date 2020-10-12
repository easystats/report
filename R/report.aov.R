#' ANOVAs Report
#'
#' Create a report of an ANOVA.
#'
#' @param x Object of class \code{aov}, \code{anova} or \code{aovlist}.
#' @inherit report return seealso
#'
#' @examples
#' data <- iris
#' data$Cat1 <- rep(c("A", "B"), length.out = nrow(data))
#' model <- aov(Sepal.Length ~ Species * Cat1, data = data)
#' r <- report(model)
#' r
#' table_short(r)
#' @export
report.aov <- function(x, ...) {
  print("SOON")
}


#' @export
report.anova <- report.aov

#' @export
report.aovlist <- report.aov





# report_effectsize -------------------------------------------------------



#' @importFrom effectsize effectsize interpret_r interpret_d
#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_effectsize.aov <- function(x, ...) {

  # table <- effectsize::effectsize(x, ...)
  # estimate <- names(table)[1]
  #
  # # For t-tests, or correlations
  # if (insight::model_info(x)$is_ttest) {
  #
  #   interpret <- effectsize::interpret_d(table[[estimate]], ...)
  #   interpretation <- interpret
  #   main <- paste0("Cohen's d = ", insight::format_value(table[[estimate]]))
  #   statistics <- paste0(main,
  #                        ", ",
  #                        insight::format_ci(table$CI_low, table$CI_high, table$CI))
  #   table <- data_rename(as.data.frame(table), c("CI_low", "CI_high"), c("d_CI_low", "d_CI_high"))
  #   table <- data_reorder(table, c("d", "d_CI_low", "d_CI_high"))
  # } else{
  #   interpret <- effectsize::interpret_r(table[[estimate]], ...)
  #   interpretation <- interpret
  #   main <- paste0(estimate, " = ", insight::format_value(table[[estimate]]))
  #   statistics <- paste0(main,
  #                        ", ",
  #                        insight::format_ci(table$CI_low, table$CI_high, attributes(table)$ci))
  #   table <- data_reorder(table, c("r", "CI_low", "CI_high"))
  # }
  # rules <- .text_effectsize(attributes(interpret)$rule_name)
  # parameters <- paste0(interpretation, " (", statistics, ")")
  #
  #
  # # Return output
  # as.report_effectsize(parameters,
  #                      summary=parameters,
  #                      table=table[1:3],
  #                      interpretation=interpretation,
  #                      statistics=statistics,
  #                      rules=rules,
  #                      ci=unique(table$CI),
  #                      main=main)
}

#' @export
report_effectsize.anova <- report_effectsize.aov

#' @export
report_effectsize.aovlist <- report_effectsize.aov
