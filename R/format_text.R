#' Convenient text formatting functionalities
#'
#' Convenience functions to manipulate and format text.
#'
#' @param text,text2 A character string.
#' @param width Positive integer giving the target column width for wrapping
#' lines in the output. Can be "auto", in which case it will select 90\% of the
#' default width.
#' @inheritParams data_rename
#' @param sep Separator.
#' @param last Last separator.
#' @param n The number of characters to find.
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
#' # Find last characters
#' text_lastchar(c("ABC", "DEF"), n = 2)
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
#'
#' # Paste with optional separator
#' text_paste(c("A", "", "B"), c("42", "42", "42"))
#' @export
format_text <- function(text, sep = ", ", last = " and ", width = NULL, ...) {
  text_wrap(text_concatenate(text, sep = sep, last = last), width = width)
}


#' @rdname format_text
#' @export
text_fullstop <- function(text) {
  text[!text_lastchar(text) %in% c(".", ":", ",", ";", "!", "?")] <- paste0(text[text_lastchar(text) != "."], ".")
  text
}


#' @rdname format_text
#' @export
text_lastchar <- function(text, n = 1) {
  sapply(text, function(xx) {
    substr(xx, (nchar(xx) - n + 1), nchar(xx))
  })
}


#' @rdname format_text
#' @importFrom utils head tail
#' @export
text_concatenate <- function(text, sep = ", ", last = " and ") {
  text <- text[text != ""]
  if (length(text) == 1) {
    text
  } else {
    s <- paste0(head(text, -1), collapse = sep)
    s <- paste0(c(s, tail(text, 1)), collapse = last)
    s
  }
}


#' @rdname format_text
#' @export
text_paste <- function(text, text2 = NULL, sep = ", ", ...) {
  if (!is.null(text2)) {
    paste0(text, ifelse(text == "" | text2 == "", "", sep), text2)
  }
}



#' @rdname format_text
#' @export
text_remove <- function(text, pattern = "", ...) {
  gsub(pattern, "", text, ...)
}


#' @rdname format_text
#' @export
text_wrap <- function(text, width = NULL, ...) {
  if (is.null(width)) {
    return(text)
  }

  text <- strsplit(text, "\n", perl = TRUE)
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
