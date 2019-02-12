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
#' format_value(c(0.0045, 234))
#' @export
format_value <- function(x, digits = 2) {
  x <- ifelse(is.na(x), NA, trimws(format(round(x, digits), nsmall = digits)))
  return(x)
}




#' @inherit format_value
#' @export
format_value_unless_integers <- function(x, digits = 2) {
  if (!all(is.int(x))) {
    x <- format_value(x, digits = digits)
  }
  return(x)
}



#' Check if integer
#'
#' @param x Numeric value.
#'
#' @export
is.int <- function(x) {
  ifelse(x %% 1 == 0, TRUE, FALSE)
}
