#' @export
model_text.htest <- function(model, effsize = "funder2019", ...){

  table <- model_table(model)$table_full

  if (insight::model_info(model)$is_correlation) {
    estimate <- c("rho", "r", "tau")[c("rho", "r", "tau") %in% names(table)]
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
      effectsize::interpret_r(table[[estimate]], rules = effsize),
      " (",
      estimate,
      " = ",
      insight::format_value(table[[estimate]]),
      ", ",
      parameters::format_p(table$p, stars = FALSE),
      ")."
    )
    text_full <- text
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
                      insight::format_value(model$estimate), collapse = ", "
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
      parameters::format_p(table$p, stars = FALSE),
      ") and can be considered as ",
      effectsize::interpret_d(table$Cohens_d, rules=effsize),
      " (Cohen's d = ",
      insight::format_value(table$Cohens_d),
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
      parameters::format_p(table$p, stars = FALSE),
      ", Cohen's d = ",
      insight::format_value(table$Cohens_d),
      ")."
    )
  } else {
    stop("reports not implemented for such h-tests yet.")
  }

  # Return output
  .model_text_return_output(text, text_full)
}
