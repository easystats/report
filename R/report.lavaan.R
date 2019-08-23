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

  performance <- performance::model_performance(model, metrics = performance_metrics, ...)
  parameters <- parameters::model_parameters(model, ci = ci, standardize = standardize)

}



