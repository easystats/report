#' Model Values
#'
#' @param model Statistical Model.
#' @param ... Arguments passed to or from other methods.
#'
#' @export
model_values <- function(model, ...) {
  UseMethod("model_values")
}



#' Model table
#'
#' @param model Statistical Model.
#' @param ... Arguments passed to or from other methods.
#'
#' @export
model_table <- function(model, ...) {
  UseMethod("model_table")
}



#' Model text
#'
#' @param model Statistical Model.
#' @param ... Arguments passed to or from other methods.
#'
#' @export
model_text <- function(model, ...) {
  UseMethod("model_text")
}