#' Create Reports
#'
#' Create textual reports. See the documentation for your object's class:
#' \itemize{
#'  \item{\link[=report.data.frame]{Dataframes}}
#'  \item{\link[=report.htest]{Correlations and t-tests}}
#'  }
#'
#' @param x Object.
#' @param ... Arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @export
report <- function(x, ...) {
  UseMethod("report")
}



#' Test for objects of class \link{report}.
#'
#' @param x An arbitrary R object.
#'
#' @export
is.report <- function(x) inherits(x, "report")




#' create objects of class \link{report}.
#'
#' @param x An arbitrary R object.
#'
#' @export
as.report <- function(x) {
  class(x) <- c("report", class(x))
  return(x)
}






#' Report printing
#'
#' @param x Object of class \link{report}.
#' @param full Show the full report.
#' @param width Positive integer giving the target column for wrapping lines in the output.
#' @param ... Arguments passed to or from other methods.
#'
#' @export
print.report <- function(x, full = FALSE, width = NULL, ...) {
  if (full == TRUE) {
    text <- x$text_full
  } else {
    text <- x$text
  }

  if (!is.null(width)) {
    text <- format_text_wrap(text, width = width)
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
to_fulltext <- function(x, full = TRUE, width = NULL, ...) {
  to_text(x, full = full, width = width)
}

#' Report table display
#'
#' @param object Object of class \link{report}.
#' @param full Show the full report.
#' @param digits Number of digits.
#' @param ... Arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @export
to_table <- function(object, full = FALSE, digits = NULL, ...) {
  if (full == TRUE) {
    table <- object$table_full
  } else {
    table <- object$table
  }

  if (!is.null(digits) & ncol(dplyr::select_if(table, is.numeric)) > 0) {
    initial_order <- names(table)
    nums <- dplyr::select_if(table, is.numeric)
    nums <- sapply(nums, format_value_unless_integers, digits = digits)
    fact <- dplyr::select_if(table, is.character)
    fact <- cbind(fact, dplyr::select_if(table, is.factor))
    if (ncol(fact) == 0) {
      table <- nums
    } else {
      table <- cbind(fact, nums)
    }
    table <- table[initial_order]
    if (inherits(table, "character")) {
      table <- as.data.frame(t(table))
    }
  }

  return(table)
}

#' @export
summary.report <- to_table



#' Full report table display
#'
#' @param x Object of class \link{report}.
#' @param full Show the full report (default to TRUE).
#' @param digits Number of digits.
#' @param ... Arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#' @export
to_fulltable <- function(x, full = TRUE, digits = NULL, ...) {
  table <- to_table(x, digits = digits, full = full)

  return(table)
}

#' @rdname to_fulltable
#' @export
as.data.frame.report <- function(x, ...) {
  return(to_fulltable(x, ...))
}


#' Report values
#'
#' @param x Object of class \link{report}.
#' @param ... Arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @export
to_values <- function(x, ...) {
  if (!"values" %in% names(x)) {
    return(as.list(x$table_full))
  } else {
    return(x$values)
  }
}
#' @export
as.list.report <- to_values














#' Parameters table printing
#'
#' @param x Object of class \code{table_report}.
#' @param digits Number of digits.
#' @param ... Arguments passed to or from other methods.
#'
#' @export
print.report_table <- function(x, digits=2, ...){
  x <- mutate_if(x, is.numeric, format_value, digits=digits)
  x[is.na(x)] <- ""

  x %>%
    .colour_column_if("beta", condition=`>`, threshold=0, colour_if="green", colour_else="red") %>%
    .colour_column_if("Median", condition=`>`, threshold=0, colour_if="green", colour_else="red") %>%
    .colour_column_if("Mean", condition=`>`, threshold=0, colour_if="green", colour_else="red") %>%
    .colour_column_if("MAP", condition=`>`, threshold=0, colour_if="green", colour_else="red") %>%
    .colour_column_if("Std_beta", condition=`>`, threshold=0, colour_if="green", colour_else="red") %>%
    .colour_column_if("Std_Median", condition=`>`, threshold=0, colour_if="green", colour_else="red") %>%
    .colour_column_if("Std_Mean", condition=`>`, threshold=0, colour_if="green", colour_else="red") %>%
    .colour_column_if("Std_MAP", condition=`>`, threshold=0, colour_if="green", colour_else="red") %>%
    .colour_column_if("p", condition=`<`, threshold=0.05, colour_if="yellow", colour_else=NULL) %>%
    .colour_column_if("Pd", condition=`>`, threshold=95, colour_if="yellow", colour_else=NULL) %>%
    .colour_columns("Fit", colour = "cyan") %>%
    .display()
}
