#' @keywords internal
model_text_performance_lm <- function(performance, ...) {

  text <- ""
  text_full <- ""

  # R2
  if ("R2" %in% names(performance)) {
    text <- paste0(
      "The model's explanatory power (R2) is of ",
      format_value(performance$R2)
    )
    text_full <- paste0(
      "The model explains a ",
      interpret_p(performance$p),
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
        text, " (adj. R2 = ",
        format_value(performance$R2_adj),
        ")."
      )
      text_full <- paste0(
        text_full, ", adj. R2 = ",
        format_value(performance$R2_adj),
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
      "The model's explanatory power (Tjur's R2) is of ",
      format_value(performance$R2_Tjur),
      "."
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
      "The model's explanatory power (R2's median) is of ",
      format_value(performance$R2_Median)
    )
    text_full <- paste0(
      "The model's explanatory power (R2's median) is of ",
      format_value(performance$R2_Median),
      " (MAD = ",
      format_value(performance$R2_MAD),
      ", ",
      format_ci(performance$R2_CI_low, performance$R2_CI_high, ci = ci)
    )

    if ("R2_LOO_adj" %in% names(performance)) {
      text <- paste0(
        text, " (LOO adj. R2 = ",
        format_value(performance$R2_LOO_adj),
        ")."
      )
      text_full <- paste0(
        text_full, ", LOO adj. R2 = ",
        format_value(performance$R2_LOO_adj),
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