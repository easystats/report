#' @rdname format_text
#' @export
text_fullstop <- function(text) {
  text[!.text_lastchar(text) %in% c(".", ":", ",", ";", "!", "?")] <- paste0(text[.text_lastchar(text) != "."], ".")
  text
}

#' @keywords internal
.text_lastchar <- function(text, n = 1) {
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
