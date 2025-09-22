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

# report_table -----------------

.report_table_correlation <- function(table_full) {
  cor_table <- datawizard::data_remove(table_full, c("t", "df_error"))
  list(table = cor_table, table_full = table_full)
}


# report_effectsize ---------------------

.report_effectsize_correlation <- function(x, dot_args) {
  param_args <- c(list(x), dot_args)
  cor_table <- do.call(parameters::parameters, param_args)
  ci <- attributes(cor_table)$ci
  estimate <- names(cor_table)[3]

  # Pearson
  interpret_args <- c(list(cor_table[[estimate]]), dot_args)
  interpretation <- do.call(effectsize::interpret_r, interpret_args)
  rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))
  main <- paste0(estimate, " = ", insight::format_value(cor_table[[estimate]]))

  if ("CI_low" %in% names(cor_table)) {
    statistics <- paste0(
      main,
      ", ",
      insight::format_ci(cor_table$CI_low, cor_table$CI_high, ci)
    )

    result_table <- cor_table[c(estimate, "CI_low", "CI_high")]

    # For Spearman and co.
  } else {
    statistics <- main
    result_table <- cor_table[estimate]
  }

  list(
    table = result_table, statistics = statistics, interpretation = interpretation,
    rules = rules, ci = ci, main = main
  )
}
