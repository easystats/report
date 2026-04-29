# report_table -----------------

.report_table_friedman <- function(table_full, effsize) {
  tab_attr <- attributes(effsize)$table
  if (is.null(tab_attr)) {
    tab_attr <- data.frame()
  }
  table_full <- cbind(table_full, tab_attr)
  list(table = NULL, table_full = table_full)
}


# report_effectsize ---------------------

.report_effectsize_friedman <- function(x, dot_args) {
  param_args <- c(list(x, es_type = "kendalls_w"), dot_args)

  # Build effect-size table, tolerate failures → NULL
  friedman_table <- tryCatch(
    do.call(parameters::parameters, param_args),
    error = function(e) NULL
  )

  # Extract CI level if present
  ci <- if (is.null(friedman_table)) NULL else attributes(friedman_table)$ci

  # Interpretation (guarded)
  interpret_args <- c(
    list(if (is.null(friedman_table)) NA_real_ else friedman_table$Kendalls_W),
    dot_args
  )
  interpretation <- tryCatch(
    do.call(effectsize::interpret_kendalls_w, interpret_args),
    error = function(e) NA_character_
  )
  rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))

  # Main estimate text
  main <- paste0(
    "Kendall's W = ",
    insight::format_value(
      if (is.null(friedman_table)) NA_real_ else friedman_table$Kendalls_W
    )
  )

  # Detect CI columns (your table uses W_CI_low/high; be flexible)
  has_cols <- function(x, cols) all(cols %in% names(x))
  has_ci <- !is.null(friedman_table) &&
    !is.null(ci) &&
    (has_cols(friedman_table, c("W_CI_low", "W_CI_high")) ||
      has_cols(friedman_table, c("CI_low", "CI_high")))

  if (has_ci) {
    if (has_cols(friedman_table, c("W_CI_low", "W_CI_high"))) {
      lo <- friedman_table$W_CI_low
      hi <- friedman_table$W_CI_high
    } else {
      lo <- friedman_table$CI_low
      hi <- friedman_table$CI_high
    }

    statistics <- paste0(
      main,
      ", ",
      insight::format_ci(CI_low = lo, CI_high = hi, ci = ci)
    )
  } else {
    statistics <- main
  }

  # Keep only stable columns if table exists
  if (!is.null(friedman_table)) {
    keep <- intersect(
      c("Kendalls_W", "W_CI_low", "W_CI_high", "CI_low", "CI_high"),
      names(friedman_table)
    )
    friedman_table <- friedman_table[keep]
  }

  list(
    table = friedman_table,
    statistics = statistics,
    interpretation = interpretation,
    rules = rules,
    ci = ci,
    main = main
  )
}

# report_model ----------------------------

.report_model_friedman <- function(x, table) {
  # two-sample
  if ("Parameter1" %in% names(table)) {
    vars_full <- paste0(table$Parameter1[[1]], ", and ", table$Parameter2[[1]])

    friedman_text <- paste0(
      trimws(x$method),
      " testing the difference in ranks between ",
      vars_full
    )
  } else {
    # one-sample
    vars_full <- paste0(table$Parameter[[1]])

    friedman_text <- paste0(
      trimws(x$method),
      " testing the difference in rank for ",
      vars_full,
      " and true location of 0"
    )
  }

  friedman_text
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
