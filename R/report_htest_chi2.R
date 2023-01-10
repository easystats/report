# report_table -----------------

.report_table_chi2 <- function(table_full, effsize) {
  table_full <- cbind(table_full, attributes(effsize)$table)
  list(table = NULL, table_full = table_full)
}


# report_effectsize ---------------------

.report_effectsize_chi2 <- function(x, table, dot_args, type, rules = "funder2019") {
  if (grepl("Pearson", x$method, fixed = TRUE)) {
    args <- c(list(x), dot_args)
    table <- do.call(effectsize::effectsize, args)
    ci <- attributes(table)$ci
    estimate <- names(table)[1]
    rules <- ifelse(is.null(dot_args$rules), rules, dot_args$rules)

    args <- list(table, rules = rules, dot_args)
    interpretation <- do.call(effectsize::interpret, args)$Interpretation
    rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))
  } else if (grepl("given probabilities", x$method, fixed = TRUE)) {

  } else {
    stop(insight::format_message(
      "This test is not yet supported. Please open an issue at {.url https://github.com/easystats/report/issues}."
    ), call. = FALSE)
  }

  if (estimate %in% "Cramers_v_adjusted") {
    main <- paste0("Adjusted Cramer's v = ", insight::format_value(table[[estimate]]))
  } else if (estimate %in% "Tschuprows_t") {
    main <- paste0("Tschuprow's t = ", insight::format_value(table[[estimate]]))
  } else if (estimate %in% "Pearsons_c") {
    main <- paste0("Pearson's c = ", insight::format_value(table[[estimate]]))
  } else if (estimate %in% "phi_adjusted") {
    main <- paste0("Adjusted's Phi = ", insight::format_value(table[[estimate]]))
  } else if (estimate %in% "Cohens_h") {
    main <- paste0("Cohen's h = ", insight::format_value(table[[estimate]]))
  } else if (estimate %in% "Odds_ratio") {
    main <- paste0("Odds ratio = ", insight::format_value(table[[estimate]]))
  } else if (estimate %in% "Ris_kratio") {
    main <- paste0("Risk ratio = ", insight::format_value(table[[estimate]]))
  } else if (estimate %in% "cohens_h") {
    main <- paste0("Cohen's w = ", insight::format_value(table[[estimate]]))
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
