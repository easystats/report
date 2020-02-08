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
  object$table_short
}


#' @export
as.data.frame.model_table <- function(x, ...){
  x$table_long
}


#' @export
print.model_table <- function(x, ...){
  print(x$table_long, ...)
}


#' @export
print.report_table <- function(x, ...){
  table <- insight::format_table(x)
  cat(table)
  invisible(table)
}




# Utils -------------------------------------------------------------------


#' @keywords internal
as.model_table <- function(table_short, table_long){
  class(table_short) <- c("report_table", class(table_short))
  class(table_long) <- c("report_table", class(table_long))
  out <- list(table_short = table_short, table_long = table_long)
  class(out) <- c("model_table", class(out))
  out
}