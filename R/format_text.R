#' Format text
#'
#'
#' @param x Character vector.
#' @param sep Separator.
#' @param last Last separator.
#' @param width Positive integer giving the target column for wrapping lines in the output. Can be "auto".
#'
#'
#' @examples
#' format_text(c("A", "B", "C"))
#'
#' x <- paste(rep("a very long string", 50), collapse = " ")
#' cat(format_text(x, width = 50))
#' @importFrom utils head tail
#'
#' @export
format_text <- function(x, sep = ", ", last = " and ", width = NULL) {
  .format_text_wrap(.format_text_collapse(x, sep = sep, last = last), width = width)
}



#' @importFrom utils head tail
#' @keywords internal
.format_text_collapse <- function(x, sep = ", ", last = " and ", width = NULL) {
  if (length(x) == 1) {
    return(x)
  } else {
    s <- paste0(head(x, -1), collapse = sep)
    s <- paste0(c(s, tail(x, 1)), collapse = last)
    return(s)
  }
}



#' @keywords internal
.format_text_wrap <- function(x, width = NULL) {
  if (is.null(width)) {
    return(x)
  }

  text <- strsplit(x, "\n", perl = TRUE)
  text <- unlist(text)

  if (width == "auto") {
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
  wrapped
}
