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
  table <- datawizard::data_remove(
    table_full,
    c("Parameter", "Group", "Mean_Group1", "Mean_Group2", "Method")
  )
  list(table = table, table_full = table_full)
}


# report_effectsize ---------------------

.report_effectsize_ttest <- function(x, table, dot_args) {
  args <- c(list(x), dot_args)
  table <- do.call(effectsize::cohens_d, args)
  ci <- attributes(table)$ci
  estimate <- names(table)[1]

  args <- c(list(table[[estimate]]), dot_args)
  interpretation <- do.call(effectsize::interpret_cohens_d, args)
  rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))

  if (estimate %in% c("d", "Cohens_d")) {
    main <- paste0("Cohen's d = ", insight::format_value(table[[estimate]]))
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
    c("CI_low", "CI_high"),
    paste0(estimate, c("_CI_low", "_CI_high"))
  )

  table <- table[c(estimate, paste0(estimate, c("_CI_low", "_CI_high")))]

  list(
    table = table, statistics = statistics, interpretation = interpretation,
    rules = rules, ci = ci, main = main
  )
}
