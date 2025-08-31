# report_table -----------------

.report_table_wilcox <- function(table_full, effsize) {
  table_full <- cbind(table_full, attributes(effsize)$table)
  list(table = NULL, table_full = table_full)
}


# report_effectsize ---------------------

.report_effectsize_wilcox <- function(x, dot_args) {
  my_args <- c(list(x, es_type = "rank_biserial"), dot_args)
  table <- do.call(parameters::model_parameters, my_args)
  ci <- attributes(table)$ci
  estimate <- "r_rank_biserial"

  # same as Pearson's r
  my_args <- c(list(table$r_rank_biserial), dot_args)
  interpretation <- do.call(effectsize::interpret_r, my_args)
  rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))

  main <- paste0("r (rank biserial) = ", insight::format_value(table$r_rank_biserial))
  statistics <- paste0(
    main,
    ", ",
    insight::format_ci(table$rank_biserial_CI_low, table$rank_biserial_CI_high, ci)
  )

  table <- table[c("r_rank_biserial", "rank_biserial_CI_low", "rank_biserial_CI_high")]

  list(
    table = table, statistics = statistics, interpretation = interpretation,
    rules = rules, ci = ci, main = main
  )
}


# report_model ----------------------------

.report_model_wilcox <- function(x, table) {
  # two-sample
  if ("Parameter1" %in% names(table)) {
    vars_full <- paste0(table$Parameter1[[1]], " and ", table$Parameter2[[1]])

    text_string <- paste0(
      trimws(x$method),
      " testing the difference in ranks between ",
      vars_full
    )
  } else {
    # one-sample
    vars_full <- paste0(table$Parameter[[1]])

    text_string <- paste0(
      trimws(x$method),
      " testing the difference in rank for ",
      vars_full,
      " and true location of 0"
    )
  }

  text_string
}
