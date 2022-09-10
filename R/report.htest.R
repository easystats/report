#' Reporting `htest` objects (Correlation, t-test...)
#'
#' Create reports for `htest` objects (`t.test()`, `cor.test()`,
#' etc.).
#'
#' @param x Object of class `htest`.
#' @param table Provide the output of  `report_table()` to avoid its
#'   re-computation.
#' @param effectsize Provide the output of `report_effectsize()` to avoid
#'   its re-computation.
#' @inheritParams report
#'
#' @inherit report return seealso
#'
#' @examples
#' # t-tests
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length, var.equal = TRUE))
#' report(t.test(mtcars$mpg ~ mtcars$vs))
#' report(t.test(mtcars$mpg, mtcars$vs, paired = TRUE))
#' report(t.test(iris$Sepal.Width, mu = 1))
#'
#' # Correlations
#' report(cor.test(iris$Sepal.Width, iris$Sepal.Length))
#' @return An object of class [report()].
#' @export
report.htest <- function(x, ...) {
  model_info <- insight::model_info(x, verbose = FALSE)
  table <- report_table(x, model_info = model_info, ...)
  text <- report_text(x, table = table, model_info = model_info, ...)

  as.report(text, table = table, ...)
}


# report_effectsize -------------------------------------------------------

#' @rdname report.htest
#' @export
report_effectsize.htest <- function(x, ...) {
  dot_args <- list(...)
  if (is.null(model_info <- dot_args$model_info)) {
    model_info <- suppressWarnings(insight::model_info(x, verbose = FALSE))
  }

  # remove arg, so dots can be passed to effectsize
  dot_args[["model_info"]] <- NULL

  # For t-tests ----------------

  if (model_info$is_ttest) {
    args <- c(list(x), dot_args)
    table <- do.call(effectsize::cohens_d, args)
    ci <- attributes(table)$ci
    estimate <- names(table)[1]

    args <- c(list(table[[estimate]]), dot_args)
    interpretation <- do.call(effectsize::interpret_cohens_d, args)
    rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))

    if (estimate %in% c("d", "Cohens_d")) {
      main <- paste0("Cohen's d = ", insight::format_value(table[[estimate]]))
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
  }

  # For wilcox test ---------------

  if (model_info$is_ranktest && !model_info$is_correlation) {
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
  }

  # For correlations ---------------

  if (model_info$is_correlation) {
    args <- c(list(x), dot_args)
    table <- do.call(parameters::parameters, args)
    ci <- attributes(table)$ci
    estimate <- names(table)[3]

    # Pearson
    args <- c(list(table[[estimate]]), dot_args)
    interpretation <- do.call(effectsize::interpret_r, args)
    rules <- .text_effectsize(attr(attr(interpretation, "rules"), "rule_name"))
    main <- paste0(estimate, " = ", insight::format_value(table[[estimate]]))

    if ("CI_low" %in% names(table)) {
      statistics <- paste0(
        main,
        ", ",
        insight::format_ci(table$CI_low, table$CI_high, ci)
      )

      table <- table[c(estimate, "CI_low", "CI_high")]

      # For Spearman and co.
    } else {
      statistics <- main
      table <- table[estimate]
    }
  }

  # TODO: Chi-squared test -------------

  if (model_info$is_chi2test || model_info$is_proptest || model_info$is_xtab) {
    stop(insight::format_message(
      "This test is not yet supported. Please open an issue at {.url https://github.com/easystats/report/issues}."
    ), call. = FALSE)
  }

  parameters <- paste0(interpretation, " (", statistics, ")")

  # Return output
  as.report_effectsize(
    parameters,
    summary = parameters,
    table = table,
    interpretation = interpretation,
    statistics = statistics,
    rules = rules,
    ci = ci,
    main = main
  )
}


# report_table ------------------------------------------------------------


