#' Data frame Report
#'
#' Create a report of a data frame.
#'
#' @inheritParams report
#' @param centrality Character vector, indicating the index of centrality (either \code{"mean"} or \code{"median"}).
#' @param dispersion Show index of dispersion (\link{sd} if \code{centrality = "mean"}, or \link{mad} if \code{centrality = "median"}).
#' @param range Show range.
#' @param distribution Returns kurtosis and skewness in table.
#' @param n_entries Number of different character entries to show. Can be "all".
#' @param levels_percentage Show characters entries and factor levels by number (default) or percentage.
#' @param missing_percentage Show missing by number (default) or percentage.
#' @param digits Number of significant digits.
#'
#' @examples
#' library(report)
#'
#' r <- report(iris,
#'   centrality = "median", dispersion = FALSE,
#'   distribution = TRUE, missing_percentage = TRUE
#' )
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#'
#' if (require("dplyr")) {
#'   r <- iris %>%
#'     dplyr::group_by(Species) %>%
#'     report()
#'   r
#'   summary(r)
#'   as.data.frame(r)
#'   summary(as.data.frame(r))
#' }
#' @export
report.data.frame <- function(x, centrality = "mean", dispersion = TRUE, range = TRUE, distribution = FALSE, levels_percentage = FALSE, n_entries = 3, missing_percentage = FALSE, ...) {
  print("SOON.")
}
