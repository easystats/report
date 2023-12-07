# report_table -----------------

.report_table_kruskal <- function(table_full, effsize) {
  table_full <- cbind(table_full, attributes(effsize)$table)
  list(table = NULL, table_full = table_full)
}


# report_effectsize ---------------------

.report_effectsize_kruskal <- function(x, table, dot_args, rules = "funder2019") {
  args <- c(list(x), dot_args)
  table <- do.call(effectsize::effectsize, args)
  ci <- attributes(table)$ci
  estimate <- names(table)[1]

  rules <- ifelse(is.null(dot_args$rules), rules, dot_args$rules)

  # same as Pearson's r
  args <- c(list(table$rank_epsilon_squared), dot_args)
  interpretation <- do.call(effectsize::interpret_epsilon_squared, args)
  rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))

  main <- paste0("Epsilon squared (rank) = ", insight::format_value(table$rank_epsilon_squared))
  statistics <- paste0(
    main,
    ", ",
    insight::format_ci(table$CI_low, table$CI_high, ci)
  )

  table <- table[names(table)[-2]]

  list(
    table = table, statistics = statistics, interpretation = interpretation,
    rules = rules, ci = ci, main = main
  )
}


# report_model ----------------------------

.report_model_kruskal <- function(x, table) {
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

.report_parameters_kruskal <- function(table, stats, effsize, ...) {
  text_full <- paste0(
    "statistically ",
    effectsize::interpret_p(table$p, rules = "default"),
    ", and ",
    attributes(effsize)$interpretation,
    " (",
    paste0("Kruskal-Wallis ", stats),
    ")"
  )

  text_short <- paste0(
    "statistically ",
    effectsize::interpret_p(table$p, rules = "default"),
    ", and ",
    attributes(effsize)$interpretation,
    " (",
    paste0("Kruskal-Wallis ", summary(stats)),
    ")"
  )

  list(text_short = text_short, text_full = text_full)
}
