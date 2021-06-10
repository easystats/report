#' Reporting models comparison
#'
#' Create reports for model comparison as obtained by the
#' \code{\link[performance:compare_performance]{performance::compare_performance()}}
#' function in the \code{performance} package.
#'
#' @param x Object of class \code{NEW OBJECT}.
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
#' @return An object of class \code{\link{report}}.
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
    text <- text_paste(text, paste0("R2 = ", insight::format_value(table$R2)))
    if ("R2_adjusted" %in% names(table)) {
      text <- text_paste(text, paste0("adj. R2 = ", insight::format_value(table$R2_adjusted)))
      text_short <- text_paste(text_short, paste0("adj. R2 = ", insight::format_value(table$R2_adjusted)))
    } else {
      text_short <- text_paste(text, paste0("R2 = ", insight::format_value(table$R2)))
    }
  }

  if ("AIC" %in% names(table)) {
    text <- text_paste(text, paste0("AIC = ", insight::format_value(table$AIC)))
  }

  if ("BIC" %in% names(table)) {
    text <- text_paste(text, paste0("BIC = ", insight::format_value(table$BIC)))
    text_short <- text_paste(text_short, paste0("BIC = ", insight::format_value(table$BIC)))
  }

  if ("WAIC" %in% names(table)) {
    text <- text_paste(text, paste0("WAIC = ", insight::format_value(table$WAIC)))
    text_short <- text_paste(text_short, paste0("WAIC = ", insight::format_value(table$WAIC)))
  }

  if ("RMSE" %in% names(table)) {
    text <- text_paste(text, paste0("RMSE = ", insight::format_value(table$RMSE)))
  }

  if ("Sigma" %in% names(table)) {
    text <- text_paste(text, paste0("Sigma = ", insight::format_value(table$Sigma)))
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


# report_performance ------------------------------------------------------------

# #' @rdname report.compare_performance
# #' @export
# report_performance.compare_performance <- function(x, table = NULL, ...) {
#   stats <- report_statistics(x, table = table, ...)
#   table <- attributes(stats)$table
#
#   models <- table$Model
#
#   text <- ""
#   text_short <- ""
#   # if("p" %in% names(table)){
#   #   p <- effectsize::interpret_p(table$p)[-1]
#   #   text <- paste0(
#   #     models[-1],
#   #     " (",
#   #     stats[-1],
#   #     ") has a ",
#   #     p,
#   #     "ly different explanatory power from ",
#   #     models[1],
#   #     " (",
#   #     stats[1],
#   #     ", ",
#   #     insight::format_p(table$p)[-1],
#   #     ")")
#   #   text_short <- paste0(
#   #     models[-1],
#   #     " (",
#   #     summary(stats)[-1],
#   #     ") has a ",
#   #     p,
#   #     "ly different explanatory power from ",
#   #     models[1],
#   #     " (",
#   #     summary(stats)[1],
#   #     ", ",
#   #     insight::format_p(table$p)[-1],
#   #     ")")
#   # }
#   #
#   # if("BF" %in% names(table)){
#   #   bfs <- effectsize::interpret_bf(table$BF, include_value = TRUE, exact = FALSE)[-1]
#   #   text_bf <- paste0(bfs,
#   #               " the hypothesis that ",
#   #               models[-1],
#   #               " has a stronger predictive power than ",
#   #               models[1])
#   #   text <- text_paste(text, text_bf, sep=", and there is ")
#   #   text_short <- text_paste(text_short, text_bf, sep=", and there is ")
#   # }
#
#   as.report_performance(text, summary = text_short, table = table)
# }




# report_text ------------------------------------------------------------

#' @rdname report.compare_performance
#' @export

report_text.compare_performance <- function(x, table = NULL, ...) {
  stats <- report_statistics(x, table = table)
  table <- attributes(stats)$table

  # Get indices
  models <- table$Model
  text <- text_concatenate(paste0(models, " (", stats, ")"))
  text_short <- text_concatenate(paste0(models, " (", summary(stats), ")"))

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


  # if("p" %in% names(table)){
  #   p <- effectsize::interpret_p(table$p)[-1]
  #   text <- paste0(
  #     p,
  #     "ly different from ",
  #     models[-1],
  #     " (",
  #     stats[-1],
  #     ", ",
  #     insight::format_p(table$p)[-1],
  #     ")")
  #   text_short <- paste0(
  #     p,
  #     "ly different from ",
  #     models[-1],
  #     " (",
  #     summary(stats)[-1],
  #     ", ",
  #     insight::format_p(table$p)[-1],
  #     ")")
  # }

  # text <- paste0(
  #   "Regarding the explanatory power, ",
  #   models[1],
  #   " (",
  #   stats[1],
  #   ") is ",
  #   text_concatenate(text))
  # text_short <- paste0(
  #   "Regarding the explanatory power, ",
  #   models[1],
  #   " (",
  #   summary(stats)[1],
  #   ") is ",
  #   text_concatenate(text_short))


  # if("BF" %in% names(table)){
  #   bfs <- effectsize::interpret_bf(table$BF, include_value = TRUE, exact = FALSE)[-1]
  #   t <- paste0(bfs,
  #               " the superiority of ",
  #               models[-1],
  #               " compared to ",
  #               models[1])
  #   text_bf <- paste0(
  #     "Regarding the predictive power, there is ",
  #     text_concatenate(t))
  #
  #   text <- text_paste(text, text_bf, sep = ". ")
  #   text_short <- text_paste(text_short, text_bf, sep = ". ")
  # }

  as.report_text(text, summary = text_short)
}
