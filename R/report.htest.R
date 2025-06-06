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
#' report(t.test(mtcars$mpg, mtcars$vs, paired = TRUE), verbose = FALSE)
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
  model_info <- dot_args$model_info
  if (is.null(model_info)) {
    model_info <- suppressWarnings(insight::model_info(x, verbose = FALSE))
  }

  model_data <- insight::get_data(x)
  if (is.null(model_data) && is.null(dot_args$data)) {
    insight::format_alert(
      paste0(
        "In the report() function, for htest objects, you can try providing ",
        "the data argument manually, e.g., report(x, data = data)."
      )
    )
  }

  # remove arg, so dots can be passed to effectsize
  dot_args[["model_info"]] <- NULL

  # For t-tests ----------------

  if (model_info$is_ttest) {
    out <- .report_effectsize_ttest(x, table, dot_args)
  }

  if (model_info$is_ranktest && !model_info$is_correlation) {
    # For friedman test ---------------

    if (grepl("Friedman", attributes(x$statistic)$names, fixed = TRUE)) {
      out <- .report_effectsize_friedman(x, table, dot_args)
    } else if (!is.null(x$statistic) && grepl(
      "Kruskal", attributes(x$statistic)$names,
      fixed = TRUE
    )) {
      # For Kruskal-Wallis test ---------------

      out <- .report_effectsize_kruskal(x, table, dot_args)
    } else {
      # For wilcox test ---------------

      out <- .report_effectsize_wilcox(x, table, dot_args)
    }
  }

  ## For correlations ---------------

  if (model_info$is_correlation) {
    out <- .report_effectsize_correlation(x, table, dot_args)
  }

  ## For Chi2 ---------------

  if (model_info$is_chi2test) {
    if (chi2_type(x) == "fisher") {
      out <- .report_effectsize_fisher(x, table, dot_args)
    } else {
      out <- .report_effectsize_chi2(x, table, dot_args)
    }
  }

  # TODO: Chi-squared test -------------

  if (model_info$is_proptest || (model_info$is_xtab && !model_info$is_chi2test) || model_info$is_onewaytest) {
    stop(insight::format_message(
      "This test is not yet supported. Please open an issue at {.url https://github.com/easystats/report/issues}."
    ), call. = FALSE)
  }

  parameters <- paste0(out$interpretation, " (", out$statistics, ")")


  as.report_effectsize(
    parameters,
    summary = parameters,
    table = out$table,
    interpretation = out$interpretation,
    statistics = out$statistics,
    rules = out$rules,
    ci = out$ci,
    main = out$main
  )
}


# report_table ------------------------------------------------------------


#' @rdname report.htest
#' @export
report_table.htest <- function(x, ...) {
  dot_args <- list(...)
  model_info <- dot_args$model_info
  if (is.null(model_info)) {
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
    # but same function for Friedman
    out <- .report_table_wilcox(table_full, effsize)
  } else if (model_info$is_chi2test) {
    # chi2 test
    out <- .report_table_chi2(table_full, effsize)
    attr(out$table_full, "table_footer") <- attr(attr(effsize, "table"), "table_footer")
  } else if (model_info$is_correlation) {
    # correlation test
    out <- .report_table_correlation(table_full)
  } else {
    out <- list(table_full = table_full, table = NULL)
  }


  as.report_table(out$table_full, summary = out$table, effsize = effsize)
}


# report_statistics ------------------------------------------------------------

#' @rdname report.htest
#' @export
report_statistics.htest <- function(x, table = NULL, ...) {
  model_info <- list(...)$model_info
  if (is.null(model_info)) {
    model_info <- suppressWarnings(insight::model_info(x, verbose = FALSE))
  }
  if (is.null(table) || is.null(attributes(table)$effsize)) {
    table <- report_table(x, model_info = model_info)
  }

  effsize <- attributes(table)$effsize
  text <- NULL

  # Estimate
  candidates <- c(
    "rho", "r", "tau", "Difference", "r_rank_biserial",
    "Chi2", "Odds Ratio"
  )
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
  }

  # p-value
  text <- paste0(text, ", ", insight::format_p(table$p, stars = FALSE, digits = "apa"))

  # Effect size
  if (model_info$is_ttest || (model_info$is_ranktest && !model_info$is_correlation) ||
    model_info$is_chi2test) {
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
  dot_args <- list(...)
  model_info <- dot_args$model_info
  if (is.null(model_info)) {
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
    # Friedman
  } else if (
    model_info$is_ranktest &&
      grepl("Friedman", attributes(x$statistic)$names, fixed = TRUE)) {
    out <- .report_parameters_friedman(table, stats, effsize, ...)
  } else if (!is.null(x$statistic) && grepl(
    "Kruskal", attributes(x$statistic)$names,
    fixed = TRUE
  )) {
    # Kruskal
    out <- .report_parameters_kruskal(table, stats, effsize, ...)
    # chi2
  } else if (model_info$is_chi2test) {
    if (chi2_type(x) == "fisher") {
      out <- .report_parameters_fisher(table, stats, effsize, ...)
    } else {
      out <- .report_parameters_chi2(table, stats, effsize, ...)
    }
  } else {
    # TODO: default, same as t-test?
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
  dot_args <- list(...)
  model_info <- dot_args$model_info
  if (is.null(model_info)) {
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
    text <- .report_model_ttest(x, table)
  }

  if (model_info$is_ranktest && !model_info$is_correlation) {
    # For friedman test ---------------

    if (grepl("Friedman", attributes(x$statistic)$names, fixed = TRUE)) {
      text <- .report_model_friedman(x, table)
    } else {
      # For wilcox test ---------------

      text <- .report_model_wilcox(x, table)
    }
  }

  if (model_info$is_chi2test) {
    if (chi2_type(x) == "fisher") {
      text <- .report_model_fisher(x, table)
    } else {
      text <- .report_model_chi2(x, table)
    }
  }

  as.report_model(text, summary = text)
}


# report_info ------------------------------------------------------------

#' @rdname report.htest
#' @export
report_info.htest <- function(x, effectsize = NULL, ...) {
  dot_args <- list(...)
  model_info <- dot_args$model_info
  if (is.null(model_info)) {
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
  dot_args <- list(...)
  model_info <- dot_args$model_info
  if (is.null(model_info)) {
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
