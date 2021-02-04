#' Convenient dataframe manipulation functionalities
#'
#' Safe and intuitive functions to manipulate dataframes.
#'
#' @param data Dataframe.
#' @param pattern,replacement,starts_with,ends_with Character strings.
#' @param cols Vector of column names.
#' @param safe Do not throw error if for instance the variable to be renamed/removed doesn't exist.
#'
#' @return A modified data frame.
#'
#' @examples
#' library(report)
#'
#' # Rename columns
#' data_rename(iris, "Sepal.Length", "length")
#' # data_rename(iris, "FakeCol", "length", safe=FALSE)  # This fails
#' data_rename(iris, "FakeCol", "length") # This doesn't
#' data_rename(iris, c("Sepal.Length", "Sepal.Width"), c("length", "width"))
#'
#' # Find columns names by pattern
#' data_findcols(iris, starts_with = "Sepal")
#' data_findcols(iris, ends_with = "Width")
#' data_findcols(iris, pattern = "\\.")
#'
#' # Remove columns
#' data_remove(iris, "Sepal.Length")
#'
#' # Reorder columns
#' data_reorder(iris, c("Species", "Sepal.Length"))
#' data_reorder(iris, c("Species", "dupa"))
#'
#' # Add prefix / suffix
#' data_addprefix(iris, "NEW_")
#' data_addsuffix(iris, "_OLD")
#' @export
data_rename <- function(data, pattern, replacement, safe = TRUE) {
  if (length(pattern) != length(replacement)) {
    stop("The 'replacement' names must be of the same length than the variable names.")
  }

  for (i in 1:length(pattern)) {
    data <- .data_rename(data, pattern[i], replacement[i], safe)
  }
  data
}

#' @keywords internal
.data_rename <- function(data, pattern, replacement, safe = TRUE) {
  if (isFALSE(safe) & !pattern %in% names(data)) {
    stop(paste0("Variable '", pattern, "' is not in your dataframe :/"))
  }
  names(data) <- replace(names(data), names(data) == pattern, replacement)
  data
}



#' @rdname data_rename
#' @export
data_findcols <- function(data, pattern = NULL, starts_with = NULL, ends_with = NULL) {
  n <- names(data)
  if (!is.null(pattern)) {
    match <- c()
    for (i in c(pattern)) {
      match <- c(match, n[grepl(i, n)])
    }
  }
  if (!is.null(starts_with)) {
    match <- n[grepl(paste0(starts_with, ".*"), n)]
  }
  if (!is.null(ends_with)) {
    match <- n[grepl(paste0(".*", ends_with), n)]
  }
  match
}


#' @rdname data_rename
#' @importFrom utils modifyList
#' @export
data_remove <- function(data, pattern) {
  new <- data[!names(data) %in% pattern]
  attributes(new) <- utils::modifyList(attributes(data), attributes(new))
  class(new) <- class(data)
  new
}








#' @rdname data_rename
#' @export
data_reorder <- function(data, cols, safe = TRUE) {
  remaining_columns <- setdiff(colnames(data), cols)
  if (isTRUE(safe)) cols <- cols[cols %in% names(data)]
  data[, c(cols, remaining_columns)]
}







#' @rdname data_rename
#' @export
data_addprefix <- function(data, pattern) {
  names(data) <- paste0(pattern, names(data))
  data
}


#' @rdname data_rename
#' @export
data_addsuffix <- function(data, pattern) {
  names(data) <- paste0(names(data), pattern)
  data
}