#' @rdname report.htest
#' @export
report_table.htest <- function(x, ...) {
  dot_args <- list(...)
  if (is.null(model_info <- dot_args$model_info)) {
    model_info <- suppressWarnings(insight::model_info(x, verbose = FALSE))
  }

  # remove arg, so dots can be passed to effectsize
  dot_args[["model_info"]] <- NULL

  args <- c(list(x), dot_args)
  table_full <- do.call(parameters::model_parameters, args)
  args <- c(list(x, model_info = model_info), dot_args)
  effsize <- do.call(report_effectsize, args)

  if (model_info$is_ttest) {
    # If t-test, effect size
    out <- .report_table_ttest(table_full, effsize)
  } else if (model_info$is_ranktest && !model_info$is_correlation) {
    # wilcox test
    out <- .report_table_wilcox(table_full, effsize)
  } else {
    out <- list(table_full = table_full, table = NULL)
  }

  # Return output
  as.report_table(out$table_full, summary = out$table, effsize = effsize)
}


# report_statistics ------------------------------------------------------------

#' @rdname report.htest
#' @export
report_statistics.htest <- function(x, table = NULL, ...) {
  if (is.null(model_info <- list(...)$model_info)) {
    model_info <- suppressWarnings(insight::model_info(x, verbose = FALSE))
  }
  if (is.null(table) || is.null(attributes(table)$effsize)) {
    table <- report_table(x, model_info)
  }

  effsize <- attributes(table)$effsize
  text <- NULL

  # Estimate
  candidates <- c("rho", "r", "tau", "Difference", "r_rank_biserial")
  estimate <- candidates[candidates %in% names(table)][1]
  if (!is.null(estimate) && !is.na(estimate)) {
    text <- paste0(tolower(estimate), " = ", insight::format_value(table[[estimate]]))
  }

  # CI
  if (!is.null(attributes(x$conf.int)$conf.level)) {
    text <- paste0(
      text,
      ", ",
      insight::format_ci(
        table$CI_low,
        table$CI_high,
        ci = attributes(x$conf.int)$conf.level
      )
    )
  }

  # Statistic
  if ("t" %in% names(table)) {
    text <- paste0(
      text,
      ", t(",
      insight::format_value(table$df, protect_integers = TRUE),
      ") = ",
      insight::format_value(table$t)
    )
  } else if ("S" %in% names(table)) {
    text <- paste0(text, ", S = ", insight::format_value(table$S))
  } else if ("z" %in% names(table)) {
    text <- paste0(text, ", z = ", insight::format_value(table$z))
  } else if ("W" %in% names(table)) {
    text <- paste0("W = ", insight::format_value(table$W))
  } else if ("Chi2" %in% names(table)) {
    text <- paste0(text, ", Chi2 = ", insight::format_value(table$Chi2))
  }

  # p-value
  text <- paste0(text, ", ", insight::format_p(table$p, stars = FALSE, digits = "apa"))

  # Effect size
  if (model_info$is_ttest ||
    (model_info$is_ranktest && !model_info$is_correlation)) {
    text_full <- paste0(text, "; ", attributes(effsize)$statistics)
    text <- paste0(text, ", ", attributes(effsize)$main)
  } else {
    text_full <- text
  }

  as.report_statistics(text_full,
    summary = text,
    estimate = table[[estimate]],
    table = table,
    effsize = effsize
  )
}


# report_parameters ------------------------------------------------------------


#' @rdname report.htest
#' @export
report_parameters.htest <- function(x, table = NULL, ...) {
  if (is.null(model_info <- list(...)$model_info)) {
    model_info <- suppressWarnings(insight::model_info(x, verbose = FALSE))
  }

  # remove arg, so dots can be passed to other methods
  dot_args[["model_info"]] <- NULL

  args <- c(list(x, table = table, model_info = model_info), dot_args)
  stats <- do.call(report_statistics, args)
  table <- attributes(stats)$table
  effsize <- attributes(stats)$effsize


  ## TODO see https://github.com/easystats/report/issues/256
  # insight::model_info() returns "$is_correlation" for shapiro-test,
  # but shapiro-test has no "estimate", so this fails. We probably need
  # to handle shapiro separately

  # Correlations
  if (model_info$is_correlation) {
    out <- .report_parameters_correlation(table, stats, ...)

    # t-tests
  } else if (model_info$is_ttest) {
    out <- .report_parameters_ttest(table, stats, effsize, ...)

    # TODO: default, same as t-test?
  } else {
    out <- .report_parameters_htest_default(table, stats, effsize, ...)
  }

  as.report_parameters(
    out$text_full,
    summary = out$text_short,
    table = table,
    effectsize = effsize,
    ...
  )
}

