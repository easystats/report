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
  object$text_short
}


#' @export
as.character.model_text <- function(x, ...){
  x$text_long
}


#' @export
print.model_text <- function(x, width = NULL, ...){
  print(x$text_long, width = NULL, ...)
}


#' @export
print.report_text <- function(x, width = NULL, ...){
  text <- format_text(x, width = width, ...)

  cat(text, sep = "\n")
  invisible(text)
}


# Utils -------------------------------------------------------------------


#' @keywords internal
as.model_text <- function(text_short, text_long){
  class(text_short) <- c("report_text", class(text_short))
  class(text_long) <- c("report_text", class(text_long))
  out <- list(text_short = text_short, text_long = text_long)
  class(out) <- c("model_text", class(out))
  out
}
