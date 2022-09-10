.report_parameters_htest_correlation <- function(table, stats, ...) {
  text_full <- paste0(
    effectsize::interpret_direction(attributes(stats)$estimate),
    ", statistically ",
    effectsize::interpret_p(table$p, rules = "default"),
    ", and ",
    effectsize::interpret_r(attributes(stats)$estimate, ...),
    " (",
    stats,
    ")"
  )

  text_short <- text_full
  list(text_short = text_short, text_full = text_full)
}


.report_parameters_htest_ttest <- function(table, stats, effsize, ...) {
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


.report_parameters_htest_default <- .report_parameters_htest_ttest
