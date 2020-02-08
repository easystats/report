#' Safe Dataframe Modification
#'
#' Rename/remove a variable in a dataframe if exists.
#'
#' @param x Dataframe.
#' @param pattern Variable to replace.
#' @param replacement New variable name.
#' @param cols Order of columns.
#'
#'
#'
#' @examples
#' rename_if_possible(iris, "Sepal.Length", "length")
#' rename_if_possible(iris, "FakeCol", "length")
#' remove_if_possible(iris, "Sepal.Length")
#' reorder_if_possible(iris, c("Species", "Sepal.Length"))
#' @export
rename_if_possible <- function(x, pattern, replacement) {
  names(x) <- replace(names(x), names(x) == pattern, replacement)
  x
}



#' @rdname rename_if_possible
#' @export
remove_if_possible <- function(x, pattern) {
  x[!names(x) %in% c(pattern)]
}




#' @rdname rename_if_possible
#' @export
reorder_if_possible <- function(x, cols) {
  remaining_columns <- setdiff(colnames(x), cols)
  x[, c(cols, remaining_columns)]
}
