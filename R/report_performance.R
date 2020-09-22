#' @rdname report_model
#' @param performance A performance table obtained via \code{performance::model_performance()}.
#' @examples
#' model <- lm(Sepal.Length ~ Species, data = iris)
#' report_performance(model)
#'
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' report_performance(model)
#' @export
report_performance <- function(model, performance = NULL, ...) {
  UseMethod("report_performance")
}



#' @importFrom performance model_performance
#' @importFrom insight find_parameters
#' @importFrom effectsize interpret_r2 interpret_p
#' @export
report_performance.default <- function(model, performance = NULL, ...) {
  if (is.null(performance)) {
    performance <- performance::model_performance(model, ...)
  }

  text <- ""
  text_full <- ""


  # Intercept-only
  if (insight::is_nullmodel(model)) {
    return(list("text" = text, "text_full" = text_full))
  }

  modelinfo <- insight::model_info(model)

  # R2 linear models ----
  if ("R2" %in% names(performance) || modelinfo$is_linear) {
    r2 <- attributes(performance)$r2

    text <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2, rules = "cohen1988"),
      " (R2 = ",
      insight::format_value(performance$R2)
    )
    text_full <- tryCatch(
      {
        paste0(
          "\n\nThe model explains a ",
          effectsize::interpret_p(r2$p),
          " and ",
          effectsize::interpret_r2(performance$R2, rules = "cohen1988"),
          " proportion of variance (R2 = ",
          insight::format_value(performance$R2),
          ", F(",
          insight::format_value(r2$df, protect_integers = TRUE),
          ", ",
          insight::format_value(r2$df_residual, protect_integers = TRUE),
          ") = ",
          insight::format_value(r2$`F`),
          ", ",
          insight::format_p(r2$p)
        )
      },
      error = function(e) { NULL }
    )

    if (is.null(text_full)) {
      text_full <- text
    }

    if ("R2_adjusted" %in% names(performance)) {
      text <- paste0(
        text, ", adj. R2 = ",
        insight::format_value(performance$R2_adjusted),
        ")."
      )
      text_full <- paste0(
        text_full, ", adj. R2 = ",
        insight::format_value(performance$R2_adjusted),
        ")."
      )
    } else {
      text <- paste0(text, ".")
      text_full <- paste0(text_full, ").")
    }
  }

  # Tjur's R2
  if ("R2_Tjur" %in% names(performance)) {
    text <- text_full <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2_Tjur, rules = "cohen1988"),
      " (Tjur's R2 = ",
      insight::format_value(performance$R2_Tjur),
      ")."
    )
  }

  # Nagelkerke's R2
  if ("R2_Nagelkerke" %in% names(performance)) {
    text <- text_full <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2_Nagelkerke, rules = "cohen1988"),
      " (Nagelkerke's R2 = ",
      insight::format_value(performance$R2_Nagelkerke),
      ")."
    )
  }

  # CoxSnell's R2
  if ("R2_CoxSnell" %in% names(performance)) {
    text <- text_full <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2_CoxSnell, rules = "cohen1988"),
      " (R2_CoxSnell's R2 = ",
      insight::format_value(performance$R2_CoxSnell),
      ")."
    )
  }

  # McFadden's R2
  if ("R2_McFadden" %in% names(performance)) {
    text <- text_full <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2_McFadden, rules = "cohen1988"),
      " (McFadden's R2 = ",
      insight::format_value(performance$R2_McFadden),
      ")."
    )
  }

  as.model_text(text, text_full)
}




# Mixed -------------------------------------------------------------------


#' @export
report_performance.merMod <- function(model, performance = NULL, ...) {
  if (is.null(performance)) {
    performance <- performance::model_performance(model, ...)
  }

  text <- ""

  # R2 Conditional
  if ("R2_conditional" %in% names(performance) && !is.na(performance$R2_conditional)) {
    text <- paste0(
      " The model's total explanatory power is ",
      effectsize::interpret_r2(performance$R2_conditional, rules = "cohen1988"),
      " (conditional R2 = ",
      insight::format_value(performance$R2_conditional),
      ")"
    )
  }

  # R2 marginal
  if ("R2_marginal" %in% names(performance)) {
    if (text == "") {
      text <- " The model's explanatory power"
      of <- ""
    } else {
      text <- paste0(text, " and the part")
      of <- "of "
    }
    text <- paste0(
      text,
      " related to the",
      " fixed effects alone (marginal R2) is ",
      of,
      insight::format_value(performance$R2_marginal),
      "."
    )
  } else {
    text <- paste0(text, ".")
  }


  ## TODO ICC
  # ?

  as.model_text(text, text)
}




#' @export
report_performance.lme <- report_performance.merMod

#' @export
report_performance.glmmTMB <- report_performance.merMod

#' @export
report_performance.mixed <- report_performance.merMod

#' @export
report_performance.MixMod <- report_performance.merMod

#' @export
report_performance.wbm <- report_performance.merMod





# Bayesian ----------------------------------------------------------------


#' @export
report_performance.stanreg <- function(model, performance = NULL, ...) {
  if (is.null(performance)) {
    performance <- performance::model_performance(model, ...)
  }

  text <- ""
  text_full <- ""

  # Intercept-only
  if (all(insight::find_parameters(model, flatten = FALSE) == "(Intercept)")) {
    return(list("text" = text, "text_full" = text))
  }

  # R2
  if ("R2" %in% names(performance)) {
    r2 <- attributes(performance)$r2_bayes
    r2_val <- r2$Estimates$R2_Bayes$Median
    r2_ci <- r2$CI$R2_Bayes

    text <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(r2_val, rules = "cohen1988"),
      " (R2's median = ",
      insight::format_value(r2_val)
    )


    text_full <- paste0(
      text,
      ", ",
      insight::format_ci(r2_ci$CI_low, r2_ci$CI_high, r2_ci$CI / 100)
    )


    if ("R2_adjusted" %in% names(performance)) {
      text <- paste0(
        text, ", adj. R2 = ",
        insight::format_value(performance$R2_adjusted),
        ")."
      )
      text_full <- paste0(
        text_full, ", adj. R2 = ",
        insight::format_value(performance$R2_adjusted),
        ")."
      )
    }
  }

  if ("R2_marginal" %in% names(performance)) {
    r2 <- attributes(performance)$r2_bayes
    r2_val <- r2$Estimates$R2_Bayes_marginal$Median
    r2_ci <- r2$CI$R2_Bayes_marginal

    if (text != "") {
      text <- paste0(text, " ")
      text_full <- paste0(text_full, " ")
    }

    text <- paste0(
      text,
      "Within this model, the explanatory power related to the",
      " fixed effects alone (marginal R2's median) is of ",
      insight::format_value(r2_val),
      "."
    )

    text_full <- paste0(
      text_full,
      "Within this model, the explanatory power related to the",
      " fixed effects alone (marginal R2's median) is of ",
      insight::format_value(r2_val),
      " (",
      insight::format_ci(r2_ci$CI_low, r2_ci$CI_high, r2_ci$CI / 100),
      ")."
    )
  }

  as.model_text(text, text_full)
}


#' @export
report_performance.brmsfit <- report_performance.stanreg
