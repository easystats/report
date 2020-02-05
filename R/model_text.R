#' Text summary
#'
#' Create a reportable textual output for your model.
#'
#' @param model A statistical model.
#'
#' @examples
#' model <- lm(Sepal.Length ~ Petal.Width, data=iris)
#' model_text(model)
#' summary(model_text(model))
#'
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
print.model_text <- function(x, ...){
  print(x$text_full, ...)
}


#' @export
print.report_text <- function(x, ...){
  cat(x, ...)
}


# Utils -------------------------------------------------------------------


#' @keywords internal
.model_text_return_output <- function(text, text_full){
  class(text) <- c("report_text", class(text))
  class(text_full) <- c("report_text", class(text_full))
  out <- list(text = text, text_full = text_full)
  class(out) <- c("model_text", class(out))
  out
}
