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
  table <- report_table(x, ...)
  text <- report_text(x, table=table, ...)

  as.report(text, table = table, ...)
}





# report_effectsize -------------------------------------------------------



#' @importFrom effectsize effectsize interpret_r interpret_d
#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_effectsize.htest <- function(x, ...) {

  table <- effectsize::effectsize(x, ...)
  estimate <- names(table)[1]
  ci <- table$CI

  # For t-tests, or correlations
  if (insight::model_info(x)$is_ttest) {

    interpret <- effectsize::interpret_d(table[[estimate]], ...)
    interpretation <- interpret
    main <- paste0("Cohen's d = ", insight::format_value(table[[estimate]]))
    statistics <- paste0(main,
                         ", ",
                         insight::format_ci(table$CI_low, table$CI_high, ci))
    table <- data_rename(as.data.frame(table), c("CI_low", "CI_high"), c("d_CI_low", "d_CI_high"))
    table <- table[c("d", "d_CI_low", "d_CI_high")]
  } else{
    interpret <- effectsize::interpret_r(table[[estimate]], ...)
    interpretation <- interpret
    main <- paste0(estimate, " = ", insight::format_value(table[[estimate]]))

    if("CI_low" %in% names(table)){
      statistics <- paste0(main,
                           ", ",
                           insight::format_ci(table$CI_low, table$CI_high, ci))
      table <- table[c(estimate, "CI_low", "CI_high")]

      # For spearman & co.
    } else{
      statistics <- main
      table <- table[c(estimate)]
    }

  }
  rules <- .text_effectsize(attributes(interpret)$rule_name)
  parameters <- paste0(interpretation, " (", statistics, ")")


  # Return output
  as.report_effectsize(parameters,
                       summary=parameters,
                       table=table,
                       interpretation=interpretation,
                       statistics=statistics,
                       rules=rules,
                       ci=ci,
                       main=main)
}



# report_table ------------------------------------------------------------



#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_table.htest <- function(x, ...) {

  table_full <- parameters::model_parameters(x, ...)

  # If t-test, effect size
  if (insight::model_info(x)$is_ttest) {
    effsize <- report_effectsize(x, ...)
    table_full <- cbind(table_full, attributes(effsize)$table)
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
  effsize <- report_effectsize(x, ...)

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


# report_info ------------------------------------------------------------

#' @export
report_info.htest <- function(x, effectsize=NULL, ...) {
  if (is.null(effectsize)) {
    effectsize <- report_effectsize(x, ...)
  }
  as.report_info(attributes(effectsize)$rules)
}



# report_text ------------------------------------------------------------

#' @export
report_text.htest <- function(x, table=NULL, ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }

  model <- report_model(x, table=table, ...)
  params <- report_parameters(x, table=table, ...)
  info <- report_info(x, effectsize=attributes(params)$effectsize, ...)


  if (insight::model_info(x)$is_correlation) {
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

  as.report_text(text_full, summary=text)
}
