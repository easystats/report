#' Create Reports
#'
#' Create textual reports. See the documentation for your object's class:
#' \itemize{
#'  \item{\link[=report.numeric]{report.numeric}}
#'  }
#'
#' @param x an R object.
#' @param ... arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @export
report <- function(x, ...) {
  UseMethod("report")
}



#' Test for objects of class \link{report}.
#'
#' @param x an arbitrary R object.
#'
#' @export
is.report <- function(x) inherits(x, "report")




#' create objects of class \link{report}.
#'
#' @param x an arbitrary R object.
#'
#' @export
as.report <- function(x){
  class(x) <- c("report", class(x))
  return(x)
}


#' Print the results.
#'
#' @param x An object of class \link{report}
#' @param full Show the full report.
#' @param ... Further arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @export
print.report <- function(x, full=FALSE, ...) {

  if(full==TRUE){
    text <- x$text_full
  } else{
    text <- x$text
  }

  cat(text, sep = "\n")
  invisible(text)
}