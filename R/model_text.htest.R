#' @rdname report.htest
#' @seealso report
#' @importFrom insight format_ci format_value format_p model_info
#' @export
model_text.htest <- function(model, interpretation = "funder2019", ...) {
  table <- model_table(model)$table_long

  if (insight::model_info(model)$is_correlation) {
    estimate <- c("rho", "r", "tau")[c("rho", "r", "tau") %in% names(table)]

    # CI
    if (is.null(attributes(model$conf.int)$conf.level)) {
      ci_text <- ""
    } else {
      ci_text <- paste0(", ", insight::format_ci(table$CI_low, table$CI_high, ci = attributes(model$conf.int)$conf.level))
    }

    # Statistic
    if ("t" %in% names(table)) {
      stats_text <- paste0(", t(", insight::format_value(table$df, protect_integers = TRUE), ") = ", insight::format_value(table$t))
    } else if ("S" %in% names(table)) {
      stats_text <- paste0(", S = ", insight::format_value(table$S))
    } else {
      stats_text <- "D"
    }


    # Text
    text_full <- paste0(
      "The ",
      model$method,
      " between ",
      model$data.name,
      " is ",
      effectsize::interpret_direction(table[[estimate]]),
      ", ",
      effectsize::interpret_p(table$p),
      " and ",
      effectsize::interpret_r(table[[estimate]], rules = interpretation),
      " (",
      estimate,
      " = ",
      insight::format_value(table[[estimate]]),
      ci_text,
      stats_text,
      ", ",
      insight::format_p(table$p, stars = FALSE, digits = "apa"),
      ")."
    )
    text <- paste0(
      "The ",
      model$method,
      " between ",
      model$data.name,
      " is ",
      effectsize::interpret_direction(table[[estimate]]),
      ", ",
      effectsize::interpret_p(table$p),
      " and ",
      effectsize::interpret_r(table[[estimate]], rules = interpretation),
      " (",
      estimate,
      " = ",
      insight::format_value(table[[estimate]]),
      ci_text,
      ", ",
      insight::format_p(table$p, stars = FALSE, digits = "apa"),
      ")."
    )
  } else if (insight::model_info(model)$is_ttest) {

    # If against mu
    if (names(model$null.value) == "mean") {
      table$Difference <- model$estimate - model$null.value
      means <- paste0(
        " (mean = ",
        insight::format_value(model$estimate),
        ")"
      )
      vars_full <- paste0(model$data.name, means, " and mu = ", model$null.value)
      vars <- paste0(model$data.name, " and mu = ", model$null.value)

      # If between two groups
    } else {
      table$Difference <- model$estimate[1] - model$estimate[2]
      means <- paste0(names(model$estimate), " = ",
        insight::format_value(model$estimate),
        collapse = ", "
      )
      vars_full <- paste0(model$data.name, " (", means, ")")
      vars <- paste0(model$data.name)
    }

    text_full <- paste0(
      "The ",
      trimws(model$method),
      " suggests that the difference ",
      ifelse(grepl(" by ", model$data.name), "of ", "between "),
      vars_full,
      " is ",
      effectsize::interpret_p(model$p.value),
      " (difference = ",
      insight::format_value(table$Difference),
      ", ",
      insight::format_ci(model$conf.int[1], model$conf.int[2], ci = attributes(model$conf.int)$conf.level),
      ", t(",
      insight::format_value(model$parameter, protect_integers = TRUE),
      ") = ",
      insight::format_value(model$statistic),
      ", ",
      insight::format_p(table$p, stars = FALSE, digits = "apa"),
      ") and can be considered as ",
      effectsize::interpret_d(table$Cohens_d, rules = interpretation)[1],
      " (Cohen's d = ",
      insight::format_value(table$Cohens_d)$d,
      ")."
    )

    text <- paste0(
      "The ",
      trimws(model$method),
      " suggests that the difference ",
      ifelse(grepl(" by ", model$data.name), "of ", "between "),
      vars,
      " is ",
      effectsize::interpret_p(model$p.value),
      " (difference = ",
      insight::format_value(table$Difference),
      ", ",
      insight::format_ci(model$conf.int[1], model$conf.int[2], ci = attributes(model$conf.int)$conf.level),
      ", ",
      insight::format_p(table$p, stars = FALSE, digits = "apa"),
      ", Cohen's d = ",
      insight::format_value(table$Cohens_d),
      ")."
    )
  } else {
    stop("reports not implemented for such h-tests yet.")
  }

  # Return output
  as.model_text(text, text_full)
}
