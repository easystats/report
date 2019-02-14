#' h-test (Correlation, t-test...) Report
#'
#' Create a report of an h-test object.
#'
#' @param model Object of class htest.
#' @param effsize Effect size interpretation set of rules.
#' @param ... Arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @examples
#' report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "spearman"))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length, var.equal = TRUE))
#' report(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report(t.test(mtcars$mpg ~ mtcars$vs))
#' report(t.test(iris$Sepal.Width, mu = 1))
#' @seealso report
#' @import dplyr
#'
#' @export
report.htest <- function(model, effsize = "cohen1988", ...) {


  # Processing --------------------------------------------------------------
  table_full <- broom::tidy(model) %>%
    rename_if_possible("p.value", "p") %>%
    rename_if_possible("conf.low", "CI_low") %>%
    rename_if_possible("conf.high", "CI_high") %>%
    rename_if_possible("parameter", "DoF") %>%
    rename_if_possible("method", "Method") %>%
    rename_if_possible("estimate1", "Mean_1") %>%
    rename_if_possible("estimate2", "Mean_2") %>%
    rename_if_possible("alternative", "Alternative")


  # Correlation -------------------------------------------------------------
  if (grepl("correlation", table_full$Method[1])) {
    if (grepl("Pearson", table_full$Method[1])) {
      table_full <- table_full %>%
        rename_if_possible("statistic", "t") %>%
        rename_if_possible("estimate", "r")
      interpretation <- paste0(
        interpret_direction(table_full$r[1]),
        ", ", interpret_r(table_full$r[1], effsize, direction = FALSE), " and "
      )
      effect <- paste0(
        "r(", table_full$DoF[1], ") = ",
        format_value(table_full$r[1]), ", ",
        format_CI(table_full$CI_low[1], table_full$CI_high[1], ci = attributes(model$conf.int)$conf.level)
      )
      method <- "Pearson's correlation"
      table <- select(table_full, -one_of("t", "Method", "Alternative"))
    } else if (grepl("Spearman", table_full$Method[1])) {
      table_full <- table_full %>%
        rename_if_possible("statistic", "S") %>%
        rename_if_possible("estimate", "rho")
      interpretation <- paste0(interpret_direction(table_full$rho[1]), " and ")
      effect <- paste0("rho = ", format_value(table_full$rho[1]))
      method <- "Spearman's correlation"
      table <- select(table_full, -one_of("S", "Method", "Alternative"))
    } else {
      table_full <- table_full %>%
        rename_if_possible("statistic", "z") %>%
        rename_if_possible("estimate", "tau")
      interpretation <- interpret_direction(table_full$tau[1])
      effect <- paste0(paste0("tau = ", format_value(table_full$tau[1])), " and ")
      method <- "Kendall's correlation"
      table <- select(table_full, -one_of("z", "Method", "Alternative"))
    }

    # Text
    values <- as.list(table_full)
    text <- paste0(
      "The ",
      method,
      " between ",
      model$data.name,
      " is ",
      interpretation,
      interpret_p(values$p),
      " (", effect,
      ", p ",
      format_p(values$p, stars = FALSE),
      ")."
    )
    text_full <- text


    # T-tests -------------------------------------------------------------
  } else if (grepl("t-test", table_full$Method[1])) {
    table_full <- table_full %>%
      rename_if_possible("statistic", "t")
    if ("estimate" %in% names(table_full)) {
      table_full <- select(table_full, -one_of("estimate"))
    }

    if (names(model$null.value) == "mean") {
      table_full$Difference <- model$estimate - model$null.value
      means <- paste0(
        " (mean = ",
        format_value(model$estimate),
        ")"
      )
      vars <- paste0(model$data.name, means, " and mu = ", model$null.value)
    } else {
      table_full$Difference <- model$estimate[1] - model$estimate[2]
      means <- paste0(
        c(
          paste0(
            names(model$estimate), " = ",
            format_value(model$estimate)
          ),
          paste0(
            "difference = ",
            format_value(model$estimate[1] - model$estimate[2])
          )
        ),
        collapse = ", "
      )
      vars <- paste0(model$data.name, " (", means, ")")
    }
    table <- select(table_full, -one_of("Method", "Alternative"), -starts_with("Mean"))

    # Text
    values <- as.list(table_full)
    text <- paste0(
      "The ",
      stringr::str_trim(model$method),
      " suggests that the difference ",
      ifelse(grepl(" by ", model$data.name), "of ", "between "),
      vars,
      " is ",
      interpret_p(model$p.value),
      " (t(",
      format_value_unless_integers(model$parameter),
      ") = ",
      format_value(model$statistic),
      ", ",
      format_CI(model$conf.int[1], model$conf.int[2], ci = attributes(model$conf.int)$conf.level),
      ", p ",
      format_p(model$p.value, stars = FALSE),
      ")."
    )
    text_full <- text
    # Other -------------------------------------------------------------
  } else {
    stop(paste0("`report()` for the ", table_full$Method[1], " is not implemented yet."))
  }

  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full,
    values = as.list(table_full)
  )

  return(as.report(out))
}
