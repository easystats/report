#' Convenient text formatting functionalities
#'
#' Convenience functions to manipulate and format text.
#'
#' @param text A character string.
#' @param width Positive integer giving the target column width for wrapping
#' lines in the output. Can be "auto", in which case it will select 90\% of the
#' default width.
#' @inheritParams data_rename
#' @param sep Separator.
#' @param last Last separator.
#' @param ... Other arguments to be passed to or from other functions.
#'
#' @return A character string.
#'
#' @examples
#' library(report)
#'
#' # Add full stop if missing
#' text_fullstop(c("something", "something else."))
#'
#' # Smart concatenation
#' text_concatenate(c("First", "Second", "Last"))
#'
#' # Remove parts of string
#' text_remove(c("one!", "two", "three!"), "!")
#'
#' # Wrap text
#' long_text <- paste(rep("abc ", 100), collapse = "")
#' cat(text_wrap(long_text, width = 50))
#' @export
format_text <- function(text, sep = ", ", last = " and ", width = NULL, ...) {
  text_wrap(text_concatenate(text, sep=sep, last=last), width = width)
}
