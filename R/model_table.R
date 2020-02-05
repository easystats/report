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
#' model <- t.test(Sepal.Length ~ Species, data=iris[1:100,])
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




# Utils -------------------------------------------------------------------


#' @keywords internal
.model_table_return_output <- function(table, table_full){
  class(table) <- c("report_table", class(table))
  class(table_full) <- c("report_table", class(table_full))
  out <- list(table = table, table_full = table_full)
  class(out) <- c("model_table", class(out))
  out
}