# report_model ------------------------------------------------------------

#' @rdname report.htest
#' @export
report_model.htest <- function(x, table = NULL, ...) {
  if (is.null(model_info <- list(...)$model_info)) {
    model_info <- suppressWarnings(insight::model_info(x, verbose = FALSE))
  }
  # remove arg, so dots can be passed to other methods
  dot_args[["model_info"]] <- NULL

  if (is.null(table)) {
    args <- c(list(x, model_info = model_info), dot_args)
    table <- do.call(report_table, args)
  }

  if (model_info$is_correlation) {
    text <- paste0(x$method, " between ", x$data.name)
  }

  if (model_info$is_ttest) {
    # If against mu
    if (names(x$null.value) == "mean") {
      table$Difference <- x$estimate - x$null.value
      means <- paste0(" (mean = ", insight::format_value(x$estimate), ")")
      vars_full <- paste0(x$data.name, means, " and mu = ", x$null.value)
      vars <- paste0(x$data.name, " and mu = ", x$null.value)

      # If between two groups
    } else {
      table$Difference <- x$estimate[1] - x$estimate[2]
      means <- paste0(names(x$estimate), " = ",
        insight::format_value(x$estimate),
        collapse = ", "
      )
      vars_full <- paste0(x$data.name, " (", means, ")")
      vars <- paste0(x$data.name)
    }

    text <- paste0(
      trimws(x$method),
      " testing the difference ",
      ifelse(grepl(" by ", x$data.name), "of ", "between "),
      vars_full
    )
  }

  if (model_info$is_ranktest && !model_info$is_correlation) {
    # two-sample
    if ("Parameter1" %in% names(table)) {
      vars_full <- paste0(table$Parameter1[[1]], " and ", table$Parameter2[[1]])

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
  }

  as.report_model(text, summary = text)
}


# report_info ------------------------------------------------------------

#' @rdname report.htest
#' @export
report_info.htest <- function(x, effectsize = NULL, ...) {
  if (is.null(model_info <- list(...)$model_info)) {
    model_info <- suppressWarnings(insight::model_info(x, verbose = FALSE))
  }
  # remove arg, so dots can be passed to other methods
  dot_args[["model_info"]] <- NULL

  if (is.null(effectsize)) {
    args <- c(list(x, model_info = model_info), dot_args)
    effectsize <- do.call(report_effectsize, args)
  }

  as.report_info(attributes(effectsize)$rules)
}


# report_text ------------------------------------------------------------

#' @rdname report.htest
#' @export
report_text.htest <- function(x, table = NULL, ...) {
  if (is.null(model_info <- list(...)$model_info)) {
    model_info <- suppressWarnings(insight::model_info(x, verbose = FALSE))
  }
  # remove arg, so dots can be passed to other methods
  dot_args[["model_info"]] <- NULL

  args <- c(list(x, table = table, model_info = model_info), dot_args)
  params <- do.call(report_parameters, args)

  table <- attributes(params)$table
  args <- c(list(x, table = table, model_info = model_info), dot_args)
  model <- do.call(report_model, args)

  args <- c(list(x, effectsize = attributes(params)$effectsize, model_info = model_info), dot_args)
  info <- do.call(report_info, args)

  if (model_info$is_correlation) {
    text <- paste0(
      "The ",
      model,
      " is ",
      params
    )

    text_full <- paste0(
      info,
      "\n\n",
      text
    )
  } else {
    text_full <- paste0(
      info,
      "\n\nThe ",
      model,
      " suggests that the effect is ",
      params
    )

    text <- paste0(
      "The ",
      model,
      " suggests that the effect is ",
      summary(params)
    )
  }

  as.report_text(text_full, summary = text)
}
