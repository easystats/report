# report_table -----------------

.report_table_kruskal <- function(table_full, effsize) {
  table_full <- cbind(table_full, attributes(effsize)$table)
  list(table = NULL, table_full = table_full)
}


# report_effectsize ---------------------

.report_effectsize_kruskal <- function(x, table, dot_args, rules = "funder2019") {
  args <- c(list(x), dot_args)

  # Try to calculate effect size with confidence intervals
  table <- tryCatch(
    {
      do.call(effectsize::effectsize, args)
    },
    error = function(e) {
      # If CI calculation fails (e.g., degenerate cases), fallback to no CI
      if (grepl("confidence intervals", e$message, ignore.case = TRUE) ||
        grepl("differing number of rows", e$message)) {
        args_no_ci <- c(list(x), dot_args, list(ci = NULL))
        do.call(effectsize::effectsize, args_no_ci)
      } else if (grepl("Unable to retrieve data", e$message)) {
        # Data retrieval failed - this happens with certain htest object forms
        # For now, we'll let this error propagate as the user should use the formula interface
        # or provide data manually as suggested in the main report.htest function
        stop(e)
      } else {
        stop(e)
      }
    }
  )

  ci <- attributes(table)$ci
  estimate <- names(table)[1]

  rules <- ifelse(is.null(dot_args$rules), rules, dot_args$rules)

  # same as Pearson's r
  args <- c(list(table$rank_epsilon_squared), dot_args)
  interpretation <- do.call(effectsize::interpret_epsilon_squared, args)
  rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))

  main <- paste0("Epsilon squared (rank) = ", insight::format_value(table$rank_epsilon_squared))

  # Handle cases where CI calculation failed and CI columns are missing
  if (all(c("CI_low", "CI_high") %in% names(table))) {
    statistics <- paste0(
      main,
      ", ",
      insight::format_ci(table$CI_low, table$CI_high, ci)
    )
  } else {
    # No CI available - report only the effect size
    statistics <- main
  }

  # Remove CI_lower column if present (original code logic)
  if (ncol(table) > 1) {
    table <- table[names(table)[-2]]
  }

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
