#' Rename a Variable
#'
#' Rename a variable in a dataframe if applicable.
#'
#' @param x Dataframe.
#' @param pattern Variable to replace.
#' @param replacement New variable name.
#'
#' 
#'
#' @examples
#' rename_if_possible(iris, "Sepal.Length", "length")
#' @import stringr
#' @export
rename_if_possible <- function(x, pattern, replacement) {
  names(x) <- replace(names(x), names(x) == pattern, replacement)
  return(x)
}
