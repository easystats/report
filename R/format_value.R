#' Value Formatting
#'
#' @param x Numeric value.
#' @param digits Number of significant digits.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @examples
#' format_value(1.20)
#' format_value(1.2)
#' format_value(1.2012313)
#' format_value(0.0045)
#' @export
format_value <- function(x, digits = 2) {
  return(trimws(format(round(x, digits), nsmall = digits)))
}
