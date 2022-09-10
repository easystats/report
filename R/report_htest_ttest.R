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


# report_table -----------------

.report_table_ttest <- function(table_full, effsize) {
  table_full <- cbind(table_full, attributes(effsize)$table)
  table <- datawizard::data_remove(
    table_full,
    c("Parameter", "Group", "Mean_Group1", "Mean_Group2", "Method")
  )
  list(table = table, table_full = table_full)
}
