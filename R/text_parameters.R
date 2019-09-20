#' Parameters textual reporting
#'
#' Convert parameters table to text.
#'
#' @param model Object.
#' @param parameters Parameters table.
#' @param prefix The bullet in front of each sentence.
#' @param ... Arguments passed to or from other methods.
#'
#'
#' @seealso report
#'
#' @export
text_parameters <- function(model, parameters, prefix = "  - ", ...) {
  UseMethod("text_parameters")
}







#' @keywords internal
.text_parameters_names <- function(parameters, parameter_column = "Parameter", label = "effect of ") {
  names <- parameters[[parameter_column]]

  # Regular effects
  names[!grepl(" * ", names, fixed = TRUE)] <- paste0("The ", label, names[!grepl(" * ", names, fixed = TRUE)])

  interactions <- names[grepl(" * ", names, fixed = TRUE)]
  interactions <- unlist(lapply(strsplit(interactions, " * ", fixed = TRUE), function(x) {
    new <- paste(head(x, -1), collapse = " * ")
    new <- paste(tail(x, 1), "on", new)
    new
  }))
  names[grepl(" * ", names, fixed = TRUE)] <- paste0("The interaction ", label, interactions)
  names
}


#' @keywords internal
.text_parameters_direction <- function(parameters) {
  estimate_name <- names(parameters)[names(parameters) %in% c("Coefficient", "Difference", "Median", "Mean", "MAP")][1]


  # Bayes factor
  # if ("BF" %in% names(parameters)) {
  #   .add_bf <- function(bf, ...){
  #     ori_bf <- bf
  #     dir <- ifelse(log(bf) < 0,"BF01", "BF10")
  #
  #     bf[bf < 1] <- 1 / bf[bf < 1]
  #
  #     paste0(
  #       parameters::format_bf(bf, name = dir),
  #       ", considered ",
  #       report::interpret_bf(ori_bf, include_value = FALSE, ...),
  #       " the effect"
  #     )
  #   }
  #
  #   text <- paste0(
  #     .add_comma(text),
  #     .add_bf(parameters$BF)
  #   )
  # }


  # Probability of Direction
  if (length(estimate_name) == 1) {
    if ("pd" %in% names(parameters)) {
      text <- paste0(
        " has a probability of ",
        parameters::format_pd(parameters$pd, name = NULL),
        " of being ",
        interpret_direction(parameters[[estimate_name]])
      )
    } else {
      text <- paste0(
        " is ",
        interpret_direction(parameters[[estimate_name]])
      )
    }
  } else {
    text <- ""
  }

  text
}




#' @keywords internal
.text_parameters_size <- function(parameters, effsize = "cohen1988", type = "d") {
  if (is.null(effsize) || is.na(effsize)) {
    return("")
  }

  text <- ""

  estimate_name <- names(parameters)[names(parameters) %in% c("Std_Coefficient", "Std_Difference", "Std_Median", "Std_Mean", "Std_MAP")][1]

  if (!is.na(estimate_name)) {
    if (type == "d") {
      text <- interpret_d(parameters[[estimate_name]], rules = effsize)
    } else if (type == "logodds") {
      text <- interpret_odds(parameters[[estimate_name]], rules = effsize, log = TRUE)
    } else if (type == "r") {
      text <- interpret_r(parameters[[estimate_name]], rules = effsize)
    }
  } else {
    text <- ""
  }

  text
}





#' @keywords internal
.text_parameters_significance <- function(parameters, rope_ci = 1) {
  text <- ""

  if ("p" %in% names(parameters)) {
    text <- interpret_p(parameters$p)
  }

  if ("ROPE_Percentage" %in% names(parameters) & !is.null(rope_ci)) {
    text <- interpret_rope(parameters$ROPE_Percentage, ci = rope_ci)
  }
  text
}



