#' Report of h-tests (Correlation, t-test...)
#'
#' Create a report of an h-test object (\code{t.test()}, \code{cor.test()}).
#'
#' @param x Object of class htest.
#' @inheritParams report
#' @inherit report return seealso
#'
#' @examples
#' report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "spearman"))
#' report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "pearson"))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length, var.equal = TRUE))
#' report(t.test(mtcars$mpg ~ mtcars$vs))
#' report(t.test(iris$Sepal.Width, mu = 1))
#' @importFrom insight format_ci
#' @export
report.htest <- function(x, ...) {
  print("SOON")
}





# report_effectsize -------------------------------------------------------



#' @importFrom effectsize effectsize interpret_r interpret_d
#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_effectsize.htest <- function(x, ...) {

  table <- effectsize::effectsize(x, ...)
  estimate <- names(table)[1]

  # For t-tests, or correlations
  if (insight::model_info(x)$is_ttest) {

    interpret <- effectsize::interpret_d(table[[estimate]], ...)
    interpretation <- interpret
    main <- paste0("Cohen's d = ", insight::format_value(table[[estimate]]))
    statistics <- paste0(main,
                         ", ",
                         insight::format_ci(table$CI_low, table$CI_high, table$CI))
    table <- data_rename(as.data.frame(table), c("CI_low", "CI_high"), c("d_CI_low", "d_CI_high"))
    table <- data_reorder(table, c("d", "d_CI_low", "d_CI_high"))
  } else{
    interpret <- effectsize::interpret_r(table[[estimate]], ...)
    interpretation <- interpret
    main <- paste0(estimate, " = ", insight::format_value(table[[estimate]]))
    statistics <- paste0(main,
                         ", ",
                         insight::format_ci(table$CI_low, table$CI_high, attributes(table)$ci))
    table <- data_reorder(table, c("r", "CI_low", "CI_high"))
  }
  rules <- .text_effectsize(attributes(interpret)$rule_name)
  parameters <- paste0(interpretation, " (", statistics, ")")


  # Return output
  as.report_effectsize(parameters,
                       summary=parameters,
                       table=table[1:3],
                       interpretation=interpretation,
                       statistics=statistics,
                       rules=rules,
                       ci=unique(table$CI),
                       main=main)
}



# report_table ------------------------------------------------------------



#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_table.htest <- function(x, ...) {
  effsize <- report_effectsize(x, ...)


  table_full <- parameters::model_parameters(x, ...)

  # If t-test, effect size
  if (insight::model_info(x)$is_ttest) {
    table_full <- cbind(table_full, effsize)
  }

  table <- data_remove(table_full, c("Parameter", "Group", "Mean_Group1", "Mean_Group2", "Method"))
  # Return output
  as.report_table(table_full, summary=table)
}


# report_statistics ------------------------------------------------------------



#' @export
report_statistics.htest <- function(x, table=NULL, ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }

  # Estimate
  candidates <- c("rho", "r", "tau", "Difference")
  estimate <- candidates[candidates %in% names(table)][1]
  text <- paste0(tolower(estimate), " = ", insight::format_value(table[[estimate]]))

  # CI
  if (!is.null(attributes(x$conf.int)$conf.level)) {
    text <- paste0(text, ", ", insight::format_ci(table$CI_low, table$CI_high, ci = attributes(x$conf.int)$conf.level))
  }

  # Statistic
  if ("t" %in% names(table)) {
    text <- paste0(text, ", t(", insight::format_value(table$df, protect_integers = TRUE), ") = ", insight::format_value(table$t))
  } else if ("S" %in% names(table)) {
    text <- paste0(text, ", S = ", insight::format_value(table$S))
  }

  # p-value
  text <- paste0(text, ", ", insight::format_p(table$p, stars = FALSE, digits = "apa"))

  as.report_statistics(text, summary=text, estimate=table[[estimate]])
}




# report_statistics ------------------------------------------------------------



#' @export
report_parameters.htest <- function(x, table=NULL, ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }

  stats <- report_statistics(x, table=table, ...)

  # Correlations
  if (insight::model_info(x)$is_correlation) {
    text_full <- paste0(
      effectsize::interpret_direction(attributes(stats)$estimate),
      ", ",
      effectsize::interpret_p(table$p, rules="default"),
      " and ",
      effectsize::interpret_r(attributes(stats)$estimate, ...),
      " (",
      stats,
      ")"
    )
    text_short <- text_full

  # t-tests
  } else{
    effsize <- report_effectsize(x, ...)
    text_full <- paste0(
      effectsize::interpret_direction(attributes(stats)$estimate),
      ", ",
      effectsize::interpret_p(table$p, rules="default"),
      " (",
      stats,
      ") and can be considered as ",
      effsize
    )
    text_short <- paste0(
      effectsize::interpret_direction(attributes(stats)$estimate),
      ", ",
      effectsize::interpret_p(table$p, rules="default"),
      " and ",
      attributes(effsize)$interpretation,
      " (",
      stats,
      ", ",
      attributes(effsize)$main,
      ")"
    )
  }


  as.report_parameters(text_full, summary=text_short, effectsize=effsize, ...)
}

# report_model ------------------------------------------------------------

#' @export
report_model.htest <- function(x, table=NULL, ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }

  if (insight::model_info(x)$is_correlation) {
    text <- paste0(
      x$method,
      " between ",
      x$data.name
    )
  } else{

    # If against mu
    if (names(x$null.value) == "mean") {
      table$Difference <- x$estimate - x$null.value
      means <- paste0(
        " (mean = ",
        insight::format_value(x$estimate),
        ")"
      )
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

  as.report_model(text, summary=text)
}



# report_text ------------------------------------------------------------

#' @export
report_text.htest <- function(x, table=NULL, ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }

  model <- report_model(x, table=table, ...)
  params <- report_parameters(x, table=table, ...)

  # as.report_text(..., summary=...)
}
