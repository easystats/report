#' @keywords internal
model_text_description <- function(model, ci = 0.95, effsize = "effsize", bootstrap = FALSE, n = 500, test = c("pd", "rope"), rope_bounds = "default", rope_full = TRUE, ...) {
  if (bootstrap) {
    boostrapped <- paste0("bootstrapped (n = ", n, ") ")
  } else {
    boostrapped <- ""
  }

  text <- paste0(
    "We fitted a ",
    boostrapped,
    format_model(model),
    " to predict ",
    insight::find_response(model),
    " with ",
    format_text_collapse(insight::find_predictors(model, effects = "fixed", flatten = TRUE))
  )
  text_full <- paste0(text, " (formula = ", format(insight::find_formula(model)$conditional), ").")
  text <- paste0(text, ".")

  # Random
  if (!is.null(insight::find_terms(model)$random)) {
    text_random <- format_text_collapse(insight::find_terms(model)$random)
    text_random <- paste0(" The model included ", text_random, " as random effects")
    text_random_full <- paste0(text_random, " (formula = ", format(insight::find_formula(model)$random), ").")
    text <- paste0(text, text_random, ".")
    text_full <- paste0(text_full, text_random_full)
  }

  # ROPE
  if ("rope" %in% tolower(c(test)) & model_info(model)$is_bayesian) {
    if (all(rope_bounds == "default")) {
      rope_bounds <- c(-0.1 * sd(insight::get_response(model)), 0.1 * sd(insight::get_response(model)))
    } else if (!all(is.numeric(rope_bounds)) | length(rope_bounds) != 2) {
      stop("`rope_bounds` should be 'default' or a vector of 2 numeric values (e.g., c(-0.1, 0.1)).")
    }

    if (rope_full) {
      text_full <- paste0(
        text_full,
        " The Region of Practical Equivalence (ROPE) ",
        "percentage was defined as the proportion of the ",
        "posterior distribution within the [",
        format_value(rope_bounds[1]),
        ", ",
        format_value(rope_bounds[2]),
        "] range."
      )
    } else {
      text_full <- paste0(
        text_full,
        " The Region of Practical Equivalence (ROPE) ",
        "percentage was defined as the proportion of the ",
        ci * 100, "% HDI within the [",
        format_value(rope_bounds[1]),
        ", ",
        format_value(rope_bounds[2]),
        "] range."
      )
    }
  }


  # Effect size
  if (!is.null(effsize)) {
    if (is.character(effsize)) {
      effsize_name <- ifelse(effsize == "cohen1988", "Cohen's (1988)",
        ifelse(effsize == "sawilowsky2009", "Savilowsky's (2009)",
          ifelse(effsize == "chen2010", "Chen's (2010)", effsize)
        )
      )
      text_full <- paste0(text_full, " Effect sizes were labelled following ", effsize_name, " recommendations.")
    } else {
      text_full <- paste0(text_full, " Effect sizes were labelled following a custom set of rules.")
    }
  }


  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}
