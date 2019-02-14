#' @keywords internal
model_text_description_lm <- function(model, effsize="effsize"){

  text <- paste0(
    "We fitted a linear model to predict ",
    insight::find_response(model),
    " with ",
    format_text_collapse(insight::find_predictors(model, effects="fixed", flatten=TRUE))
  )
  text_full <- paste0(text, " (formula = ", insight::find_formula(model)$conditional, ").")
  text <- paste0(text, ".")

  # Effect size
  if (!is.null(effsize)) {
    if (is.character(effsize)) {
      effsize_name <- ifelse(effsize == "cohen1988", "Cohen's (1988)",
                             ifelse(effsize == "sawilowsky2009", "Savilowsky's (2009)", effsize)
      )
      text_full <- paste0(text_full, " Effect sizes were labelled following ", effsize_name, " recommendations.")
    } else {
      text_full <- paste0(text_full, " Effect sizes were labelled following a custom set of rules.")
    }
  }

  out <- list(
    "text"=text,
    "text_full"=text_full
  )
  return(out)
}












#' @keywords internal
model_text_performance_lm <- function(performance){

  # R2
  if("R2" %in% names(performance)){
    text <- paste0(
      "The model's explanatory power (R2) is of ",
      format_value(performance$R2))
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
      format_p(performance$p))

    if("R2" %in% names(performance)){
      text <- paste0(text, " (adj. R2 = ",
                     format_value(performance$R2_adj),
                     ").")
      text_full <- paste0(text_full, ", adj. R2 = ",
                     format_value(performance$R2_adj),
                     ").")
    } else{
      text <- paste0(text, ".")
      text_full <- paste0(text_full, ").")
    }
  } else{
    text <- ""
    text_full <- ""
  }

  out <- list(
    "text"=text,
    "text_full"=text_full
  )
  return(out)

}






#' @keywords internal
model_text_initial_lm <- function(parameters, ci=0.95){

  intercept <- parameters[parameters$Parameter == "(Intercept)", ]

  text <- paste0(
    "The model's intercept is at ",
    format_value(intercept$beta),
    "."
  )
  text_full <- paste0(
    "The model's intercept is at ",
    format_value(intercept$beta),
    "(t(",
    format_value_unless_integers(intercept$DoF_residual),
    ") = ",
    format_value(intercept$t),
    ", ",
    format_CI(intercept$CI_low, intercept$CI_high, ci),
    ", p ",
    format_p(intercept$p),
    ")."
  )

  out <- list(
    "text"=text,
    "text_full"=text_full
  )
  return(out)

}












#' @keywords internal
model_text_parameters_lm <- function(parameters, ci=0.95, effsize="cohen1988"){

  parameters <- parameters[parameters$Parameter != "(Intercept)", ]

  # Effect size text
  if ("Std_beta" %in% names(parameters)) {
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
      format_CI(parameters$Std_CI_low, parameters$Std_CI_high, ci),
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
    format_CI(parameters$CI_low, parameters$CI_high, ci),
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
    ", t(",
    format_value_unless_integers(parameters$DoF_residual),
    ") = ",
    format_value(parameters$t),
    ", ",
    format_CI(parameters$CI_low, parameters$CI_high, ci),
    ", p ",
    format_p(parameters$p),
    ")",
    parameters$effsize_text_full
  )
  text_full <- paste0(c("\n\nWithin this model: ", text_full), collapse = "\n")

  out <- list("text" = text,
              "text_full" = text_full)
  return(out)

}









#' @export
model_text.lm <- function(model, performance, parameters, ci=0.95, effsize="cohen1988", ...){
  text_description <- model_text_description_lm(model, effsize=effsize)
  text_performance <- model_text_performance_lm(performance)
  text_initial <- model_text_initial_lm(parameters, ci=ci)
  text_parameters <- model_text_parameters_lm(parameters, ci=ci, effsize=effsize)

  text <- paste(text_description$text,
                text_performance$text,
                text_initial$text,
                text_parameters$text)

  text_full <- paste(text_description$text_full,
                     text_performance$text_full,
                     text_initial$text_full,
                     text_parameters$text_full)

  out <- list(
    "text"=text,
    "text_full"=text_full
  )
  return(out)
}
