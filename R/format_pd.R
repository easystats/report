#' Probability of direction (pd) Formatting
#'
#' @param pd Lower CI bound.
#' @param digits Number of significant digits.
#'
#' @examples
#' format_pd(1.20)
#' @export
format_pd <- function(pd, digits = 2) {
  text <- paste0("pd = ", format_value(pd), "%")
  return(text)
}
