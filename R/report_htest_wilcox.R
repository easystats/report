# report_table -----------------

.report_table_wilcox <- function(table_full, effsize) {
  table_full <- cbind(table_full, attributes(effsize)$table)
  list(table = NULL, table_full = table_full)
}


# report_effectsize ---------------------

.report_effectsize_wilcox <- function(x, table, dot_args) {
  args <- c(list(x, rank_biserial = TRUE), dot_args)
  table <- do.call(parameters::parameters, args)
  ci <- attributes(table)$ci
  estimate <- "r_rank_biserial"

  # same as Pearson's r
  args <- c(list(table$r_rank_biserial), dot_args)
  interpretation <- do.call(effectsize::interpret_r, args)
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
