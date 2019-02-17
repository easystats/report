#' @keywords internal
model_text_parameters_lm <- function(model, parameters, ci = 0.95, effsize = "cohen1988", ...) {
  parameters <- parameters[parameters$Parameter != "(Intercept)", ]

  # Effect size text
  if (!is.null(effsize) & "Std_beta" %in% names(parameters)) {
    parameters$effsize_text <- paste0(
      " and ",
      interpret_d(parameters$Std_beta, rules = effsize),
      " (Std. beta = ",
      format_value(parameters$Std_beta),
      ")."
    )
    parameters$effsize_text_full <- paste0(
      " and ",
      interpret_d(parameters$Std_beta, rules = effsize),
      " (Std. beta = ",
      format_value(parameters$Std_beta),
      ", Std. SE = ",
      format_value(parameters$Std_SE),
      ", Std. ",
      format_ci(parameters$Std_CI_low, parameters$Std_CI_high, ci),
      ")."
    )
    parameters$significant_full <- paste0(interpret_direction(parameters$beta), ", ", interpret_p(parameters$p))
  } else {
    parameters$effsize_text <- "."
    parameters$effsize_text_full <- "."
    parameters$significant_full <- paste0(interpret_direction(parameters$beta), " and ", interpret_p(parameters$p))
  }


  text <- paste0(
    "  - ",
    parameters$Parameter,
    " is ",
    interpret_p(parameters$p),
    " (beta = ",
    format_value(parameters$beta),
    ", ",
    format_ci(parameters$CI_low, parameters$CI_high, ci),
    ", p ",
    format_p(parameters$p),
    ")",
    parameters$effsize_text
  )
  text <- paste0(c("\n\nWithin this model: ", text), collapse = "\n")

  text_full <- paste0(
    "  - ",
    parameters$Parameter,
    " is ",
    parameters$significant_full,
    " (beta = ",
    format_value(parameters$beta),
    ", SE = ",
    format_value(parameters$SE),
    ", t(",
    format_value_unless_integers(parameters$DoF_residual),
    ") = ",
    format_value(parameters$t),
    ", ",
    format_ci(parameters$CI_low, parameters$CI_high, ci),
    ", p ",
    format_p(parameters$p),
    ")",
    parameters$effsize_text_full
  )
  text_full <- paste0(c("\n\nWithin this model: ", text_full), collapse = "\n")

  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}













#' @keywords internal
model_text_parameters_logistic <- function(model, parameters, ci = 0.95, effsize = "chen2010", ...) {
  parameters <- parameters[parameters$Parameter != "(Intercept)", ]

  # Effect size text
  if (!is.null(effsize) & "Std_beta" %in% names(parameters)) {
    modeltype <- insight::model_info(model)
    if (modeltype$is_logit) {
      effsize_text <- interpret_odds(parameters$Std_beta, rules = effsize, log = TRUE)
    } else {
      effsize_text <- "[NO INTERPRETATION AVAILABLE]"
    }


    parameters$effsize_text <- paste0(
      " and ",
      effsize_text,
      " (Std. beta = ",
      format_value(parameters$Std_beta),
      ")."
    )
    parameters$effsize_text_full <- paste0(
      " and ",
      effsize_text,
      " (Std. beta = ",
      format_value(parameters$Std_beta),
      ", Std. SE = ",
      format_value(parameters$Std_SE),
      ", Std. ",
      format_ci(parameters$Std_CI_low, parameters$Std_CI_high, ci),
      ")."
    )
    parameters$significant_full <- paste0(interpret_direction(parameters$beta), ", ", interpret_p(parameters$p))
  } else {
    parameters$effsize_text <- "."
    parameters$effsize_text_full <- "."
    parameters$significant_full <- paste0(interpret_direction(parameters$beta), " and ", interpret_p(parameters$p))
  }


  text <- paste0(
    "  - ",
    parameters$Parameter,
    " is ",
    interpret_p(parameters$p),
    " (beta = ",
    format_value(parameters$beta),
    ", ",
    format_ci(parameters$CI_low, parameters$CI_high, ci),
    ", p ",
    format_p(parameters$p),
    ")",
    parameters$effsize_text
  )
  text <- paste0(c("\n\nWithin this model: ", text), collapse = "\n")

  text_full <- paste0(
    "  - ",
    parameters$Parameter,
    " is ",
    parameters$significant_full,
    " (beta = ",
    format_value(parameters$beta),
    ", SE = ",
    format_value(parameters$SE),
    ", z = ",
    format_value(parameters$z),
    ", ",
    format_ci(parameters$CI_low, parameters$CI_high, ci),
    ", p ",
    format_p(parameters$p),
    ")",
    parameters$effsize_text_full
  )
  text_full <- paste0(c("\n\nWithin this model: ", text_full), collapse = "\n")

  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}














#' @keywords internal
model_text_parameters_bayesian <- function(model, parameters, ci = 0.90, rope_full = TRUE, effsize = "cohen1988", ...) {
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

    modeltype <- insight::model_info(model)
    if (modeltype$is_logit) {
      effsize_text <- interpret_odds(parameters[[estimate_name]], rules = effsize, log = TRUE)
    } else if (modeltype$is_linear) {
      effsize_text <- interpret_d(parameters[[estimate_name]], rules = effsize)
    } else {
      effsize_text <- "[NO INTERPRETATION AVAILABLE]"
    }

    text <- paste0(
      text,
      effsize_text,
      " (Std. ",
      estimate_name,
      " = ",
      format_value(parameters[[estimate_name]]),
      ")."
    )

    if (estimate_name == "Median") {
      text_full <- paste0(
        text_full,
        effsize_text,
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
