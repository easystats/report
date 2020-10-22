#' Report the model's performance
#'
#' Reports the type of different R objects (see list of supported objects in \code{\link{report}}).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return A \code{character} string.
#'
#' @examples
#' library(report)
#'
#' # GLMs
#' report_performance(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' report_performance(glm(vs ~ disp, data = mtcars, family = "binomial"))
#'
#' # Mixed models
#' if(require("lme4")){
#'   model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#'   report_performance(model)
#' }
#' @export
report_performance <- function(x, table = NULL, ...) {
  UseMethod("report_performance")
}


#' @export
report_performance.default <- function(x, ...) {
  stop(paste0("report_performance() is not available for objects of class ", class(x)))
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
  if(is.null(attributes(object)$summary)){
    object
  } else{
    attributes(object)$summary
  }
}

#' @export
print.report_performance <- function(x, ...) {
  cat(paste0(x, collapse = "\n"))
}



# Utils -------------------------------------------------------------------



#' @keywords internal
.text_r2 <- function(x, info, performance, ...){

  # R2 linear models ----
  if ("R2" %in% names(performance) && info$is_linear) {
    r2 <- attributes(performance)$r2

    text <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2, ...),
      " (R2 = ",
      insight::format_value(performance$R2)
    )
    text_full <- tryCatch(
      {
        paste0(
          "The model explains a ",
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
          insight::format_value(r2$`F`),
          ", ",
          insight::format_p(r2$p)
        )
      },
      error = function(e) {
        NULL
      }
    )

    if (is.null(text_full)) {
      text_full <- text
    }

    if ("R2_adjusted" %in% names(performance)) {
      text <- paste0(
        text, ", adj. R2 = ",
        insight::format_value(performance$R2_adjusted),
        ")"
      )
      text_full <- paste0(
        text_full, ", adj. R2 = ",
        insight::format_value(performance$R2_adjusted),
        ")"
      )
    } else {
      text_full <- paste0(text_full, ")")
    }
  }

  # Tjur's R2
  if ("R2_Tjur" %in% names(performance)) {
    text <- text_full <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2_Tjur, rules = "cohen1988"),
      " (Tjur's R2 = ",
      insight::format_value(performance$R2_Tjur),
      ")"
    )
  }

  # Nagelkerke's R2
  if ("R2_Nagelkerke" %in% names(performance)) {
    text <- text_full <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2_Nagelkerke, rules = "cohen1988"),
      " (Nagelkerke's R2 = ",
      insight::format_value(performance$R2_Nagelkerke),
      ")"
    )
  }

  # CoxSnell's R2
  if ("R2_CoxSnell" %in% names(performance)) {
    text <- text_full <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2_CoxSnell, rules = "cohen1988"),
      " (R2_CoxSnell's R2 = ",
      insight::format_value(performance$R2_CoxSnell),
      ")"
    )
  }

  # McFadden's R2
  if ("R2_McFadden" %in% names(performance)) {
    text <- text_full <- paste0(
      "The model's explanatory power is ",
      effectsize::interpret_r2(performance$R2_McFadden, rules = "cohen1988"),
      " (McFadden's R2 = ",
      insight::format_value(performance$R2_McFadden),
      ")"
    )
  }

  # R2 Conditional
  if ("R2_conditional" %in% names(performance) && !is.na(performance$R2_conditional)) {
    text <- paste0(
      "The model's total explanatory power is ",
      effectsize::interpret_r2(performance$R2_conditional, rules = "cohen1988"),
      " (conditional R2 = ",
      insight::format_value(performance$R2_conditional),
      ")"
    )
  }

  # R2 marginal
  if ("R2_marginal" %in% names(performance)) {
    if (text == "") {
      text <- "The model's explanatory power"
      of <- ""
    } else {
      text <- paste0(text, " and the part")
      of <- "of "
    }
    text <- text_full <- paste0(
      text,
      " related to the",
      " fixed effects alone (marginal R2) is ",
      of,
      insight::format_value(performance$R2_marginal)
    )
  }

  list(text_full=text_full, text=text)

}
