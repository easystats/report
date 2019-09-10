#' h-test (Correlation, t-test...) Report
#'
#' Create a report of an h-test object.
#'
#' @param model Object of class htest.
#' @param effsize Effect size interpretation set of rules.
#' @param ... Arguments passed to or from other methods.
#'
#'
#'
#' @examples
#' report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "spearman"))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length, var.equal = TRUE))
#' report(t.test(mtcars$mpg ~ mtcars$vs))
#' report(t.test(iris$Sepal.Width, mu = 1))
#' @seealso report
#'
#' @export
report.htest <- function(model, effsize = "cohen1988", ...) {
  table_full <- parameters::model_parameters(model)
  table <- table_full
  values <- as.list(table_full)


  if (insight::model_info(model)$is_correlation) {
    estimate <- c("rho", "r", "tau")[c("rho", "r", "tau") %in% names(table)]
    text <- paste0(
      "The ",
      model$method,
      " between ",
      model$data.name,
      " is ",
      interpret_direction(table[[estimate]]),
      ", ",
      interpret_p(table$p),
      " and ",
      interpret_r(table[[estimate]], rules = effsize),
      " (",
      estimate,
      " = ",
      insight::format_value(table[[estimate]]),
      ", ",
      parameters::format_p(values$p, stars = FALSE),
      ")."
    )
    text_full <- text
  } else if (insight::model_info(model)$is_ttest) {
    if (names(model$null.value) == "mean") {
      table_full$Difference <- model$estimate - model$null.value
      means <- paste0(
        " (mean = ",
        insight::format_value(model$estimate),
        ")"
      )
      vars <- paste0(model$data.name, means, " and mu = ", model$null.value)
    } else {
      table_full$Difference <- model$estimate[1] - model$estimate[2]
      means <- paste0(
        c(
          paste0(
            names(model$estimate), " = ",
            insight::format_value(model$estimate)
          ),
          paste0(
            "difference = ",
            insight::format_value(model$estimate[1] - model$estimate[2])
          )
        ),
        collapse = ", "
      )
      vars <- paste0(model$data.name, " (", means, ")")
    }

    text <- paste0(
      "The ",
      trimws(model$method),
      " suggests that the difference ",
      ifelse(grepl(" by ", model$data.name), "of ", "between "),
      vars,
      " is ",
      interpret_p(model$p.value),
      " (t(",
      insight::format_value(model$parameter, protect_integers = TRUE),
      ") = ",
      insight::format_value(model$statistic),
      ", ",
      parameters::format_ci(model$conf.int[1], model$conf.int[2], ci = attributes(model$conf.int)$conf.level),
      ", ",
      parameters::format_p(model$p.value, stars = FALSE),
      ")."
    )
    text_full <- text
  } else {
    stop("reports not implemented for such h-tests yet.")
  }


  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full,
    values = as.list(table_full)
  )

  return(as.report(out, effsize = effsize, ...))
}