#' @keywords internal
.text_parameters_indices <- function(parameters, ci = 0.89, coefname = "beta") {

  text <- ""

  if ("Coefficient" %in% names(parameters)) {
    text <- paste0(
      text,
      coefname,
      " = ",
      insight::format_value(parameters$Coefficient)
    )
  }

  if ("Difference" %in% names(parameters)) {
    text <- paste0(
      text,
      "Difference = ",
      insight::format_value(parameters$Difference)
    )
  }

  if ("SE" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "SE = ",
      insight::format_value(parameters$SE)
    )
  }

  if ("Median" %in% names(parameters)) {
    text <- paste0(
      text,
      "median = ",
      insight::format_value(parameters$Median)
    )
  }

  if ("MAD" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "MAD = ",
      insight::format_value(parameters$MAD)
    )
  }

  if ("Mean" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "mean = ",
      insight::format_value(parameters$Mean)
    )
  }

  if ("SD" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "SD = ",
      insight::format_value(parameters$SD)
    )
  }

  if ("MAP" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "MAP = ",
      insight::format_value(parameters$MAP)
    )
  }


  # CI
  if (all(c("CI_low", "CI_high") %in% names(parameters))) {
    text <- paste0(
      .add_comma(text),
      parameters::format_ci(parameters$CI_low, parameters$CI_high, ci = ci)
    )
  }

  # ROPE
  if ("ROPE_Percentage" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      parameters::format_rope(parameters$ROPE_Percentage)
    )
  }

  # Standardized stuff
  if ("Std_Coefficient" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "std. beta = ",
      insight::format_value(parameters$Std_Coefficient)
    )
  }

  if ("Std_Difference" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "std. difference = ",
      insight::format_value(parameters$Std_Difference)
    )
  }

  if ("Std_SE" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "std. SE = ",
      insight::format_value(parameters$Std_SE)
    )
  }

  if ("Std_Median" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "std. median = ",
      insight::format_value(parameters$Std_Median)
    )
  }

  if ("Std_MAD" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "std. MAD = ",
      insight::format_value(parameters$Std_MAD)
    )
  }

  if ("Std_Mean" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "std. mean = ",
      insight::format_value(parameters$Std_Mean)
    )
  }

  if ("Std_SD" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "std. SD = ",
      insight::format_value(parameters$Std_SD)
    )
  }

  if ("Std_MAP" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "std. MAP = ",
      insight::format_value(parameters$Std_MAP)
    )
  }

  # ROPE
  if ("p" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      parameters::format_p(parameters$p)
    )
  }

  text
}




#' @keywords internal
.text_parameters_bayesian_diagnostic <- function(parameters, bayesian_diagnostic = TRUE) {
  # Convergence
  if ("Rhat" %in% names(parameters)) {
    convergence <- interpret_rhat(parameters$Rhat, rules = "vehtari2019")
    diagnostic <- ifelse(convergence == "converged",
      paste0(
        " The algorithm successfuly converged (Rhat = ",
        insight::format_value(parameters$Rhat, digits = 3),
        ")"
      ),
      paste0(
        " However, the algorithm might not have successfuly converged (Rhat = ",
        insight::format_value(parameters$Rhat, digits = 3),
        ")"
      )
    )

    if ("ESS" %in% names(parameters)) {
      stability <- interpret_effective_sample(parameters$ESS, rules = "burkner2017")
      diagnostic <- ifelse(stability == "sufficient" & convergence == "converged",
        paste0(
          diagnostic,
          " and the estimates can be considered as stable (ESS = ",
          insight::format_value(parameters$ESS, digits = 0),
          ")."
        ),
        ifelse(stability == "sufficient" & convergence != "converged",
          paste0(
            diagnostic,
            " even though the estimates can be considered as stable (ESS = ",
            insight::format_value(parameters$ESS, digits = 0),
            ")."
          ),
          ifelse(stability != "sufficient" & convergence == "converged",
            paste0(
              diagnostic,
              " but the estimates cannot be considered as stable (ESS = ",
              insight::format_value(parameters$ESS, digits = 0),
              ")."
            ),
            paste0(
              diagnostic,
              " and the estimates cannot be considered as stable (ESS = ",
              insight::format_value(parameters$ESS, digits = 0),
              ")."
            )
          )
        )
      )
      convergence <- ifelse(stability != "sufficient",
        "failed",
        convergence
      )
    } else {
      diagnostic <- paste0(diagnostic, ".")
    }
  } else {
    diagnostic <- ""
  }

  if (bayesian_diagnostic) {
    diagnostic
  } else {
    ifelse(parameters$convergence == "converged", diagnostic, "")
  }
}





#' @keywords internal
.text_parameters_combine <- function(names = "", direction = "", size = "", significance = "", indices = "", bayesian_diagnostic = "") {
  text <- paste0(names, direction)

  text <- ifelse(significance != "" & size != "", paste0(text, " and can be considered as ", size, " and ", significance),
    ifelse(significance != "" & size == "", paste0(text, " and can be considered as ", significance),
      ifelse(significance == "" & size != "", paste0(text, " and can be considered as ", size), text)
    )
  )

  text <- paste0(text, " (", indices, ").")
  paste0(text, bayesian_diagnostic)
}







#' @keywords internal
.add_comma <- function(text) {
  ifelse(substring(text, nchar(text) - 1) != ", " & text != "", paste0(text, ", "), text)
}
