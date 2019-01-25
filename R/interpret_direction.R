#' Direction interpretation
#'
#' @param x Numeric value.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @examples
#' interpret_direction(.02)
#' interpret_direction(c(.5, -.02))
#' #
#' @export
interpret_direction <- function(x) {
  return(ifelse(x > 0, "positive", "negative"))
}
