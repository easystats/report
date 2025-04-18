#' Reports of Structural Equation Models (SEM)
#'
#' Create a report for `lavaan` objects.
#'
#' @param x Object of class `lavaan`.
#' @inheritParams report
#' @inheritParams report.htest
#' @inheritParams report.lm
#'
#' @inherit report return seealso
#'
#' @examplesIf requireNamespace("lavaan", quietly = TRUE)
#' \donttest{
#' # Structural Equation Models (SEM)
#' library(lavaan)
#' structure <- "ind60 =~ x1 + x2 + x3
#'               dem60 =~ y1 + y2 + y3
#'               dem60 ~ ind60"
#' model <- lavaan::sem(structure, data = PoliticalDemocracy)
#' r <- report(model)
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#'
#' # Specific reports
#' suppressWarnings(report_table(model))
#' suppressWarnings(report_performance(model))
#' }
#' @return An object of class [report()].
#' @export
report.lavaan <- function(x, ...) {
  print("Support for lavaan not fully implemented yet :(")
}


#' @export
report_table.lavaan <- function(x, ...) {
  parameters <- parameters::model_parameters(x, ci_random = FALSE, ...)
  table <- as.data.frame(parameters)
  table$Parameter <- paste(table$To, table$Operator, table$From)
  table <- datawizard::data_remove(table, c("To", "Operator", "From"))
  table <- datawizard::data_reorder(table, "Parameter")

  # Combine -----
  # Add performance
  performance <- performance::model_performance(x, ...)
  table <- .combine_tables_performance(table, performance)
  table <- table[!tolower(table$Parameter) %in% c("baseline", "baseline_df", "baseline_p"), ]

  # Clean -----
  # Rename some columns

  # Shorten ----
  table_full <- datawizard::data_remove(table, "SE")
  table <- datawizard::data_remove(
    table_full,
    select = "(_CI_low|_CI_high)$",
    regex = TRUE
  )
  table <- table[!table$Parameter %in% c(
    "AIC", "BIC",
    "RMSEA"
  ), ]

  # Prepare -----
  out <- as.report_table(table_full,
    summary = table,
    performance = performance,
    parameters = parameters,
    ...
  )
  # Add attributes from params table
  for (att in "ci") {
    attr(out, att) <- attributes(parameters)[[att]]
  }

  out
}


#' @rdname report.lavaan
#' @export
report_performance.lavaan <- function(x, table = NULL, ...) {
  if (!is.null(table) || is.null(attributes(table)$performance)) {
    table <- report_table(x, ...)
  }
  performance <- attributes(table)$performance

  # Chi2
  text_chi2 <- ""
  if (all(c("p_Chi2", "Chi2", "Chi2_df") %in% names(performance))) {
    sig <- "significantly"
    if (performance$p_Chi2 > 0.05) {
      sig <- "not significantly"
    }
    text_chi2 <- paste0(
      text_chi2,
      "The model is ",
      sig,
      " different from a baseline model (Chi2(",
      insight::format_value(performance$Chi2_df, protect_integers = TRUE),
      ") = ",
      insight::format_value(performance$Chi2),
      ", ",
      insight::format_p(performance$p_Chi2), ")."
    )
  }

  perf_table <- effectsize::interpret(performance)
  text_full <- datawizard::text_paste(text_chi2, .text_performance_lavaan(perf_table), sep = " ")
  text <- datawizard::text_paste(text_chi2,
    .text_performance_lavaan(perf_table[perf_table$Name %in% c("RMSEA", "CFI", "SRMR"), ]),
    sep = " "
  )


  as.report_performance(text_full, summary = text)
}
