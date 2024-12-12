# report_table -----------------

.report_table_chi2 <- function(table_full, effsize) {
  table_full <- cbind(table_full, attributes(effsize)$table)
  list(table = NULL, table_full = table_full)
}


# report_effectsize ---------------------

.report_effectsize_chi2 <- function(x, table, dot_args, rules = "funder2019") {
  if (!chi2_type(x) %in% c("pearson", "probabilities")) {
    insight::format_error(
      "This test is not yet supported. Please open an issue at {.url https://github.com/easystats/report/issues}."
    )
  }
  es_args <- c(list(x), dot_args)
  table <- do.call(effectsize::effectsize, es_args)
  table_footer <- attributes(table)$table_footer
  ci <- attributes(table)$ci
  estimate <- names(table)[1]
  dot_args$rules <- ifelse(is.null(dot_args$rules), rules, dot_args$rules)

  es_args <- c(list(table), dot_args)
  interpretation <- do.call(effectsize::interpret, es_args)$Interpretation
  rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))

  main <- switch(estimate,
    Cramers_v_adjusted = paste0("Adjusted Cramer's v = ", insight::format_value(table[[estimate]])),
    Fei = paste0("Fei = ", insight::format_value(table[[estimate]])),
    Tschuprows_t = paste0("Tschuprow's t = ", insight::format_value(table[[estimate]])),
    Tschuprows_t_adjusted = paste0("Adjusted Tschuprow's t = ", insight::format_value(table[[estimate]])),
    Pearsons_c = paste0("Pearson's c = ", insight::format_value(table[[estimate]])),
    phi_adjusted = paste0("Adjusted Phi = ", insight::format_value(table[[estimate]])),
    Cohens_h = paste0("Cohen's h = ", insight::format_value(table[[estimate]])),
    Odds_ratio = paste0("Odds ratio = ", insight::format_value(table[[estimate]])),
    Ris_kratio = paste0("Risk ratio = ", insight::format_value(table[[estimate]])),
    cohens_h = paste0("Cohen's w = ", insight::format_value(table[[estimate]])),
    paste0(estimate, " = ", insight::format_value(table[[estimate]]))
  )

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
  attributes(table)$table_footer <- table_footer

  list(
    table = table, statistics = statistics, interpretation = interpretation,
    rules = rules, ci = ci, main = main
  )
}

# report_model ----------------------------

.report_model_chi2 <- function(x, table) {
  if (chi2_type(x) == "pearson") {
    type <- " of independence between"
    vars_full <- paste(names(attributes(x$observed)$dimnames), collapse = " and ")
  } else if (chi2_type(x) == "probabilities") {
    type <- " / goodness of fit of "
    distr <- ifelse(
      grepl("non", attr(table, "table_footer"), fixed = TRUE), "a uniform distribution",
      paste0("a distribution of [", paste0(
        names(x$expected), ": n=", x$expected,
        collapse = ", "
      ), "]")
    )

    vars_full <- paste(x$data.name, "to", distr)
  }

  paste0(
    trimws(x$method),
    type,
    paste0(" ", vars_full)
  )
}

chi2_type <- function(x) {
  if (grepl("probabilities", x$method, fixed = TRUE)) {
    out <- "probabilities"
  } else if (grepl("Pearson", x$method, fixed = TRUE)) {
    out <- "pearson"
  }
  out
}

# report_parameters ----------------------------

.report_parameters_chi2 <- function(table, stats, effsize, ...) {
  if (is.null(attributes(effsize)$interpretation)) {
    and <- ""
  } else {
    and <- paste0(", and ", attributes(effsize)$interpretation)
  }

  text_full <- paste0(
    "statistically ",
    effectsize::interpret_p(table$p, rules = "default"),
    and,
    " (",
    stats,
    ")"
  )

  text_short <- paste0(
    "statistically ",
    effectsize::interpret_p(table$p, rules = "default"),
    and,
    " (",
    summary(stats),
    ")"
  )

  list(text_short = text_short, text_full = text_full)
}
