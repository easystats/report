#' @keywords internal
model_text_performance_lm <- function(performance, ...) {
  text <- ""
  text_full <- ""

  # R2
  if ("R2" %in% names(performance)) {
    text <- paste0(
      "The model's explanatory power is ",
      interpret_r2(performance$R2, rules = "cohen1988"),
      " (R2 = ",
      format_value(performance$R2)
    )
    text_full <- paste0(
      "The model explains a ",
      interpret_p(performance$p),
      " and ",
      interpret_r2(performance$R2, rules = "cohen1988"),
      " proportion of variance (R2 = ",
      format_value(performance$R2),
      ", F(",
      format_value_unless_integers(performance$DoF),
      ", ",
      format_value_unless_integers(performance$DoF_residual),
      ") = ",
      format_value(performance$`F`),
      ", p ",
      format_p(performance$p)
    )

    if ("R2" %in% names(performance)) {
      text <- paste0(
        text, ", adj. R2 = ",
        format_value(performance$R2_adjusted),
        ")."
      )
      text_full <- paste0(
        text_full, ", adj. R2 = ",
        format_value(performance$R2_adjusted),
        ")."
      )
    } else {
      text <- paste0(text, ".")
      text_full <- paste0(text_full, ").")
    }
  }


  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}





#' @keywords internal
model_text_performance_logistic <- function(performance, ...) {
  text <- ""
  text_full <- ""

  # R2
  if ("R2_Tjur" %in% names(performance)) {
    text <- paste0(
      "The model's explanatory power is ",
      interpret_r2(performance$R2_Tjur, rules = "cohen1988"),
      " (Tjur's R2 = ",
      format_value(performance$R2_Tjur),
      ")."
    )
    text_full <- text
  }
  if ("R2_Nagelkerke" %in% names(performance)) {
    text <- paste0(
      "The model's explanatory power is ",
      interpret_r2(performance$R2_Nagelkerke, rules = "cohen1988"),
      " (Nagelkerke's R2 = ",
      format_value(performance$R2_Nagelkerke),
      ")."
    )
    text_full <- text
  }
  if ("R2_McFadden" %in% names(performance)) {
    text <- paste0(
      "The model's explanatory power is ",
      interpret_r2(performance$R2_McFadden, rules = "cohen1988"),
      " (McFadden's R2 = ",
      format_value(performance$R2_McFadden),
      ")."
    )

    text_full <- text
  }

  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}






#' @keywords internal
model_text_performance_bayesian <- function(performance, ci = 0.90, ...) {
  text <- ""
  text_full <- ""

  # R2
  if ("R2_Median" %in% names(performance)) {
    text <- paste0(
      "The model's explanatory power is ",
      interpret_r2(performance$R2_Median, rules = "cohen1988"),
      " (R2's median = ",
      format_value(performance$R2_Median)
    )
    text_full <- paste0(
      "The model's explanatory power is ",
      interpret_r2(performance$R2_Median, rules = "cohen1988"),
      " (R2's median = ",
      format_value(performance$R2_Median),
      ", MAD = ",
      format_value(performance$R2_MAD),
      ", ",
      format_ci(performance$R2_CI_low, performance$R2_CI_high, ci = ci)
    )

    if ("R2_LOO_adjusted" %in% names(performance)) {
      text <- paste0(
        text, ", LOO adj. R2 = ",
        format_value(performance$R2_LOO_adjusted),
        ")."
      )
      text_full <- paste0(
        text_full, ", LOO adj. R2 = ",
        format_value(performance$R2_LOO_adjusted),
        ")."
      )
    } else {
      text <- paste0(text, ").")
      text_full <- paste0(text_full, ").")
    }
  }

  if ("R2_Fixed_Median" %in% names(performance)) {
    if (text != "") {
      text <- paste0(text, " ")
      text_full <- paste0(text_full, " ")
    }

    text <- paste0(
      text,
      "Within this model, the explanatory power related to the",
      " fixed effects (fixed R2's median) is of ",
      format_value(performance$R2_Fixed_Median),
      "."
    )

    text_full <- paste0(
      text_full,
      "Within this model, the explanatory power related to the",
      " fixed effects (fixed R2's median) is of ",
      format_value(performance$R2_Fixed_Median),
      " (MAD = ",
      format_value(performance$R2_Fixed_MAD),
      ", ",
      format_ci(performance$R2_Fixed_CI_low, performance$R2_Fixed_CI_high, ci = ci),
      ")."
    )
  }

  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}







#' @keywords internal
model_text_performance_mixed <- function(performance, ...) {
  text <- ""

  # R2 Conditional
  if ("R2_conditional" %in% names(performance)) {
    text <- paste0(
      "The model's total explanatory power is ",
      interpret_r2(performance$R2_conditional, rules = "cohen1988"),
      " (conditional R2 = ",
      format_value(performance$R2_conditional),
      ")")
  }

  # R2 marginal
  if ("R2_marginal" %in% names(performance)) {
    if(text == ""){
      text <- "The"
    } else{
      text <- paste0(text, " and the")
    }
    text <- paste0(text,
      " part related to the",
      " fixed effects only (marginal R2) is of ",
      format_value(performance$R2_marginal),
      ".")
  } else{
    text <- paste0(text, ".")
  }


  text_full <- text

  # ICC
  # ?

  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}
