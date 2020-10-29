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
