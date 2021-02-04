#' Reporting models comparison
#'
#' Create reports for model comparison as obtained by the \code{\link[performance:compare_performance]{performance::compare_performance()}} function in the \code{performance} package.
#'
#' @param x Object of class \code{NEW OBJECT}.
#' @inheritParams report
#' @inheritParams report.lm
#'
#' @inherit report return seealso
#'
#' @examples
#' library(report)
#'
#' m1 <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' m2 <- lm(Sepal.Length ~ Petal.Length + Species, data = iris)
#' m3 <- lm(Sepal.Length ~ Petal.Length, data = iris)
#'
#' if (require("performance")) {
#'   x <- performance::test_performance(m1, m2, m3)
#'   # r <- report(x)
#'   # r
#'   # summary(r)
#'   # as.data.frame(r)
#'   # summary(as.data.frame(r))
#'
#'   # Specific reports
#'   report_table(x)
#'   report_statistics(x)
#'   report_parameters(x)
#' }
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
    val <- text <- text_paste(text, insight::format_bf(na.omit(table$BF)))
  }

  if ("Omega2" %in% names(table)) {
    val <- na.omit(table$Omega2)
    text2 <- paste0(
      "Omega2 = ",
      insight::format_value(na.omit(table$Omega2)),
      ", ",
      insight::format_p(na.omit(table$p_Omega2))
    )
    text <- text_paste(text, text2, sep = "; ")
  }

  if ("LR" %in% names(table)) {
    val <- na.omit(table$LR)
    text2 <- paste0(
      "LR = ",
      insight::format_value(na.omit(table$LR)),
      ", ",
      insight::format_p(na.omit(table$p_LR))
    )
    text <- text_paste(text, text2, sep = "; ")
  }

  as.report_statistics(text, summary = text_short, table = table)
}

# report_parameters ------------------------------------------------------------

#' @rdname report.test_performance
#' @export
report_parameters.test_performance <- report_parameters.compare_performance


# report_performance ------------------------------------------------------------

# #' @rdname report.test_performance
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

#' @rdname report.test_performance
#' @export
report_text.test_performance <- function(x, table = NULL, ...) {
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
