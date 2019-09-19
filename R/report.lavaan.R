#' SEM / CFA lavaan Models Report
#'
#' Create a report of a lavaan model.
#'
#' @inheritParams report.lm
#' @inheritParams parameters::model_parameters.lavaan
#'
#' @examples
#' library(report)
#' library(lavaan)
#'
#' structure <- " visual  =~ x1 + x2 + x3
#'                textual =~ x4 + x5 + x6
#'                speed   =~ x7 + x8 + x9 "
#'
#' model <- lavaan::cfa(structure, data = HolzingerSwineford1939)
#' report(model)
#' @export
report.lavaan <- function(model, effsize = "funder2019", ci = 0.95, standardize = TRUE, performance_metrics = "all", ...) {

  # Sanity checks -----------------------------------------------------------
  # Multiple CIs
  if (length(c(ci)) > 1) {
    warning(paste0("report does not support multiple `ci` values yet. Using ci = ", ci[1]), ".")
    ci <- ci[1]
  }

  performance <- performance::model_performance(model, metrics = performance_metrics, ...)
  parameters <- parameters::model_parameters(model, ci = ci, standardize = standardize, ...)
  parameters$Link <- paste(parameters$To, parameters$Operator, parameters$From)

  table_full <- .add_performance_table(parameters, performance)
  table <- .add_performance_table(
    parameters[names(parameters) %in% c("Link", "Coefficient", "Median", "Mean", "MAP", "CI_low", "CI_high", "p", "pd", "ROPE_Percentage", "BF", "Std_Coefficient", "Std_Median", "Std_Mean", "Std_MAP", "Type")],
    performance[names(performance) %in% c("Chisq", "GFI", "AGFI", "NFI", "NNFI", "CFI", "RMSEA", "SRMR", 'RFI', 'PNFI', "IFI", "RNI", "AIC", "BIC", "BIC (adj.)")]
  )

}



