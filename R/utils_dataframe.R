#' Safe data frame Modification
#'
#' Rename/remove a variable in a data frame if exists.
#'
#' @param x Data frame.
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
  x[!names(x) %in% pattern]
}




#' @rdname rename_if_possible
#' @export
reorder_if_possible <- function(x, cols) {
  remaining_columns <- setdiff(colnames(x), cols)
  x[, c(cols, remaining_columns)]
}


# returns the row-indices for grouped data frames
#' @keywords internal
.group_indices <- function(x) {
  # dplyr < 0.8.0 returns attribute "indices"
  grps <- attr(x, "groups", exact = TRUE)

  # dplyr < 0.8.0?
  if (is.null(grps)) {
    attr(x, "indices", exact = TRUE)
  } else {
    grps[[".rows"]]
  }
}



# returns the variables that were used for grouping data frames (dplyr::group_var())
#' @keywords internal
.group_vars <- function(x) {
  # dplyr < 0.8.0 returns attribute "indices"
  grps <- attr(x, "groups", exact = TRUE)

  # dplyr < 0.8.0?
  if (is.null(grps)) {
    ## TODO fix for dplyr < 0.8
    attr(x, "vars", exact = TRUE)
  } else {
    setdiff(colnames(grps), ".rows")
  }
}
