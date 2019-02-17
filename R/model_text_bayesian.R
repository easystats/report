#' @keywords internal
model_text_performance_bayesian <- function(performance, ci = 0.90, ...) {

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
  } else {
    text <- ""
    text_full <- ""
  }

  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}






#' @keywords internal
model_text_initial_bayesian <- function(parameters, ci = 0.90, ...) {
  intercept <- parameters[parameters$Parameter == "(Intercept)", ]

  if ("Median" %in% names(intercept)) {
    text <- paste0(
      "The model's intercept's median is ",
      format_value(intercept$Median),
      "."
    )
    text_full <- paste0(
      "The model's intercept's median is ",
      format_value(intercept$Median),
      " (MAD = ",
      format_value(intercept$MAD),
      ", ",
      format_ci(intercept$CI_low, intercept$CI_high, ci)
    )
  } else if ("Mean" %in% names(intercept)) {
    text <- paste0(
      "The model's intercept's mean is ",
      format_value(intercept$Mean),
      "."
    )
    text_full <- paste0(
      "The model's intercept's mean is ",
      format_value(intercept$Mean),
      " (MAD = ",
      format_value(intercept$SD),
      ", ",
      format_ci(intercept$CI_low, intercept$CI_high, ci)
    )
  } else if ("MAP" %in% names(intercept)) {
    text <- paste0(
      "The model's intercept's MAP is ",
      format_value(intercept$MAP),
      "."
    )
    text_full <- paste0(
      "The model's intercept's MAP is ",
      format_value(intercept$MAP),
      " (",
      format_ci(intercept$CI_low, intercept$CI_high, ci)
    )
  } else {
    text <- ""
    text_full <- "The intercept has no estimate ("
  }


  if ("pd" %in% names(intercept)) {
    text_full <- paste0(
      text_full,
      ", ",
      format_pd(intercept$pd)
    )
  }

  if ("ROPE_Percentage" %in% names(intercept)) {
    text_full <- paste0(
      text_full,
      ", ",
      format_rope(intercept$ROPE_Percentage)
    )
  }

  text_full <- paste0(text_full, ").")

  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}












#' @keywords internal
model_text_parameters_bayesian <- function(parameters, ci = 0.90, rope_full = TRUE, effsize = "cohen1988", ...) {
  if (rope_full) {
    rope_ci <- 1
  } else {
    rope_ci <- ci
  }

  parameters <- parameters[parameters$Parameter != "(Intercept)", ]

  # Estimates
  estimate_full <- ""
  estimate_name <- ""
  if ("Median" %in% names(parameters)) {
    estimate_name <- "Median"
    estimate_full <- paste0(
      estimate_full,
      "Median = ",
      format_value(parameters$Median),
      ", MAD = ",
      format_value(parameters$MAD),
      ", "
    )
  }

  if ("Mean" %in% names(parameters)) {
    if (estimate_name == "") {
      estimate_name <- "Mean"
    }
    estimate_full <- paste0(
      estimate_full,
      "Mean = ",
      format_value(parameters$Mean),
      ", SD = ",
      format_value(parameters$SD),
      ", "
    )
  }

  if ("MAP" %in% names(parameters)) {
    if (estimate_name == "") {
      estimate_name <- "MAP"
    }
    estimate_full <- paste0(
      estimate_full,
      "MAP = ",
      format_value(parameters$MAP),
      ", "
    )
  }

  if (all(estimate_full != "")) {
    estimate <- paste0(stringr::str_split(estimate_full, ", ", simplify = TRUE)[, 1], ", ")
  } else {
    stop("No estimate in parameters.")
  }

  estimate <- paste0(estimate, format_ci(parameters$CI_low,
    parameters$CI_high,
    ci = ci
  ))
  estimate_full <- paste0(estimate_full, format_ci(parameters$CI_low,
    parameters$CI_high,
    ci = ci
  ))


  # Intro
  if ("pd" %in% names(parameters)) {
    text <- paste0(
      "  - ",
      parameters$Parameter,
      " has a probability of ",
      format_value(parameters$pd),
      "% of being ",
      interpret_direction(parameters[[estimate_name]])
    )
  } else {
    text <- paste0(
      "  - ",
      parameters$Parameter,
      "'s ",
      estimate_name,
      " is ",
      interpret_direction(parameters[[estimate_name]])
    )
  }

  text_full <- paste0(text, " (", estimate_full, ")")
  text <- paste0(text, " (", estimate, ")")


  if ("ROPE_Percentage" %in% names(parameters) | (!is.null(effsize) & "Std_Median" %in% names(parameters))) {
    text_full <- paste0(text_full, " and can be considered as ")
    text <- paste0(text, " and can be considered as ")
  } else {
    text_full <- paste0(text_full, ".")
    text <- paste0(text, ".")
  }

  # ROPE
  if ("ROPE_Percentage" %in% names(parameters)) {
    text_full <- paste0(
      text_full,
      interpret_rope(parameters$ROPE_Percentage, ci = rope_ci),
      " (",
      format_rope(parameters$ROPE_Percentage), ")"
    )
    text <- paste0(
      text,
      interpret_rope(parameters$ROPE_Percentage, ci = rope_ci),
      " (",
      format_rope(parameters$ROPE_Percentage), ")"
    )

    if (is.null(effsize) | !"Std_Median" %in% names(parameters)) {
      text_full <- paste0(text_full, ".")
      text <- paste0(text, ".")
    }
  }


  # Effect size text
  if (!is.null(effsize) & "Std_Median" %in% names(parameters)) {
    if ("ROPE_Percentage" %in% names(parameters)) {
      text_full <- paste0(text_full, " and ")
      text <- paste0(text, " and ")
    }

    text <- paste0(
      text,
      interpret_d(parameters[[estimate_name]], rules = effsize),
      " (Std. ",
      estimate_name,
      " = ",
      format_value(parameters[[estimate_name]]),
      ")."
    )

    if (estimate_name == "Median") {
      text_full <- paste0(
        text_full,
        interpret_d(parameters[[estimate_name]], rules = effsize),
        " (Std. ",
        estimate_name,
        " = ",
        format_value(parameters[[estimate_name]]),
        ", MAD = ",
        format_value(parameters$MAD),
        ", ",
        format_ci(parameters$Std_CI_low,
          parameters$Std_CI_high,
          ci = ci
        ),
        ")."
      )
    } else if (estimate_name == "Mean") {
      text_full <- paste0(
        text_full,
        interpret_d(parameters[[estimate_name]], rules = effsize),
        " (Std. ",
        estimate_name,
        " = ",
        format_value(parameters[[estimate_name]]),
        ", SD = ",
        format_value(parameters$SD),
        ", ",
        format_ci(parameters$Std_CI_low,
          parameters$Std_CI_high,
          ci = ci
        ),
        ")."
      )
    } else if (estimate_name == "MAP") {
      text_full <- paste0(
        text_full,
        interpret_d(parameters[[estimate_name]], rules = effsize),
        " (Std. ",
        estimate_name,
        " = ",
        format_value(parameters[[estimate_name]]),
        ", ",
        format_ci(parameters$Std_CI_low,
          parameters$Std_CI_high,
          ci = ci
        ),
        ")."
      )
    }
  }

  text <- paste0(c("\n\nWithin this model: ", text), collapse = "\n")
  text_full <- paste0(c("\n\nWithin this model: ", text_full), collapse = "\n")

  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}
