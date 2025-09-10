#' Reporting `estimate_contrasts` objects
#'
#' Create reports for `estimate_contrasts` objects.
#'
#' @param x Object of class `estimate_contrasts`.
#' @param table Provide the output of  `report_table()` to avoid its
#'   re-computation.
#' @inheritParams report
#'
#' @inherit report return seealso
#'
#' @examplesIf all(insight::check_if_installed(c("modelbased", "marginaleffects", "collapse", "Formula")))
#' library(modelbased)
#' model <- lm(Sepal.Width ~ Species, data = iris)
#' contr <- estimate_contrasts(model)
#' report(contr)
#' @return An object of class [report()].
#' @export
report.estimate_contrasts <- function(x, ...) {
  report_table_obj <- report_table(x, ...)
  report_text_obj <- report_text(x, table = report_table_obj, ...)

  as.report(report_text_obj, table = report_table_obj, ...)
}

# report_table ------------------------------------------------------------

#' @rdname report.estimate_contrasts
#' @export
report_table.estimate_contrasts <- function(x, ...) {
  as.report_table(x)
}

# report_text ------------------------------------------------------------

#' @rdname report.estimate_contrasts
#' @export
report_text.estimate_contrasts <- function(x, table = NULL, ...) {
  f_table <- insight::format_table(table)

  report_text_obj <- paste0("The difference between ", x$Level1, " and ", x$Level2, " is ",
    ifelse(x$Difference < 0, " negative", "positive"), " and statistically ",
    ifelse(x$p < 0.05, "significant", "non-significant"),
    " (difference = ", f_table$Difference, ", 95% CI ", f_table$`95% CI`, ", ",
    names(f_table)[6], " = ", f_table[[6]], ", ", insight::format_p(table$p), ")",
    collapse = ". "
  )

  report_text_obj <- paste(
    "The marginal contrasts analysis suggests the following.",
    paste(report_text_obj, collapse = "")
  )

  as.report_text(report_text_obj)
}
