#' @keywords internal
model_text_initial_lm <- function(model, parameters, ci = 0.95, ...) {
  intercept <- parameters[parameters$Parameter == "(Intercept)", ]

  text <- paste0(
    "The model's intercept is at ",
    format_value(intercept$beta),
    "."
  )
  text_full <- paste0(
    "The model's intercept, corresponding to ",
    .text_intercept(model),
    ", is at ",
    format_value(intercept$beta),
    " (t(",
    format_value_unless_integers(intercept$DoF_residual),
    ") = ",
    format_value(intercept$t),
    ", ",
    format_ci(intercept$CI_low, intercept$CI_high, ci),
    ", p ",
    format_p(intercept$p),
    ")."
  )

  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}






#' @keywords internal
model_text_initial_logistic <- function(model, parameters, ci = 0.95, ...) {
  intercept <- parameters[parameters$Parameter == "(Intercept)", ]

  text <- paste0(
    "The model's intercept is at ",
    format_value(intercept$beta),
    "."
  )
  text_full <- paste0(
    "The model's intercept, corresponding to ",
    .text_intercept(model),
    ", is at ",
    format_value(intercept$beta),
    " (z = ",
    format_value(intercept$z),
    ", ",
    format_ci(intercept$CI_low, intercept$CI_high, ci),
    ", p ",
    format_p(intercept$p),
    ")."
  )

  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}





#' @keywords internal
model_text_initial_bayesian <- function(model, parameters, ci = 0.90, ...) {
  intercept <- parameters[parameters$Parameter == "(Intercept)", ]

  text <- ""
  intercept_values <- " ("
  if ("Median" %in% names(intercept)) {
    text <- paste0(
      "has a median of ",
      format_value(intercept$Median)
    )

    intercept_values <- paste0(
      intercept_values,
      "MAD = ",
      format_value(intercept$MAD)
    )
  }
  if ("Mean" %in% names(intercept)) {
    comma <- ""
    if (intercept_values != " (") {
      comma <- paste0(", Mean = ", format_value(intercept$Mean), ", ")
    } else {
      text <- paste0(
        "has a mean of ",
        format_value(intercept$Mean)
      )
    }

    intercept_values <- paste0(
      intercept_values,
      comma,
      "SD = ",
      format_value(intercept$SD)
    )
  }
  if ("MAP" %in% names(intercept)) {
    comma <- ""
    if (intercept_values != " (") {
      comma <- paste0(", MAP = ", format_value(intercept$MAP))
    } else {
      text <- paste0(
        "has a MAP of ",
        format_value(intercept$MAP)
      )
    }

    intercept_values <- paste0(intercept_values, comma)
  }
  if ("pd" %in% names(intercept)) {
    comma <- ""
    if (intercept_values != " (") comma <- ", "

    intercept_values <- paste0(
      intercept_values,
      comma,
      "pd = ",
      format_pd(intercept$pd)
    )
  }
  if ("ROPE_Percentage" %in% names(intercept)) {
    comma <- ""
    if (intercept_values != " (") comma <- ", "

    intercept_values <- paste0(
      intercept_values,
      comma,
      format_rope(intercept$ROPE_Percentage)
    )
  }


  if (intercept_values == " (") {
    intercept_values <- "."
  } else {
    intercept_values <- paste0(intercept_values, ").")
  }

  if (text == "") {
    text <- "has no point-estimate"
  }


  text_full <- paste0(
    "The model's intercept, corresponding to ",
    .text_intercept(model),
    ", ",
    text,
    intercept_values
  )
  text <- paste0("The model's intercept ", text, ".")


  out <- list(
    "text" = text,
    "text_full" = text_full
  )
  return(out)
}














#' @keywords internal
.text_intercept <- function(model) {
  data <- insight::get_data(model)[insight::find_terms(model)$conditional]
  text <- c()
  for (col in names(data)) {
    if (is.numeric(data[[col]])) {
      text <- c(text, paste0(col, " = 0"))
    } else if (is.factor(data[[col]])) {
      text <- c(text, paste0(col, " = ", levels(data[col])))
    } else {
      text <- c(text, paste0(col, " = ???"))
    }
  }
  return(format_text_collapse(text))
}
