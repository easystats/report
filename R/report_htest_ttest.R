# report_parameters -----------------

.report_parameters_ttest <- function(table, stats, effsize, ...) {
  text_full <- paste0(
    effectsize::interpret_direction(attributes(stats)$estimate),
    ", statistically ",
    effectsize::interpret_p(table$p, rules = "default"),
    ", and ",
    attributes(effsize)$interpretation,
    " (",
    stats,
    ")"
  )

  text_short <- paste0(
    effectsize::interpret_direction(attributes(stats)$estimate),
    ", statistically ",
    effectsize::interpret_p(table$p, rules = "default"),
    ", and ",
    attributes(effsize)$interpretation,
    " (",
    summary(stats),
    ")"
  )

  list(text_short = text_short, text_full = text_full)
}

.report_parameters_htest_default <- .report_parameters_ttest


# report_table -----------------

.report_table_ttest <- function(table_full, effsize) {
  table_full <- cbind(table_full, attributes(effsize)$table)
  table_small <- datawizard::data_remove(
    table_full,
    c("Parameter", "Group", "Mean_Group1", "Mean_Group2", "Method", "d_CI_low", "d_CI_high")
  )
  list(table = table_small, table_full = table_full)
}


# report_effectsize ---------------------

.report_effectsize_ttest <- function(x, table, dot_args, type, rules = "cohen1988") {
  es_args <- c(list(x), dot_args)
  table <- do.call(effectsize::effectsize, es_args)
  ci <- attributes(table)$ci
  estimate <- names(table)[1]
  dot_args$rules <- if (is.null(dot_args$rules)) rules else dot_args$rules

  es_args <- c(list(table), dot_args)
  interpretation <- do.call(effectsize::interpret, es_args)$Interpretation
  rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))

  if (estimate %in% c("d", "Cohens_d")) {
    main <- paste0("Cohen's d = ", insight::format_value(table[[estimate]]))
  } else if (estimate %in% c("g", "Hedges_g")) {
    main <- paste0("Hedges's g = ", insight::format_value(table[[estimate]]))
  } else {
    main <- paste0(estimate, " = ", insight::format_value(table[[estimate]]))
  }

  statistics <- paste0(
    main,
    ", ",
    insight::format_ci(table$CI_low, table$CI_high, ci)
  )

  table <- datawizard::data_rename(
    as.data.frame(table),
    select = c("CI_low", "CI_high"),
    replacement = paste0(estimate, c("_CI_low", "_CI_high"))
  )

  table <- table[c(estimate, paste0(estimate, c("_CI_low", "_CI_high")))]

  list(
    table = table, statistics = statistics, interpretation = interpretation,
    rules = rules, ci = ci, main = main
  )
}


# report model ---------------------------

.report_model_ttest <- function(x, table) {
  # If against mu
  if (names(x$null.value) == "mean") {
    # TODO: @DominiqueMakowski why do we need "table" here??

    table$Difference <- x$estimate - x$null.value
    means <- paste0(" (mean = ", insight::format_value(x$estimate), ")")
    vars_full <- paste0(x$data.name, means, " and mu = ", x$null.value)
    vars <- paste0(x$data.name, " and mu = ", x$null.value)

    # If between two groups
  } else {
    table$Difference <- x$estimate[1] - x$estimate[2]
    means <- paste0(names(x$estimate), " = ",
      insight::format_value(x$estimate),
      collapse = ", "
    )
    vars_full <- paste0(x$data.name, " (", means, ")")
    vars <- paste0(x$data.name)
  }

  final_text <- paste0(
    trimws(x$method),
    " testing the difference ",
    ifelse(grepl(" by ", x$data.name, fixed = TRUE), "of ", "between "),
    vars_full
  )

  final_text
}
