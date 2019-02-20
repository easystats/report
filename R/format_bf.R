#' Bayes Factor Formatting
#'
#' @param bf Bayes Factor.
#' @param digits Number of significant digits.
#'
#' @examples
#' format_bf(1.20)
#' format_bf(c(1.20, 1557, 1, 8888))
#' @export
format_bf <- function(bf, digits = 2) {
  bf <- c(bf)
  text <- ifelse(bf > 999, "BF > 999", paste0("BF = ", format_value(bf, digits=digits)))

  return(text)
}
