#' Collapse Character Vector
#'
#' @param x Character vector.
#' @param sep Separator.
#' @param last Last separator.
#'
#'
#'
#' @examples
#' format_text_collapse(c("A", "B", "C"))
#' @importFrom utils head tail
#'
#' @export
format_text_collapse <- function(x, sep = ", ", last = " and ") {
  if (length(x) == 1) {
    return(x)
  } else {
    s <- paste0(head(x, -1), collapse = sep)
    s <- paste0(c(s, tail(x, 1)), collapse = last)
    return(s)
  }
}


#' Autowrap String
#'
#' @param x Character vector.
#' @param width Positive integer giving the target column for wrapping lines in the output.
#'
#' @examples
#' x <- paste(rep("a very long string", 50), collapse = " ")
#' format_text_wrap(x, width = 50)
#' @importFrom stringr str_split coll
#' @export
format_text_wrap <- function(x, width = NULL) {
  text <- stringr::str_split(x, stringr::coll("\n"), simplify = FALSE)
  text <- unlist(text)

  if (is.null(width)) {
    width <- 0.9 * getOption("width")
  }

  wrapped <- ""
  for (s in text) {
    if (nchar(s) > width) {
      leading_spaces <- nchar(s) - nchar(trimws(s))
      s <- strwrap(s, width = width)
      s <- paste0(s, collapse = "\n")
      s <- paste0(paste0(rep(" ", leading_spaces), collapse = ""), s)
    }
    wrapped <- paste0(wrapped, s, "\n")
  }
  return(wrapped)
}
