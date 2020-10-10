#' Automatic report of R objects
#'
#' Create reports of different objects. See the documentation for your object's class:
#' \itemize{
#'  \item{\link[=report.sessionInfo]{R environment and system} (\code{sessionInfo})}
#' % \item{\link[=report.data.frame]{Dataframes and vectors}}
#' % \item{\link[=report.htest]{Correlations and t-tests} (\code{htest})}
#' % \item{\link[=report.aov]{ANOVAs}}
#' % \item{\link[=report.default]{Regression models} (\code{glm, lm, ...})}
#' % \item{\link[=report.lmerMod]{Mixed models} \code{(glmer, lmer, glmmTMB, ...)}}
#' % \item{\link[=report.stanreg]{Bayesian models} \code{(stanreg, brms...)}}
#' }
#'
#' @param x The R object that you want to report (see list of of supported objects above).
#' @param ... Arguments passed to or from other methods.
#'
#' @details
#'
#' \subsection{Organization}{
#'
#' \code{report_table} and \code{report_text} are the two distal representations
#' of a report, and are the two provided in \code{report()}. However, intermediate
#' steps are accessible (depending on the object) via specific functions (e.g.,
#' \code{report_parameters}).
#' }
#'
#' \subsection{Change output type}{
#'
#' The \code{report()} function generates a report-object that contain in itself
#' different representations (e.g., text, tables, plots). These different representations
#' can be accessed via several functions, such as:
#' \itemize{
#' \item \strong{\code{text_long()}}: Detailed text.
#' \item \strong{\code{text_short()}}: Minimal text giving the minimal information.
#' \item \strong{\code{table_long()}}: Comprehensive table including most available indices.
#' \item \strong{\code{table_short()}}: Minimal table.
#' }
#'
#' Note that for some report objects, some of these representations might be identical.
#' }
#'
#' @return A list-object of class \code{report}, which contains further list-objects
#' with a short and long description of the model summary, as well as a short
#' and long table of parameters and fit indices.
#'
#' @seealso Get more specific reports:
#' \itemize{
#'   \item \code{\link{report_table}}
#'   \item \code{\link{report_parameters}}
#'   \item \code{\link{report_text}}
#' }
#'
#'
#' @examples
#' library(report)
#'
#' model <- t.test(mpg ~ am, data = mtcars)
#' # r <- report(model)
#'
#' # Text
#' # r
#' # summary(r)
#'
#' # Tables
#' # as.data.frame(r)
#' # summary(as.data.frame(r)) # equivalent to as.table(r)
#'
#' # List
#' # as.list(r)
#' @export
report <- function(x, ...) {
  UseMethod("report")
}



#' @export
report.default <- function(x, ...) {
  stop("The input you provided is not supported yet by report :(")
}



#' Create or test objects of class \link{report}.
#'
#' Allows to create or test whether an object is of the \code{report} class.
#'
#' @param x An arbitrary R object.
#' @param ... Args to be saved as attributes.
#'
#' @return A report object or a \code{TRUE/FALSE} value.
#'
#' @export
as.report <- function(x, ...) {
  class(x) <- unique(c("report", class(x)))
  attributes(x) <- c(attributes(x), list(...))
  x
}



#' @rdname as.report
#' @export
is.report <- function(x) inherits(x, "report")




# Generic Methods --------------------------------------------------


#' @export
print.report <- function(x, width = NULL, ...) {
  print(x$texts, width = NULL, ...)
}


#' @export
as.character.report <- function(x, ...) {
  x$texts$text_long
}

#' @export
summary.report <- function(object, ...) {
  object$texts$text_short
}

#' @export
as.data.frame.report <- function(x, ...) {
  x$tables$table_long
}

#' @export
as.table.report <- function(x, ...) {
  x$tables$table_short
}


# Values ------------------------------------------------------------------


#' @export
as.list.report <- function(x, ...) {
  if (any(class(x) %in% c("parameters_model")) && "Parameter" %in% names(x)) {
    vals <- list()

    for (param in x$Parameter) {
      vals[[param]] <- as.list(x[x$Parameter == param, ])
    }
  } else if ("values" %in% names(x)) {
    vals <- x$values
  } else if ("report" %in% class(x)) {
    vals <- as.list(x$tables$table_long, ...)
  } else {
    as.list(x, ...)
  }
  vals
}
