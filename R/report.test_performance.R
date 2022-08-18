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
  table <- report_table(x, table = table, ...)
  text <- report_text(x, ...)
  as.report(text = text, table = table, ...)
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
    table <- report_table(x, ...)
  }

  text <- text_short <- ""
  if ("BF" %in% names(table)) {
    val <- text <- datawizard::text_paste(text, insight::format_bf(stats::na.omit(table$BF), exact = TRUE))
  }

  if ("Omega2" %in% names(table)) {
    val <- stats::na.omit(table$Omega2)
    text2 <- paste0(
      "Omega2 = ",
      insight::format_value(stats::na.omit(table$Omega2)),
      ", ",
      insight::format_p(stats::na.omit(table$p_Omega2))
    )
    text <- datawizard::text_paste(text, text2, sep = "; ")
  }

  if ("LR" %in% names(table)) {
    val <- stats::na.omit(table$LR)
    text2 <- paste0(
      "LR = ",
      insight::format_value(stats::na.omit(table$LR)),
      ", ",
      insight::format_p(stats::na.omit(table$p_LR))
    )
    text <- datawizard::text_paste(text, text2, sep = "; ")
  }

  as.report_statistics(text, summary = text_short, table = table)
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
  table <- attributes(stats)$table

  # Get indices
  models <- table$Model
  text <- datawizard::text_concatenate(paste0(models, " (", stats, ")"))
  text_short <- datawizard::text_concatenate(paste0(models, " (", summary(stats), ")"))

  # Add intro sentence
  text_start <- paste0(
    "We compared ",
    insight::format_number(nrow(table)),
    " ",
    ifelse(length(unique(table$Type)) == 1, format_model(unique(table$Type)), "model"),
    "s"
  )
  text <- paste0(text_start, "; ", text, ".")
  text_short <- paste0(text_start, "; ", text_short, ".")

  as.report_text(text, summary = text_short)
}
