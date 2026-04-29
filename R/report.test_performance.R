#' Reporting models comparison
#'
#' Create reports for model comparison as obtained by the
#' [performance::compare_performance()]
#' function in the `performance` package.
#'
#' @param x Object of class `NEW OBJECT`.
#' @inheritParams report
#' @inheritParams report.lm
#'
#' @inherit report return seealso
#'
#' @examples
#' \donttest{
#' library(report)
#' library(performance)
#'
#' m1 <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' m2 <- lm(Sepal.Length ~ Petal.Length + Species, data = iris)
#' m3 <- lm(Sepal.Length ~ Petal.Length, data = iris)
#'
#' x <- performance::test_performance(m1, m2, m3)
#' r <- report(x)
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#'
#' # Specific reports
#' report_table(x)
#' report_statistics(x)
#' report_parameters(x)
#' }
#' @return An object of class [report()].
#' @export
report.test_performance <- function(x, ...) {
  performance_table <- report_table(x, table = performance_table, ...)
  performance_text <- report_text(x, ...)
  as.report(text = performance_text, table = performance_table, ...)
}

# report_table ------------------------------------------------------------

#' @rdname report.test_performance
#' @export
report_table.test_performance <- function(x, ...) {
  as.report_table(x, summary = x, as_is = TRUE)
}


# report_statistics ------------------------------------------------------------

#' @rdname report.test_performance
#' @export
report_statistics.test_performance <- function(x, table = NULL, ...) {
  if (is.null(table)) {
    perf_table <- report_table(x, ...)
  }

  stats_text <- text_short <- ""
  if ("BF" %in% names(perf_table)) {
    bf_formatted <- insight::format_bf(
      stats::na.omit(perf_table$BF),
      exact = TRUE
    )
    val <- stats_text <- datawizard::text_paste(stats_text, bf_formatted)
  }

  if ("Omega2" %in% names(perf_table)) {
    val <- stats::na.omit(perf_table$Omega2)
    text2 <- paste0(
      "Omega2 = ",
      insight::format_value(stats::na.omit(perf_table$Omega2)),
      ", ",
      insight::format_p(stats::na.omit(perf_table$p_Omega2))
    )
    stats_text <- datawizard::text_paste(stats_text, text2, sep = "; ")
  }

  if ("LR" %in% names(perf_table)) {
    val <- stats::na.omit(perf_table$LR)
    text2 <- paste0(
      "LR = ",
      insight::format_value(stats::na.omit(perf_table$LR)),
      ", ",
      insight::format_p(stats::na.omit(perf_table$p_LR))
    )
    stats_text <- datawizard::text_paste(stats_text, text2, sep = "; ")
  }

  as.report_statistics(stats_text, summary = text_short, table = perf_table)
}

# report_parameters ------------------------------------------------------------

#' @rdname report.test_performance
#' @export
report_parameters.test_performance <- report_parameters.compare_performance


# report_text ------------------------------------------------------------

#' @rdname report.test_performance
#' @export
report_text.test_performance <- function(x, table = NULL, ...) {
  stats <- report_statistics(x, table = table)
  performance_table <- attributes(stats)$table

  # Get indices
  models <- performance_table$Model
  comparison_text <- datawizard::text_concatenate(paste0(
    models,
    " (",
    stats,
    ")"
  ))
  text_short <- datawizard::text_concatenate(paste0(
    models,
    " (",
    summary(stats),
    ")"
  ))

  # Add intro sentence
  text_start <- paste0(
    "We compared ",
    insight::format_number(nrow(performance_table)),
    " ",
    ifelse(
      length(unique(performance_table$Type)) == 1,
      format_model(unique(performance_table$Type)),
      "model"
    ),
    "s"
  )
  comparison_text <- paste0(text_start, "; ", comparison_text, ".")
  text_short <- paste0(text_start, "; ", text_short, ".")

  as.report_text(comparison_text, summary = text_short)
}
