# report_parameters -----------------

.report_parameters_correlation <- function(table, stats, ...) {
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
