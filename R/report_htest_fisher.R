# report_table -----------------

.report_table_fisher <- function(table_full, effsize) {
  table_full <- cbind(table_full, attributes(effsize)$table)
  list(table = NULL, table_full = table_full)
}


# report_effectsize ---------------------

.report_effectsize_fisher <- function(x, table, dot_args, rules = "funder2019") {
  args <- c(list(x), dot_args)
  table <- do.call(effectsize::effectsize, args)
  ci <- attributes(table)$ci
  estimate <- names(table)[1]
  rules <- ifelse(is.null(dot_args$rules), rules, dot_args$rules)

  args <- list(table, rules = rules, dot_args)
  interpretation <- do.call(effectsize::interpret, args)$Interpretation
  rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))

  if (estimate == "Cramers_v_adjusted") {
    main <- paste0("Adjusted Cramer's v = ", insight::format_value(table[[estimate]]))
  } else if (estimate == "Tschuprows_t") {
    main <- paste0("Tschuprow's t = ", insight::format_value(table[[estimate]]))
  } else if (estimate == "Tschuprows_t_adjusted") {
    main <- paste0("Adjusted Tschuprow's t = ", insight::format_value(table[[estimate]]))
  } else if (estimate == "Pearsons_c") {
    main <- paste0("Pearson's c = ", insight::format_value(table[[estimate]]))
  } else if (estimate == "phi_adjusted") {
    main <- paste0("Adjusted Phi = ", insight::format_value(table[[estimate]]))
  } else if (estimate == "Cohens_h") {
    main <- paste0("Cohen's h = ", insight::format_value(table[[estimate]]))
  } else if (estimate == "Odds_ratio") {
    main <- paste0("Odds ratio = ", insight::format_value(table[[estimate]]))
  } else if (estimate == "Ris_kratio") {
    main <- paste0("Risk ratio = ", insight::format_value(table[[estimate]]))
  } else if (estimate == "cohens_h") {
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

# report_model ----------------------------

.report_model_fisher <- function(x, table) {
  vars_full <- paste0(names(attributes(x$observed)$dimnames), collapse = " and ")

  text <- paste0(
    trimws(x$method),
    " testing the association between the variables of the ",
    x$data.name, " dataset "
  )

  text
}

chi2_type <- function(x) {
  if (grepl("probabilities", x$method, fixed = TRUE)) {
    out <- "probabilities"
  } else if (grepl("Pearson", x$method, fixed = TRUE)) {
    out <- "pearson"
  } else if (grepl("Fisher", x$method, fixed = TRUE)) {
    out <- "fisher"
  }
  out
}

.report_parameters_fisher <- function(table, stats, effsize, ...) {
  text_full <- paste0(
    "statistically ",
    effectsize::interpret_p(table$p, rules = "default"),
    ", and ",
    attributes(effsize)$interpretation,
    " (",
    stats,
    ")"
  )

  text_short <- paste0(
    "statistically ",
    effectsize::interpret_p(table$p, rules = "default"),
    ", and ",
    attributes(effsize)$interpretation,
    " (",
    summary(stats),
    ")"
  )

  list(text_short = text_short, text_full = text_full)
}
