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
#' @examplesIf requireNamespace("modelbased", quietly = TRUE) && requireNamespace("emmeans", quietly = TRUE)
#' library(modelbased)
#' model <- lm(Sepal.Width ~ Species, data = iris)
#' contr <- estimate_contrasts(model)
#' report(contr)
#' @return An object of class [report()].
#' @export
report.estimate_contrasts <- function(x, ...) {
  table <- report_table(x, ...)
  text <- report_text(x, table = table, ...)

  as.report(text, table = table, ...)
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

  text <- paste0("The difference between ", x$Level1, " and ", x$Level2, " is ",
    ifelse(x$Difference < 0, " negative", "positive"), " and statistically ",
    ifelse(x$p < 0.05, "significant", "non-significant"),
    " (difference = ", f_table$Difference, ", 95% CI ", f_table$`95% CI`, ", ",
    names(f_table)[6], " = ", f_table[[6]], ", ", insight::format_p(table$p), ")",
    collapse = ". "
  )

  text <- paste("The marginal contrasts analysis suggests the following.", paste0(text, collapse = ""))

  as.report_text(text)
}
