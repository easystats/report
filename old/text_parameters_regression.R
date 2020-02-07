#' @export
text_parameters.lm <- function(model, parameters = NULL, prefix = "  - ", ci = 0.95, effsize = "funder2019", ...) {
  if (!is.null(attributes(parameters)$pretty_names)) {
    parameters$Parameter <- attributes(parameters)$pretty_names[parameters$Parameter]
  }

  # Intercept-only
  if (all(insight::find_parameters(model, flatten = FALSE) == "(Intercept)") == FALSE) {
    parameters <- as.data.frame(parameters[!parameters$Parameter %in% c("(Intercept)"), ])
  }

  if (insight::model_info(model)$is_binomial) {
    type <- "logodds"
  } else {
    type <- "d"
  }

  text_full <- .text_parameters(parameters, ci = ci, effsize = effsize, type = type, prefix = prefix, bayesian_diagnostic = TRUE)
  text <- .text_parameters(parameters[names(parameters) %in% c("Parameter", "Coefficient", "Median", "Mean", "MAP", "CI_low", "CI_high", "p", "pd", "ROPE_Percentage", "BF", "Std_Coefficient", "Std_Median", "Std_Mean", "Std_MAP")], ci = ci, effsize = effsize, type = type, prefix = prefix, bayesian_diagnostic = FALSE)

  list(
    "text" = text,
    "text_full" = text_full
  )
}




#' @export
text_parameters.glm <- text_parameters.lm

#' @export
text_parameters.merMod <- text_parameters.lm

#' @export
text_parameters.stanreg <- text_parameters.lm







#' @keywords internal
.text_parameters <- function(parameters, ci, effsize, type = "d", prefix = "  - ", bayesian_diagnostic = FALSE) {
  text <- .text_parameters_combine(
    names = .text_parameters_names(parameters),
    direction = .text_parameters_direction(parameters),
    size = .text_parameters_size(parameters, effsize = effsize, type = type),
    significance = .text_parameters_significance(parameters),
    indices = .text_parameters_indices(parameters, ci = ci),
    bayesian_diagnostic = .text_parameters_bayesian_diagnostic(parameters, bayesian_diagnostic = bayesian_diagnostic)
  )
  paste0(paste0(prefix, text), collapse = "\n")
}
