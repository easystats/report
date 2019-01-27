#' Coerce to a Data Frame
#'
#' Functions to check if an object is a data frame, or coerce it if possible.
#'
#' @param x any R object.
#' @param ... additional arguments to be passed to or from methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @method as.data.frame density
#' @export
as.data.frame.density <- function(x, ...) {
  df <- data.frame(x = x$x, y = x$y)

  return(df)
}
