#' Confidence/Credible Interval (CI) Formatting
#'
#' @param CI_low Lower CI bound.
#' @param CI_high Upper CI bound.
#' @param ci CI level in percentage.
#' @param digits Number of significant digits.
#'
#'
#'
#' @examples
#' format_ci(1.20, 3.57, ci = 90)
#' @export
format_ci <- function(CI_low, CI_high, ci = 0.95, digits = 2) {
  text <- paste0(ci * 100, "% CI [", format_value(CI_low, digits = digits), ", ", format_value(CI_high, digits = digits), "]")
  return(text)
}
