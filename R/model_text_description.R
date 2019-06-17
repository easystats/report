#' @keywords internal
model_text_description <- function(model, ci = 0.95, ci_method="wald", effsize = "effsize", bootstrap = FALSE, iterations = 500, test = c("pd", "rope"), rope_range = "default", rope_full = TRUE, p_method = "wald", ...) {

  # Model info
  info <- insight::model_info(model)

  # Boostrap
  if (bootstrap) {
    boostrapped <- paste0("bootstrapped (n = ", iterations, ") ")
  } else {
    boostrapped <- ""
  }

  # Initial
  text <- paste0(
    "We fitted a ",
    boostrapped,
    format_model(model))
  text_full <- text

  # Algorithm
  text_full <- paste0(text_full,
                      " (using ",
                      format_algorithm(model),
                      ")")


  # To predict
  to_predict_text <- paste0(
    " to predict ",
    insight::find_response(model),
    " with ",
    format_text_collapse(insight::find_predictors(model, effects = "fixed", flatten = TRUE))
  )

  text_full <- paste0(text_full, to_predict_text, " (formula = ", format(insight::find_formula(model)$conditional), ").")
  text <- paste0(text, to_predict_text, ".")

  # Random
  if (!is.null(insight::find_terms(model)$random)) {
    text_random <- format_text_collapse(insight::find_terms(model)$random)
    text_random <- paste0(" The model included ", text_random, " as random effects")
    text_random_full <- paste0(text_random, " (formula = ", format(insight::find_formula(model)$random), ").")
    text <- paste0(text, text_random, ".")
    text_full <- paste0(text_full, text_random_full)
  }



  # ROPE
  if ("rope" %in% tolower(c(test)) & info$is_bayesian) {
    if (all(rope_range == "default")) {
      rope_range <- bayestestR::rope_range(model)
    } else if (!all(is.numeric(rope_range)) | length(rope_range) != 2) {
      stop("`rope_range` should be 'default' or a vector of 2 numeric values (e.g., c(-0.1, 0.1)).")
    }

    text_full <- paste0(text_full, .format_ROPE_description(rope_full, rope_range, ci))
  }

  # p values and CIs
  if (info$is_mixed & info$is_linear & !info$is_bayesian) {
    if(ci_method == "wald" & p_method == "wald"){
      text_full <- paste0(text_full, " The ", format_value(ci*100), "%", " Confidence Intervals (CIs) and p values were computed using Wald approximation.")
    } else{
      if(ci_method == "wald"){
        text_full <- paste0(text_full, " The ", format_value(ci*100), "%", " Confidence Intervals (CIs) were computed using Wald approximation")
      } else{
        text_full <- paste0(text_full, " The ", format_value(ci*100), "%", " Confidence Intervals (CIs) were obtained through bootstrapping")
      }
      if(p_method == "wald"){
        text_full <- paste0(text_full, " and p values were computed using Wald approximation.")
      } else{
        text_full <- paste0(text_full, " and p values were computed using Kenward-Roger approximation.")
      }
    }
  } else if(info$is_mixed & !info$is_linear & !info$is_bayesian & ci_method != "wald") {
    text_full <- paste0(text_full, " The ", format_value(ci*100), "%", " Confidence Intervals (CIs) were obtained through bootstrapping.")
  } else if(info$is_bayesian){
    if(ci_method == "hdi"){
      text_full <- paste0(text_full, " The ", format_value(ci*100), "%", " Credible Intervals (CIs) were computed using the Highest Density Interval (HDI) method.")
    } else if(ci_method == "quantile"){
      text_full <- paste0(text_full, " The ", format_value(ci*100), "%", " Credible Intervals (CIs) were computed using the quantile method.")
    } else{
      text_full <- paste0(text_full, " The ", format_value(ci*100), "%", " Credible Intervals (CIs) were computed using ", ci_method, ".")
    }
  }


  # Effect size
  text_full <- paste0(text_full, .format_effsize_description(effsize))


  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}





#' @keywords internal
.format_ROPE_description <- function(rope_full, rope_range, ci){
  if (rope_full) {
    text_full <- paste0(
      " The Region of Practical Equivalence (ROPE) ",
      "percentage was defined as the proportion of the ",
      "posterior distribution within the [",
      format_value(rope_range[1]),
      ", ",
      format_value(rope_range[2]),
      "] range."
    )
  } else {
    text_full <- paste0(
      " The Region of Practical Equivalence (ROPE) ",
      "percentage was defined as the proportion of the ",
      ci * 100, "% HDI within the [",
      format_value(rope_range[1]),
      ", ",
      format_value(rope_range[2]),
      "] range."
    )

    return(text_full)
  }
}




.format_effsize_description <- function(effsize){
  # Effect size
  if (!is.null(effsize)) {
    if (is.character(effsize)) {
      effsize_name <- ifelse(effsize == "cohen1988", "Cohen's (1988)",
                             ifelse(effsize == "sawilowsky2009", "Savilowsky's (2009)",
                                    ifelse(effsize == "gignac2016", "Gignac's (2016)",
                                          ifelse(effsize == "chen2010", "Chen's (2010)", effsize)
                                    )
                             )
      )
      text_full <- paste0(" Effect sizes were labelled following ", effsize_name, " recommendations.")
    } else {
      text_full <- paste0(" Effect sizes were labelled following a custom set of rules.")
    }
  } else{
    text_full <- ""
  }
  return(text_full)
}
