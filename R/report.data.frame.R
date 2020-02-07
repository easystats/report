#' Dataframe Report
#'
#' Create a report of a dataframe.
#'
#' @param model A data.frame or a vector.
#' @param median Show \link{mean} and \link{sd} (default) or \link{median} and \link{mad}.
#' @param centrality Show index of centrality (\link{mean} or \link{median}).
#' @param dispersion Show index of dispersion (\link{sd} or \link{mad}).
#' @param range Show range.
#' @param distribution Returns Kurtosis and Skewness in table.
#' @param n_entries Number of different character entries to show. Can be "all".
#' @param levels_percentage Show characters entries and factor levels by number (default) or percentage.
#' @param missing_percentage Show missings by number (default) or percentage.
#' @param ... Arguments passed to or from other methods.
#'
#'
#'
#' @examples
#' library(report)
#'
#' report(iris)
#' r <- report(iris, median = TRUE, dispersion = FALSE, distribution = TRUE, missing_percentage = TRUE)
#'
#' @seealso report
#'
#' @export
report.data.frame <- function(model, median = FALSE, centrality = TRUE, dispersion = TRUE, range = TRUE, distribution = FALSE, levels_percentage = FALSE, n_entries = 3, missing_percentage = FALSE, ...) {
  "broken."
}