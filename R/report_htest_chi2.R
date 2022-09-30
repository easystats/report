# report_table -----------------

.report_table_chi2 <- function(table_full, effsize) {
  table_full <- cbind(table_full, attributes(effsize)$table)
  list(table = NULL, table_full = table_full)
}


# report_effectsize ---------------------

.report_effectsize_chi2 <- function(x, table, dot_args) {
  if (grepl("Pearson", x$method, fixed = TRUE)) {
    estimate <- "Cramers_v"
    effsize <- effectsize::cramers_v(x)[[estimate]]
    effectsize::interpret_cramers_v(effsize)
  } else if (grepl("given probabilities", x$method, fixed = TRUE)) {

  } else {
    stop(insight::format_message(
      "This test is not yet supported. Please open an issue at {.url https://github.com/easystats/report/issues}."
    ), call. = FALSE)
  }
}
