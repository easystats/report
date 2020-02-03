#' Table Summary
#'
#' Create a reportable table (no pun intended) for your model.
#'
#' @param model A statistical model.
#'
#' @examples
#' model <- lm(Sepal.Length ~ Petal.Width, data=iris)
#' model_table(model)
#' summary(model_table(model))
#'
#' @export
model_table <- function(model, ...){
  UseMethod("model_table")
}



# Methods -----------------------------------------------------------------


#' @export
summary.model_table <- function(object, ...){
  object$table
}



#' @export
print.model_table <- function(x, ...){
  print(x$table_full, ...)
}


#' @export
print.report_table <- function(x, ...){
  table <- insight::format_table(x)
  cat(table)
}




