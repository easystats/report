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
  table <- report_table(x, table = table, ...)
  text <- report_text(x, ...)
  as.report(text = text, table = table, ...)
}

# report_table ------------------------------------------------------------

#' @rdname report.compare_performance
#' @export
report_table.compare_performance <- function(x, ...) {
  table <- x
  table_short <- x[!names(x) %in% c("Type", "Sigma")]
  as.report_table(table, summary = table_short)
}


# report_statistics ------------------------------------------------------------

#' @rdname report.compare_performance
#' @export

report_statistics.compare_performance <- function(x, table = NULL, ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }

  text <- text_short <- ""

  if ("R2" %in% names(table)) {
    text <- datawizard::text_paste(text, paste0("R2 = ", insight::format_value(table$R2)))
    if ("R2_adjusted" %in% names(table)) {
      text <- datawizard::text_paste(text, paste0("adj. R2 = ", insight::format_value(table$R2_adjusted)))
      text_short <- datawizard::text_paste(text_short, paste0("adj. R2 = ", insight::format_value(table$R2_adjusted)))
    } else {
      text_short <- datawizard::text_paste(text, paste0("R2 = ", insight::format_value(table$R2)))
    }
  }

  if ("AIC" %in% names(table)) {
    text <- datawizard::text_paste(text, paste0("AIC = ", insight::format_value(table$AIC)))
  }

  if ("BIC" %in% names(table)) {
    text <- datawizard::text_paste(text, paste0("BIC = ", insight::format_value(table$BIC)))
    text_short <- datawizard::text_paste(text_short, paste0("BIC = ", insight::format_value(table$BIC)))
  }

  if ("WAIC" %in% names(table)) {
    text <- datawizard::text_paste(text, paste0("WAIC = ", insight::format_value(table$WAIC)))
    text_short <- datawizard::text_paste(text_short, paste0("WAIC = ", insight::format_value(table$WAIC)))
  }

  if ("RMSE" %in% names(table)) {
    text <- datawizard::text_paste(text, paste0("RMSE = ", insight::format_value(table$RMSE)))
  }

  if ("Sigma" %in% names(table)) {
    text <- datawizard::text_paste(text, paste0("Sigma = ", insight::format_value(table$Sigma)))
  }

  as.report_statistics(text, summary = text_short, table = table)
}

# report_parameters ------------------------------------------------------------

#' @rdname report.compare_performance
#' @export
report_parameters.compare_performance <- function(x, table = NULL, ...) {
  stats <- report_statistics(x, table = table, ...)
  table <- attributes(stats)$table

  text <- paste0(table$Model, " (", stats, ")")
  text_short <- paste0(table$Model, " (", summary(stats), ")")

  as.report_parameters(text, summary = text_short, table = table)
}


# report_text ------------------------------------------------------------

#' @rdname report.compare_performance
#' @export

report_text.compare_performance <- function(x, table = NULL, ...) {
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
