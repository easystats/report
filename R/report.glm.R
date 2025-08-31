#' @include report.lm.R
#' @export
report.glm <- report.lm

#' @export
report_effectsize.glm <- report_effectsize.lm

#' @export
report_table.glm <- report_table.lm

#' @export
report_statistics.glm <- report_statistics.lm

#' @export
report_parameters.glm <- report_parameters.lm

#' @export
report_intercept.glm <- report_intercept.lm

#' @export
report_model.glm <- report_model.lm

#' @export
report_performance.glm <- report_performance.lm

#' @export
report_info.glm <- function(x,
                           effectsize = NULL,
                           include_effectsize = FALSE,
                           parameters = NULL,
                           ...) {
  # Get the standard info from the lm method
  info_text <- report_info.lm(x, effectsize = effectsize, include_effectsize = include_effectsize, parameters = parameters, ...)
  
  # Add GLM-specific explainability guidance
  model_info <- insight::model_info(x)
  explainability_text <- ""
  
  if (model_info$is_binomial) {
    explainability_text <- " For easier interpretation, the odds ratio can be calculated by taking the exponent of the coefficient (e.g., exp(beta))."
  } else if (model_info$is_poisson) {
    explainability_text <- " For easier interpretation, the rate ratio can be calculated by taking the exponent of the coefficient (e.g., exp(beta))."
  } else if (!model_info$is_linear) {
    explainability_text <- " For easier interpretation, transformed coefficients can be calculated using the appropriate link function inverse (e.g., exp(beta) for log-link models)."
  }
  
  # Combine the existing info text with the new explainability text
  combined_text <- paste0(as.character(info_text), explainability_text)
  
  # Preserve the summary attribute from the original info_text
  summary_text <- summary(info_text)
  if (!is.null(explainability_text) && nzchar(explainability_text)) {
    summary_text <- paste0(as.character(summary_text), explainability_text)
  }
  
  as.report_info(combined_text, summary = summary_text)
}

#' @export
report_text.glm <- report_text.lm
