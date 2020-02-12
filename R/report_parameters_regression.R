#' @export
report_parameters.lm <- function(model, parameters = NULL, prefix = "  - ", ci = 0.95, interpretation = "funder2019", ...) {
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

  text_full <- .report_parameters_regression(parameters, ci = ci, interpretation = interpretation, type = type, prefix = prefix, bayesian_diagnostic = TRUE)
  text <- .report_parameters_regression(parameters[names(parameters) %in% c("Parameter", "Coefficient", "Median", "Mean", "MAP", "CI_low", "CI_high", "p", "pd", "ROPE_Percentage", "BF", "Std_Coefficient", "Std_Median", "Std_Mean", "Std_MAP")], ci = ci, interpretation = interpretation, type = type, prefix = prefix, bayesian_diagnostic = FALSE)

  list(
    "text" = text,
    "text_full" = text_full
  )
}




#' @keywords internal
report_parameters.glm <- report_parameters.lm

#' @keywords internal
report_parameters.merMod <- report_parameters.lm

#' @keywords internal
report_parameters.stanreg <- report_parameters.lm







#' @keywords internal
.report_parameters_regression <- function(parameters, ci, interpretation, type = "d", prefix = "  - ", bayesian_diagnostic = FALSE) {
  text <- .report_parameters_combine(
    names = .report_parameters_names(parameters),
    direction = .report_parameters_direction(parameters),
    size = .report_parameters_size(parameters, interpretation = interpretation, type = type),
    significance = .report_parameters_significance(parameters),
    indices = .report_parameters_indices(parameters, ci = ci),
    bayesian_diagnostic = .report_parameters_bayesian_diagnostic(parameters, bayesian_diagnostic = bayesian_diagnostic)
  )
  paste0(paste0(prefix, text), collapse = "\n")
}
