#' Convenient text formatting functionalities
#'
#' Convenience functions to manipulate and format text.
#'
#' @param text A character string.
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
#' @export
text_fullstop <- function(text) {
  text[!.text_lastchar(text) %in% c(".", ":", ",", ";", "!", "?")] <- paste0(text[.text_lastchar(text) != "."], ".")
  text
}


#' @keywords internal
.text_lastchar <- function(text, n=1){
  sapply(text, function(xx)
    substr(xx, (nchar(xx)-n+1), nchar(xx))
  )
}


#' @rdname text_fullstop
#' @importFrom utils head tail
#' @export
text_concatenate <- function(text, sep = ", ", last = " and ") {
  if (length(text) == 1) {
    text
  } else {
    s <- paste0(head(text, -1), collapse = sep)
    s <- paste0(c(s, tail(text, 1)), collapse = last)
    s
  }
}

#' @rdname text_fullstop
#' @export
text_remove <- function(text, pattern="", ...) {
  gsub(pattern, "", text, ...)
}