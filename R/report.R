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



#' Test for objects of class \link{report}
#'
#' @param x an arbitrary R object.
#'
#' @export
is.report <- function(x) inherits(x, "report")




#' create objects of class \link{report}
#'
#' @param x an arbitrary R object.
#'
#' @export
as.report <- function(x) {
  class(x) <- c("report", class(x))
  return(x)
}






#' Report printing
#'
#' @param x An object of class \link{report}
#' @param full Show the full report.
#' @param ... Further arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @export
print.report <- function(x, full = FALSE, ...) {
  if (full == TRUE) {
    text <- x$text_full
  } else {
    text <- x$text
  }

  cat(text, sep = "\n")
  invisible(text)
}

#' @inherit print.report
#'
#' @export
to_text <- print.report


#' @inherit to_text
#'
#' @export
to_fulltext <- function(x, full = TRUE, ...) {
  to_text(x, full = full)
}

#' Report table display
#'
#' @param x An object of class \link{report}
#' @param full Show the full report.
#' @param digits Format the digits.
#' @param ... Further arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @export
to_table <- summary.report <- function(x, full = FALSE, digits = NULL, ...) {
  if (full == TRUE) {
    table <- x$table_full
  } else {
    table <- x$table
  }

  if (!is.null(digits)) {
    initial_order <- names(table)
    nums <- dplyr::select_if(table, is.numeric)
    nums <- format_value(nums, digits)
    fact <- dplyr::select_if(table, is.character)
    fact <- cbind(fact, dplyr::select_if(table, is.factor))
    table <- cbind(fact, nums)
    table <- table[initial_order]
  }

  return(table)
}

#' @inherit to_table
#' @export
to_fulltable <- as.data.frame.report <- function(x, full = TRUE, digits = NULL, ...) {
  table <- to_table(x, digits = digits, full = full)

  return(table)
}
