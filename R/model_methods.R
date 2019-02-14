#' Model Values
#'
#' @param model Statistical Model.
#' @param ... Arguments passed to or from other methods.
#'
#' @export
model_values <- function(model, ...) {
  UseMethod("model_values")
}