#' ANOVAs Report
#'
#' Create a report of an ANOVA.
#'
#' @param x Object of class \code{aov}, \code{anova} or \code{aovlist}.
#' @inheritParams report
#' @inherit report return seealso
#'
#' @examples
#' data <- iris
#' data$Cat1 <- rep(c("A", "B"), length.out = nrow(data))
#' model <- aov(Sepal.Length ~ Species * Cat1, data = data)
#' r <- report(model)
#' r
#' as.data.frame(r)
#' @export
report.aov <- function(x, ...) {
  print("SOON")
}


#' @export
report.anova <- report.aov

#' @export
report.aovlist <- report.aov





# report_effectsize -------------------------------------------------------



#' @importFrom effectsize effectsize interpret_eta_squared
#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_effectsize.aov <- function(x, ...) {

  table <- effectsize::effectsize(x, ...)
  estimate <- names(table)[2]

  interpret <- effectsize::interpret_eta_squared(table[[estimate]], ...)
  interpretation <- interpret

  main <- paste0("partial Eta2 = ", insight::format_value(table[[estimate]]))

  ci <- table$CI
  statistics <- paste0(main,
                       ", ",
                       insight::format_ci(table$CI_low, table$CI_high, ci))

  table <- as.data.frame(table)[c("Parameter", estimate, "CI_low", "CI_high")]
  names(table)[3:ncol(table)] <- c(paste0(estimate, "_CI_low"), paste0(estimate, "_CI_high"))

  rules <- .text_effectsize(attributes(interpret)$rule_name)
  parameters <- paste0(interpretation, " (", statistics, ")")


  # Return output
  as.report_effectsize(parameters,
                       summary=parameters,
                       table=table,
                       interpretation=interpretation,
                       statistics=statistics,
                       rules=rules,
                       ci=ci,
                       main=main)
}

#' @export
report_effectsize.anova <- report_effectsize.aov

#' @export
report_effectsize.aovlist <- report_effectsize.aov



# report_table ------------------------------------------------------------



#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_table.aov <- function(x, ...) {

  effsize <- report_effectsize(x, ...)
  params <- parameters::model_parameters(x, ...)

  table_full <- merge(params, attributes(effsize)$table, all = TRUE)
  table_full <- table_full[order(params$Parameter, decreasing = TRUE), ]

  table <- data_remove(table_full, c("Parameter", "Group", "Mean_Group1", "Mean_Group2", "Method"))
  # Return output
  as.report_table(table_full, summary=table)
}

#' @export
report_table.anova <- report_table.aov

#' @export
report_table.aovlist <- report_table.aov