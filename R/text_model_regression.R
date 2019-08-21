#' @export
text_model.glm <- function(model, parameters, ci = NULL, ci_method = NULL, standardize = "refit", standardize_robust = FALSE, effsize = NULL, bootstrap = FALSE, iterations = 500, test = NULL, rope_range = NULL, rope_ci = NULL, p_method = NULL, ...) {

  # Model info
  info <- insight::model_info(model)

  # Boostrap
  if (bootstrap) {
    boostrapped <- paste0("bootstrapped (", iterations, " iterations) ")
  } else {
    boostrapped <- ""
  }

  # Initial
  text <- paste0(
    "We fitted a ",
    boostrapped,
    format_model(model)
  )
  text_full <- text

  # Algorithm
  text_full <- paste0(
    text_full,
    " (estimated using ",
    format_algorithm(model),
    ")"
  )


  # To predict
  to_predict_text <- paste0(" to predict ", insight::find_response(model))
  if (all(insight::find_parameters(model, flatten = FALSE) == "(Intercept)") == FALSE) {
    to_predict_text <- paste0(
      to_predict_text,
      " with ",
      format_text(insight::find_predictors(model, effects = "fixed", flatten = TRUE))
    )
  }


  text_full <- paste0(text_full, to_predict_text, " (formula = ", format(insight::find_formula(model)$conditional), ").")
  text <- paste0(text, to_predict_text, ".")

  # Random
  if (!is.null(insight::find_terms(model)$random)) {
    text_random <- format_text(insight::find_terms(model)$random)
    text_random <- paste0(" The model included ", text_random, " as random effects")
    text_random_full <- paste0(text_random, " (formula = ", paste0(format(insight::find_formula(model)$random), collapse = " + "), ").")
    text <- paste0(text, text_random, ".")
    text_full <- paste0(text_full, text_random_full)
  }


  # Details
  if (info$is_bayesian | bootstrap == TRUE) {
    text_full <- paste0(text_full, .text_priors(parameters))

    if (!is.null(rope_range)) {
      if (rope_range == "default") rope_range <- bayestestR::rope_range(model)
      text_full <- paste0(
        text_full,
        .text_rope(rope_range, rope_ci)
      )
    }
  }
  if (!is.null(ci_method)) {
    text_full <- paste0(
      text_full,
      .text_ci(ci, ci_method = ci_method, p_method = p_method)
    )
  }
  if (!is.null(standardize)) {
    text_full <- paste0(
      text_full,
      .text_standardize(standardize, standardize_robust)
    )
  }
  if (!is.null(effsize)) {
    text_full <- paste0(
      text_full,
      .text_effsize(effsize)
    )
  }


  list(
    "text" = text,
    "text_full" = text_full
  )
}


#' @export
text_model.lm <- text_model.glm

#' @export
text_model.merMod <- text_model.glm

#' @export
text_model.stanreg <- text_model.glm
