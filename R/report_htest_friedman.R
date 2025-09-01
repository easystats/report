# report_table -----------------

.report_table_friedman <- function(table_full, effsize) {
  table_full <- cbind(table_full, attributes(effsize)$table)
  list(table = NULL, table_full = table_full)
}


# report_effectsize ---------------------

.report_effectsize_friedman <- function(x, dot_args) {
  args <- c(list(x, es_type = "kendalls_w"), dot_args)
  table <- do.call(parameters::parameters, args)
  ci <- attributes(table)$ci
  estimate <- "kendalls_w"

  # same as Pearson's r
  args <- c(list(table$Kendalls_W), dot_args)
  interpretation <- do.call(effectsize::interpret_kendalls_w, args)
  rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))

  main <- paste0("Kendall's W = ", insight::format_value(table$Kendalls_W))
  statistics <- paste0(
    main,
    ", ",
    insight::format_ci(table$W_CI_low, table$W_CI_high, ci)
  )

  table <- table[c("Kendalls_W", "W_CI_low", "W_CI_high")]

  list(
    table = table, statistics = statistics, interpretation = interpretation,
    rules = rules, ci = ci, main = main
  )
}


# report_model ----------------------------

.report_model_friedman <- function(x, table) {
  # two-sample
  if ("Parameter1" %in% names(table)) {
    vars_full <- paste0(table$Parameter1[[1]], ", and ", table$Parameter2[[1]])

    text <- paste0(
      trimws(x$method),
      " testing the difference in ranks between ",
      vars_full
    )
  } else {
    # one-sample
    vars_full <- paste0(table$Parameter[[1]])

    text <- paste0(
      trimws(x$method),
      " testing the difference in rank for ",
      vars_full,
      " and true location of 0"
    )
  }

  text
}

.report_parameters_friedman <- function(table, stats, effsize, ...) {
  text_full <- paste0(
    "statistically ",
    effectsize::interpret_p(table$p, rules = "default"),
    ", and in ",
    attributes(effsize)$interpretation,
    " (",
    stats,
    ")"
  )

  text_short <- paste0(
    "statistically ",
    effectsize::interpret_p(table$p, rules = "default"),
    ", and in ",
    attributes(effsize)$interpretation,
    " (",
    summary(stats),
    ")"
  )

  list(text_short = text_short, text_full = text_full)
}
