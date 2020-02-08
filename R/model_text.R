#' Text summary
#'
#' Create a reportable textual output for your model.
#'
#' @param model A statistical model.
#' @inheritParams model_table
#'
#' @examples
#' model <- t.test(Sepal.Length ~ Species, data=iris[1:100,])
#' model_text(model)
#' summary(model_text(model))
#'
#' @export
model_text <- function(model, ...){
  UseMethod("model_text")
}




# Methods -----------------------------------------------------------------


#' @export
summary.model_text <- function(object, ...){
  object$text
}


#' @export
as.character.model_text <- function(x, ...){
  x$text_full
}


#' @export
print.model_text <- function(x, width = NULL, ...){
  print(x$text_full, width = NULL, ...)
}


#' @export
print.report_text <- function(x, width = NULL, ...){
  text <- format_text(x, width = width, ...)

  cat(text, sep = "\n")
  invisible(text)
}


# Utils -------------------------------------------------------------------


#' @keywords internal
as.model_text <- function(text, text_full){
  class(text) <- c("report_text", class(text))
  class(text_full) <- c("report_text", class(text_full))
  out <- list(text = text, text_full = text_full)
  class(out) <- c("model_text", class(out))
  out
}
