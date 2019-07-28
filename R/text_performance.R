#' Performance textual reporting
#'
#' Convert performance table to text.
#'
#' @param model Object.
#' @param performance Performance table.
#' @param ... Arguments passed to or from other methods.
#'
#'
#' @seealso report
#'
#' @export
text_performance <- function(model, performance, ...) {
  UseMethod("text_performance")
}
