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



#' @importFrom effectsize effectsize interpret_eta_squared is_effectsize_name
#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_effectsize.aov <- function(x, ...) {

  table <- effectsize::effectsize(x, ...)
  estimate <- names(table)[effectsize::is_effectsize_name(names(table))]

  interpret <- effectsize::interpret_eta_squared(table[[estimate]], ...)
  interpretation <- interpret

  main <- paste0("Eta2 part. = ", insight::format_value(table[[estimate]]))

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
  row.names(table_full) <- NULL

  table <- data_remove(table_full, data_findcols(table_full, ends_with=c("_CI_low|_CI_high")))

  as.report_table(table_full, summary=table, ci=attributes(effsize)$ci)
}

#' @export
report_table.anova <- report_table.aov

#' @export
report_table.aovlist <- report_table.aov






# report_statistics ------------------------------------------------------------



#' @export
report_statistics.aov <- function(x, table=NULL, ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }

  parameters <- table[table$Parameter != "Residuals", ]
  if ("Group" %in% names(parameters)) {
    parameters <- parameters[parameters$Group == "Within", ]
  }

  # Get residuals' DoFs
  if ("Residuals" %in% table_full$Parameter) {
    DoF_residual <- table_full[table_full$Parameter == "Residuals", "df"]
  } else {
    DoF_residual <- NULL
  }

  # Text parameters
  text <- sapply(parameters$Parameter, .format_aov_varname, simplify = TRUE, USE.NAMES = FALSE)

  # DoFs
  text <- paste0(
    text,
    " is ",
    effectsize::interpret_p(parameters$p),
    " (F(",
    insight::format_value(parameters$df, protect_integers = TRUE)
  )

  if (!is.null(DoF_residual)) {
    text <- paste0(text, ", ", insight::format_value(DoF_residual, protect_integers = TRUE))
  } else if ("DoF_Residuals" %in% names(parameters)) {
    text <- paste0(text, ", ", insight::format_value(parameters$DoF_Residuals, protect_integers = TRUE))
  }

  # Indices
  text <- paste0(
    text,
    ") = ",
    insight::format_value(parameters$`F`),
    ", ",
    insight::format_p(parameters$p)
  )

  as.report_statistics(text, summary=text, estimate=table[[estimate]])
}

#' @export
report_statistics.anova <- report_statistics.aov

#' @export
report_statistics.aovlist <- report_statistics.aov
