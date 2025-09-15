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
#' x <- performance::compare_performance(m1, m2, m3)
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

report.compare_performance <- function(x, ...) {
  result_table <- report_table(x, ...)
  result_text <- report_text(x, ...)
  as.report(text = result_text, table = result_table, ...)
}

# report_table ------------------------------------------------------------

#' @rdname report.compare_performance
#' @export
report_table.compare_performance <- function(x, ...) {
  result_table <- x
  table_short <- x[!names(x) %in% c("Type", "Sigma")]
  as.report_table(result_table, summary = table_short)
}


# report_statistics ------------------------------------------------------------

#' @rdname report.compare_performance
#' @export

report_statistics.compare_performance <- function(x, table = NULL, ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }

  result_text <- text_short <- ""

  if ("R2" %in% names(table)) {
    result_text <- datawizard::text_paste(result_text, paste0("R2 = ", insight::format_value(table$R2)))
    if ("R2_adjusted" %in% names(table)) {
      result_text <- datawizard::text_paste(result_text, paste0("adj. R2 = ", insight::format_value(table$R2_adjusted)))
      text_short <- datawizard::text_paste(text_short, paste0("adj. R2 = ", insight::format_value(table$R2_adjusted)))
    } else {
      text_short <- datawizard::text_paste(result_text, paste0("R2 = ", insight::format_value(table$R2)))
    }
  }

  if ("AIC" %in% names(table)) {
    result_text <- datawizard::text_paste(result_text, paste0("AIC = ", insight::format_value(table$AIC)))
  }

  if ("BIC" %in% names(table)) {
    result_text <- datawizard::text_paste(result_text, paste0("BIC = ", insight::format_value(table$BIC)))
    text_short <- datawizard::text_paste(text_short, paste0("BIC = ", insight::format_value(table$BIC)))
  }

  if ("WAIC" %in% names(table)) {
    result_text <- datawizard::text_paste(result_text, paste0("WAIC = ", insight::format_value(table$WAIC)))
    text_short <- datawizard::text_paste(text_short, paste0("WAIC = ", insight::format_value(table$WAIC)))
  }

  if ("RMSE" %in% names(table)) {
    result_text <- datawizard::text_paste(result_text, paste0("RMSE = ", insight::format_value(table$RMSE)))
  }

  if ("Sigma" %in% names(table)) {
    result_text <- datawizard::text_paste(result_text, paste0("Sigma = ", insight::format_value(table$Sigma)))
  }

  as.report_statistics(result_text, summary = text_short, table = table)
}

# report_parameters ------------------------------------------------------------

#' @rdname report.compare_performance
#' @export
report_parameters.compare_performance <- function(x, table = NULL, ...) {
  stats <- report_statistics(x, table = table, ...)
  result_table <- attributes(stats)$table

  result_text <- paste0(result_table$Model, " (", stats, ")")
  text_short <- paste0(result_table$Model, " (", summary(stats), ")")

  as.report_parameters(result_text, summary = text_short, table = result_table)
}


# report_text ------------------------------------------------------------

#' @rdname report.compare_performance
#' @export

report_text.compare_performance <- function(x, table = NULL, ...) {
  stats <- report_statistics(x, table = table)
  result_table <- attributes(stats)$table

  # Get indices
  models <- result_table$Model
  result_text <- datawizard::text_concatenate(paste0(models, " (", stats, ")"))
  text_short <- datawizard::text_concatenate(paste0(models, " (", summary(stats), ")"))

  # Add intro sentence
  text_start <- paste0(
    "We compared ",
    insight::format_number(nrow(result_table)),
    " ",
    ifelse(length(unique(result_table$Type)) == 1, format_model(unique(result_table$Type)), "model"),
    "s"
  )
  result_text <- paste0(text_start, "; ", result_text, ".")
  text_short <- paste0(text_start, "; ", text_short, ".")

  as.report_text(result_text, summary = text_short)
}
