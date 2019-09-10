#' Create Reports
#'
#' Create textual reports. See the documentation for your object's class:
#' \itemize{
#'  \item{\link[=report.data.frame]{Dataframes and vectors}}
#'  \item{\link[=report.htest]{Correlations and t-tests (htest)}}
#'  \item{\link[=report.aov]{ANOVAs}}
#'  \item{\link[=report.lm]{(General) Linear models (glm and lm)}}
#'  \item{\link[=report.lmerMod]{Mixed models (glmer and lmer)}}
#'  \item{\link[=report.stanreg]{Bayesian models (stanreg and brms)}}
#'  }
#'
#' @param model Object.
#' @param ... Arguments passed to or from other methods.
#'
#'
#'
#' @export
report <- function(model, ...) {
  UseMethod("report")
}

#' Create and test objects of class \link{report}.
#'
#' @param model An arbitrary R object.
#' @param ... Args to be saved as attributes.
#'
#' @export
as.report <- function(model, ...) {
  class(model) <- c("report", class(model))
  attributes(model) <- c(attributes(model), list(...))
  model
}


#' @rdname as.report
#' @export
is.report <- function(model) inherits(model, "report")



#' Report printing
#'
#' @param x Object of class \link{report}.
#' @param full Show the full report.
#' @param width Positive integer giving the target column for wrapping lines in the output.
#' @param ... Arguments passed to or from other methods.
#'
#' @export
to_text <- function(x, full = FALSE, width = NULL, ...) {
  if (full == TRUE) {
    text <- format_text(x$text_full, width = width)
  } else {
    text <- format_text(x$text, width = width)
  }

  cat(text, sep = "\n")
  invisible(text)
}

#' @export
print.report <- to_text

#' @rdname to_text
#' @export
to_fulltext <- function(x, full = TRUE, width = NULL, ...) {
  to_text(x, full = full, width = width)
}







#' @rdname to_text
#' @export
to_table <- function(x, full = FALSE, ...) {
  if (full == TRUE) {
    table <- x$table_full
  } else {
    table <- x$table
  }

  class(table) <- c("report_table", class(table))
  attributes(table) <- c(attributes(table), attributes(x)[!names(attributes(x)) %in% names(attributes(table))])
  table
}

#' @export
print.report_table <- function(x, ...) {
  table <- insight::format_table(parameters::parameters_table(x))
  cat(table)
}



#' @export
summary.report <- function(object, full = FALSE, ...) {
  to_table(object, full = full, ...)
}



#' @rdname to_text
#' @export
to_fulltable <- function(x, full = TRUE, ...) {
  to_table(x, full = full)
}

#' @export
as.data.frame.report <- function(x, ...) {
  to_fulltable(x, ...)
}


#' @rdname to_text
#' @export
to_values <- function(x, ...) {
  if (!"values" %in% names(x)) {
    as.list(x$table_full)
  } else {
    x$values
  }
}
#' @export
as.list.report <- to_values




#' @rdname to_text
#' @export
to_values <- function(x, ...) {
  if (any(class(x) %in% c("parameters_model")) && "Parameter" %in% names(x)) {
    vals <- list()

    for (param in x$Parameter) {
      vals[[param]] <- as.list(x[x$Parameter == param, ])
    }
  } else if (any(class(x) %in% c("report")) && !"values" %in% names(x)) {
    vals <- as.list(x$table_full)
  } else if ("values" %in% names(x)) {
    vals <- x$values
  } else {
    stop("Impossible to transform that to values!")
  }
  vals
}









# #' Parameters table printing
# #'
# #' @param x Object of class \code{table_report}.
# #' @param digits Number of digits.
# #' @param ... Arguments passed to or from other methods.
# #'
# #' @export
# print.report_table <- function(x, digits = 2, ...) {
#   dig <- attr(x, "digits", exact = TRUE)
#   if (missing(digits) && !is.null(dig)) {
#     digits <- as.numeric(dig)
#   }
#
#   x <- x %>%
#     .colour_column_if("beta", condition = `>`, threshold = 0, colour_if = "green", colour_else = "red", digits = digits) %>%
#     .colour_column_if("Difference", condition = `>`, threshold = 0, colour_if = "green", colour_else = "red", digits = digits) %>%
#     .colour_column_if("Median", condition = `>`, threshold = 0, colour_if = "green", colour_else = "red", digits = digits) %>%
#     .colour_column_if("Mean", condition = `>`, threshold = 0, colour_if = "green", colour_else = "red", digits = digits) %>%
#     .colour_column_if("MAP", condition = `>`, threshold = 0, colour_if = "green", colour_else = "red", digits = digits) %>%
#     .colour_column_if("Std_beta", condition = `>`, threshold = 0, colour_if = "green", colour_else = "red", digits = digits) %>%
#     .colour_column_if("Std_Median", condition = `>`, threshold = 0, colour_if = "green", colour_else = "red", digits = digits) %>%
#     .colour_column_if("Std_Mean", condition = `>`, threshold = 0, colour_if = "green", colour_else = "red", digits = digits) %>%
#     .colour_column_if("Std_MAP", condition = `>`, threshold = 0, colour_if = "green", colour_else = "red", digits = digits) %>%
#     .colour_column_if("p", condition = `<`, threshold = 0.05, colour_if = "yellow", colour_else = NULL, digits = digits) %>%
#     .colour_column_if("pd", condition = `>`, threshold = 95, colour_if = "yellow", colour_else = NULL, digits = digits) %>%
#     .colour_column_if("ROPE_Percentage", condition = `<`, threshold = 1, colour_if = "yellow", colour_else = NULL, digits = digits) %>%
#     .colour_column_if("Fit", condition = `>`, threshold = 0, colour_if = "cyan", colour_else = "cyan", digits = digits) %>%
#     dplyr::mutate_if(is.numeric, format_value_unless_integers, digits = digits)
#
#   x[is.na(x)] <- ""
#
#   if (!is.null(x[["p"]])) {
#     fill <- .bold(sprintf("%*s", digits + 2, " "))
#     x[["p"]][x[["p"]] == ""] <- fill
#   }
#
#   .display(x)
# }





#' Model Values
#'
#' Return values contained in report.
#'
#' @param model Statistical Model.
#' @param ... Arguments passed to or from other methods.
#'
#' @export
# model_values <- function(model, ...) {
#   UseMethod("model_values")
# }
