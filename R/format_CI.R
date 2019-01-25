#' Confidence/Credible Interval (CI) Formatting
#'
#' @param CI_low Lower CI bound.
#' @param CI_high Upper CI bound.
#' @param CI CI level in percentage.
#' @param digits Number of significant digits.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @examples
#' format_CI(1.20, 3.57, CI = 90)
#' @export
format_CI <- function(CI_low, CI_high, CI = 95, digits = 2) {
  text <- paste0(CI, "% CI [", format_value(CI_low, digits = digits), ", ", format_value(CI_high, digits = digits), "]")
  return(text)
}
