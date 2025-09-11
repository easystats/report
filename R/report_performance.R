#' Report the model's quality and fit indices
#'
#' Investigating the fit of statistical models to data often involves selecting
#' the best fitting model amongst many competing models. This function helps
#' report indices of model fit for various models.  Reports the type of
#' different R objects . For a list of supported objects, see
#' [report()]).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return An object of class [report_performance()].
#'
#' @examples
#' \donttest{
#' # GLMs
#' report_performance(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' report_performance(glm(vs ~ disp, data = mtcars, family = "binomial"))
#' }
#'
#' @examplesIf requireNamespace("lme4", quietly = TRUE)
#' \donttest{
#' # Mixed models
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' report_performance(model)
#' }
#'
#' @examplesIf requireNamespace("rstanarm", quietly = TRUE)
#' \donttest{
#' # Bayesian models
#' library(rstanarm)
#' model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
#' report_performance(model)
#' }
#'
#' @examplesIf requireNamespace("lavaan", quietly = TRUE) && packageVersion("effectsize") >= "0.6.0.1"
#' \donttest{
#' # Structural Equation Models (SEM)
#' library(lavaan)
#' structure <- "ind60 =~ x1 + x2 + x3
#'               dem60 =~ y1 + y2 + y3
#'               dem60 ~ ind60 "
#' model <- lavaan::sem(structure, data = PoliticalDemocracy)
#' suppressWarnings(report_performance(model))
#' }
#' @export
report_performance <- function(x, table = NULL, ...) {
  UseMethod("report_performance")
}


# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_performance <- function(x, summary = NULL, ...) {
  class(x) <- unique(c("report_performance", class(x)))
  attributes(x) <- c(attributes(x), list(...))

  if (!is.null(summary)) {
    attr(x, "summary") <- summary
  }

  x
}


#' @export
summary.report_performance <- function(object, ...) {
  if (is.null(attributes(object)$summary)) {
    object
  } else {
    attributes(object)$summary
  }
}

#' @export
print.report_performance <- print.report_text

# Utils -------------------------------------------------------------------


