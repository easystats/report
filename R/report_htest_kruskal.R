# report_table -----------------

.report_table_kruskal <- function(table_full, effsize) {
  tab_attr <- attributes(effsize)$table
  if (is.null(tab_attr)) {
    tab_attr <- data.frame()
  }
  table_full <- cbind(table_full, tab_attr)
  list(table = NULL, table_full = table_full)
}

# report_effectsize ---------------------

.report_effectsize_kruskal <- function(x, dot_args, rules = "funder2019") {
  effect_args <- c(list(x), dot_args)

  # Build the effect-size table, but tolerate failures → NULL
  kruskal_table <- tryCatch(
    do.call(effectsize::effectsize, effect_args),
    error = function(e) NULL
  )

  # Default: no CI unless we can prove we have it
  ci <- if (is.null(kruskal_table)) NULL else attributes(kruskal_table)$ci
  estimate_name <- if (is.null(kruskal_table)) {
    names(kruskal_table)[1]
  } else {
    "rank_epsilon_squared"
  }

  # Interpret (guarded)
  rules <- ifelse(is.null(dot_args$rules), rules, dot_args$rules)
  interpretation <- tryCatch(
    do.call(
      effectsize::interpret_epsilon_squared,
      c(
        list(
          if (is.null(kruskal_table)) {
            NA_real_
          } else {
            kruskal_table$rank_epsilon_squared
          }
        ),
        dot_args
      )
    ),
    error = function(e) NA_character_
  )
  rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))

  # Main estimate line (works with or without CI)
  main <- paste0(
    "Epsilon squared (rank) = ",
    insight::format_value(
      if (is.null(kruskal_table)) {
        NA_real_
      } else {
        kruskal_table$rank_epsilon_squared
      }
    )
  )

  # Only format CI when the columns exist AND ci is non-NULL
  has_ci <- !is.null(kruskal_table) &&
    all(c("CI_low", "CI_high") %in% names(kruskal_table)) &&
    !is.null(ci)

  statistics <- if (has_ci) {
    paste0(
      main,
      ", ",
      insight::format_ci(
        CI_low = kruskal_table$CI_low,
        CI_high = kruskal_table$CI_high,
        ci = ci
      )
    )
  } else {
    main
  }

  # Drop the second column if you need parity with old structure
  if (!is.null(kruskal_table)) {
    kruskal_table <- kruskal_table[names(kruskal_table)[-2]]
  }

  list(
    table = kruskal_table,
    statistics = statistics,
    interpretation = interpretation,
    rules = rules,
    ci = ci,
    main = main
  )
}

# report_model ----------------------------

.report_model_kruskal <- function(x, table) {
  # two-sample
  if ("Parameter1" %in% names(table)) {
    vars_full <- paste0(table$Parameter1[[1]], ", and ", table$Parameter2[[1]])

    kruskal_text <- paste0(
      trimws(x$method),
      " testing the difference in ranks between ",
      vars_full
    )
  } else {
    # one-sample
    vars_full <- paste0(table$Parameter[[1]])

    kruskal_text <- paste0(
      trimws(x$method),
      " testing the difference in rank for ",
      vars_full,
      " and true location of 0"
    )
  }

  kruskal_text
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
