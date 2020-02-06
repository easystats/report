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
#' @examples
#' model <- t.test(Sepal.Length ~ Species, data=iris[1:100,])
#' r <- report(model)
#'
#' # Text
#' r
#' summary(r)
#'
#' # Tables
#' as.data.frame(r)
#' as.table(r)
#'
#' # List
#' as.list(r)
#' @export
report <- function(model, ...) {
  UseMethod("report")
}

#' Create and test objects of class \link{report}.
#'
#' @param x An arbitrary R object.
#' @param ... Args to be saved as attributes.
#'
#' @export
as.report <- function(x, ...) {
  class(x) <- c("report", class(x))
  attributes(x) <- c(attributes(x), list(...))
  x
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
to_text <- function(x, ...) {
  x$text
}

#' @export
print.report <- function(x, ...) {
  print(x$text, ...)
}


#' @export
summary.report <- function(object, ...) {
  summary(to_text(object, ...))
}







#' @rdname to_text
#' @export
to_table <- function(x, ...) {
  x$table
}


#' @export
as.data.frame.report <- to_table


#' @export
as.table.report <- function(x, ...) {
  summary(to_table(x, ...))
}

#' @rdname to_text
#' @export
to_values <- function(x, ...) {
  if (any(class(x) %in% c("parameters_model")) && "Parameter" %in% names(x)) {
    vals <- list()

    for (param in x$Parameter) {
      vals[[param]] <- as.list(x[x$Parameter == param, ])
    }
  } else if (any(class(x) %in% c("report")) && !"values" %in% names(x)) {
    vals <- as.list(x$table$table_full, ...)
  } else {
    as.list(x, ...)
  }
  vals
}

#' @export
as.list.report <- to_values














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