#' @keywords internal
.text_r2 <- function(x, info, performance, ...) {
  r2_text <- ""
  text_full <- ""

  # R2
  if ("R2" %in% names(performance)) {
    r2 <- attributes(performance)$r2

    r2_text <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2, ...),
      " (R2 = ",
      insight::format_value(performance$R2)
    )

    # Frequentist
    if (all(c("p", "df", "df_residual") %in% names(r2))) {
      text_full <- paste0(
        "The model explains a statistically ",
        effectsize::interpret_p(r2$p),
        " and ",
        effectsize::interpret_r2(performance$R2, ...),
        " proportion of variance (R2 = ",
        insight::format_value(performance$R2),
        ", F(",
        insight::format_value(r2$df, protect_integers = TRUE),
        ", ",
        insight::format_value(r2$df_residual, protect_integers = TRUE),
        ") = ",
        insight::format_value(r2[["F"]]),
        ", ",
        insight::format_p(r2$p)
      )
    } else {
      text_full <- text
    }

    if ("CI" %in% names(r2)) {
      text_full <- paste0(
        text_full,
        ", ",
        insight::format_ci(
          r2$CI$R2_Bayes$CI_low,
          r2$CI$R2_Bayes$CI_high,
          r2$CI$R2_Bayes$CI
        )
      )
    }


    if ("R2_adjusted" %in% names(performance)) {
      r2_text <- paste0(
        r2_text, ", adj. R2 = ",
        insight::format_value(performance$R2_adjusted),
        ")"
      )
      text_full <- paste0(
        text_full, ", adj. R2 = ",
        insight::format_value(performance$R2_adjusted),
        ")"
      )
    } else {
      if (datawizard::text_lastchar(text_full) != ")") text_full <- paste0(text_full, ")")
      if (datawizard::text_lastchar(r2_text) != ")") r2_text <- paste0(r2_text, ")")
    }
  }


  # Tjur's R2
  if ("R2_Tjur" %in% names(performance)) {
    r2_text <- text_full <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2_Tjur, ...),
      " (Tjur's R2 = ",
      insight::format_value(performance$R2_Tjur),
      ")"
    )
  }

  # Nagelkerke's R2
  if ("R2_Nagelkerke" %in% names(performance)) {
    r2_text <- text_full <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2_Nagelkerke, ...),
      " (Nagelkerke's R2 = ",
      insight::format_value(performance$R2_Nagelkerke),
      ")"
    )
  }

  # CoxSnell's R2
  if ("R2_CoxSnell" %in% names(performance)) {
    r2_text <- text_full <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2_CoxSnell, ...),
      " (R2_CoxSnell's R2 = ",
      insight::format_value(performance$R2_CoxSnell),
      ")"
    )
  }

  # McFadden's R2
  if ("R2_McFadden" %in% names(performance)) {
    r2_text <- text_full <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2_McFadden, ...),
      " (McFadden's R2 = ",
      insight::format_value(performance$R2_McFadden),
      ")"
    )
  }

  # R2 Conditional
  if ("R2_conditional" %in% names(performance) && !is.na(performance$R2_conditional)) {
    r2_text <- text_full <- paste0(
      "The model's total explanatory power is ",
      effectsize::interpret_r2(performance$R2_conditional, ...),
      " (conditional R2 = ",
      insight::format_value(performance$R2_conditional),
      ")"
    )
  }

  # R2 marginal
  if ("R2_marginal" %in% names(performance)) {
    if (r2_text == "") {
      r2_text <- text_full <- "The model's explanatory power"
      of <- ""
    } else {
      r2_text <- paste0(r2_text, " and the part")
      text_full <- paste0(text_full, " and the part")
      of <- "of "
    }
    text_r2marginal <- paste0(
      " related to the fixed effects alone (marginal R2) is ",
      of,
      insight::format_value(performance$R2_marginal)
    )
    r2_text <- paste0(r2_text, text_r2marginal)

    if (is.null(attributes(performance)$r2_bayes$CI$R2_Bayes_marginal)) {
      text_full <- paste0(text_full, text_r2marginal)
    } else {
      r2 <- attributes(performance)$r2_bayes$CI$R2_Bayes_marginal
      text_full <- paste0(
        text_full,
        text_r2marginal,
        " (",
        insight::format_ci(
          r2$CI_low,
          r2$CI_high,
          r2$CI
        ),
        ")"
      )
    }
  }

  list(text_full = text_full, text = r2_text)
}


#' @keywords internal
.text_performance_lavaan <- function(perf_table, ...) {
  perf_table$Text <- paste0(
    perf_table$Name,
    " (",
    substring(insight::format_value(perf_table$Value), 2),
    ifelse(perf_table$Value > perf_table$Threshold, " > ", " < "),
    substring(insight::format_value(perf_table$Threshold), 2),
    ")"
  )

  # Satisfactory
  if (length(perf_table[perf_table$Interpretation == "satisfactory", "Text"]) >= 1) {
    text_satisfactory <- paste0(
      "The ",
      perf_table[perf_table$Interpretation == "satisfactory", "Text"],
      ifelse(length(perf_table[perf_table$Interpretation == "satisfactory", "Text"]) > 1, " suggest", " suggests"),
      " a satisfactory fit."
    )
  } else {
    text_satisfactory <- ""
  }

  # Poor
  if (length(perf_table[perf_table$Interpretation == "poor", "Text"]) >= 1) {
    text_poor <- paste0(
      "The ",
      perf_table[perf_table$Interpretation == "poor", "Text"],
      ifelse(length(perf_table[perf_table$Interpretation == "poor", "Text"]) > 1, " suggest", " suggests"),
      " a poor fit."
    )
  } else {
    text_poor <- ""
  }

  fit_text <- datawizard::text_paste(text_satisfactory, text_poor, sep = " ")
  fit_text
}
