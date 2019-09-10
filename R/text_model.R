#' Model description textual reporting
#'
#' Model textual description.
#'
#' @param model Object.
#' @param ... Arguments passed to or from other methods.
#'
#'
#' @seealso report
#'
#' @export
text_model <- function(model, ...) {
  UseMethod("text_model")
}





.text_effsize <- function(effsize) {
  # Effect size
  if (!is.null(effsize)) {
    if (is.character(effsize)) {
      effsize_name <- ifelse(effsize == "cohen1988", "Cohen's (1988)",
        ifelse(effsize == "sawilowsky2009", "Savilowsky's (2009)",
          ifelse(effsize == "gignac2016", "Gignac's (2016)",
            ifelse(effsize == "funder2019", "Funder's (2019)",
              ifelse(effsize == "chen2010", "Chen's (2010)", effsize)
            )
          )
        )
      )
      text <- paste0(" Effect sizes were labelled following ", effsize_name, " recommendations.")
    } else {
      text <- paste0(" Effect sizes were labelled following a custom set of rules.")
    }
  } else {
    text <- ""
  }
  text
}


#' @keywords internal
.text_ci <- function(ci, ci_method, p_method = NULL) {
  text <- ""
  # Frequentist --------------------------------

  if (!is.null(p_method) && p_method == "wald" && !is.null(ci_method) && ci_method == "wald") {
    return(paste0(" The ", insight::format_value(ci * 100, protect_integers = TRUE), "%", " Confidence Intervals (CIs) and p-values were computed using Wald approximation."))
  }


  # CI
  if (ci_method == "wald") {
    text <- paste0(" The ", insight::format_value(ci * 100, protect_integers = TRUE), "%", " Confidence Intervals (CIs) were computed using Wald approximation")
  } else if (ci_method == "boot"){
    text <- paste0(" The ", insight::format_value(ci * 100, protect_integers = TRUE), "%", " Confidence Intervals (CIs) were obtained through bootstrapping")
  } else{
    text <- paste0(" The ", insight::format_value(ci * 100, protect_integers = TRUE), "%", " Confidence Intervals (CIs) were obtained through ", ci_method)
  }


  # P values
  if (!is.null(p_method)) {
    if (text != "") text <- paste0(text, " and ")
    if (p_method == "wald") text <- paste0(text, "p-values were computed using Wald approximation")
    if (p_method == "kenward") text <- paste0(text, "p-values were computed using Kenward-Roger approximation")
  }


  # Bayesian --------------------------------
  if (tolower(ci_method) == "hdi") {
    text <- paste0(" The ", insight::format_value(ci * 100, protect_integers = TRUE), "%", " Credible Intervals (CIs) were based on Highest Density Intervals (HDI)")
  }

  if (tolower(ci_method) %in% c("eti", "quantile", "ci")) {
    text <- paste0(" The ", insight::format_value(ci * 100, protect_integers = TRUE), "%", " Credible Intervals (CIs) are Equal-Tailed Intervals (ETI) computed using quantiles")
  }

  paste0(text, ".")
}





#' @keywords internal
.text_rope <- function(rope_range, rope_ci) {
  if (rope_ci == 1) {
    text <- paste0(
      " The Region of Practical Equivalence (ROPE) ",
      "percentage was defined as the proportion of the ",
      "posterior distribution within the [",
      insight::format_value(rope_range[1]),
      ", ",
      insight::format_value(rope_range[2]),
      "] range."
    )
  } else {
    text <- paste0(
      " The Region of Practical Equivalence (ROPE) ",
      "percentage was defined as the proportion of the ",
      rope_ci * 100, "% CI within the [",
      insight::format_value(rope_range[1]),
      ", ",
      insight::format_value(rope_range[2]),
      "] range."
    )
  }
  text
}



#' @keywords internal
.text_standardize <- function(standardize, standardize_robust = FALSE) {
  if (standardize == "refit") {
    if (standardize_robust == TRUE) {
      robust <- "(using the median and the MAD, a robust equivalent of the SD) "
    } else {
      robust <- ""
    }
    text <- paste0(" Standardized parameters were obtained by fitting the model on a standardized version ", robust, "of the dataset.")
  } else if (standardize == "2sd") {
    if (standardize_robust == TRUE) {
      robust <- "MAD (a robust equivalent of the SD) "
    } else {
      robust <- "SD "
    }
    text <- paste0(" Standardized parameters were obtained by standardizing the data by 2 times the ", robust, " (see Gelman, 2008).")
  } else if (standardize == "smart" | standardize == "classic") {
    if (standardize_robust == TRUE) {
      robust <- "median and the MAD (a robust equivalent of the SD) of the response variable."
    } else {
      robust <- "mean and the SD of the response variable."
    }
    text <- paste0(" Parameters were scaled by the ", robust)
  } else {
    text <- paste0(" Parameters were standardized using the ", standardize, " method.")
  }

  text
}



#' @keywords internal
.text_priors <- function(parameters) {
  params <- parameters[parameters$Parameter != "(Intercept)", ]

  # Return empty if no priors info
  if (!"Prior_Distribution" %in% names(params) | nrow(params) == 0) {
    return("")
  }

  values <- ifelse(params$Prior_Distribution == "normal",
    paste0("mean = ", insight::format_value(params$Prior_Location), ", SD = ", insight::format_value(params$Prior_Scale)),
    paste0("location = ", insight::format_value(params$Prior_Location), ", scale = ", insight::format_value(params$Prior_Scale))
  )

  values <- paste0(params$Prior_Distribution, " (", values, ")")

  if (length(unique(values)) == 1 & nrow(params) > 1) {
    text <- paste0("all set as ", values[1])
  } else {
    text <- paste0("set as ", format_text(values))
  }

  paste0(" Priors over parameters were ", text, " distributions.")
}
