#' Report the parameters of a model
#'
#' Creates a list containing a description of the parameters of R objects (see list of supported objects in \code{\link{report}}).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return A \code{vector}.
#'
#' @examples
#' library(report)
#'
#' # Miscellaneous
#' r <- report_parameters(sessionInfo())
#' r
#' summary(r)
#' @export
report_parameters <- function(x, table = NULL, prefix = "  - ", ...) {
  UseMethod("report_parameters")
}



# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_parameters <- function(x, summary = NULL, prefix = "  - ", ...) {
  class(x) <- unique(c("report_parameters", class(x)))
  attributes(x) <- c(attributes(x), list(...))
  attr(x, "prefix") <- prefix

  if (!is.null(summary)) {
    class(summary) <- unique(c("report_parameters", class(summary)))
    attr(summary, "prefix") <- prefix
    attr(x, "summary") <- summary
  }
  x
}

#' @export
as.character.report_parameters <- function(x, prefix = NULL, ...) {
  # Find prefix
  if (is.null(prefix)) prefix <- attributes(x)$prefix
  if (is.null(prefix)) prefix <- ""

  # Concatenate
  text <- paste0(prefix, x)
  text <- paste0(text, collapse = "\n")
  text
}

#' @export
summary.report_parameters <- function(object, ...) {
  attributes(object)$summary
}


#' @export
print.report_parameters <- function(x, ...) {
  cat(as.character(x, ...))
}

# MISCELLANEOUS ------------------------------------------------------------



#' @export
report_parameters.sessionInfo <- function(x, table = NULL, ...) {

  # Get table
  if (is.null(table)) {
    x <- report_table(x, ...)
  } else {
    x <- table
  }

  # Generate text
  x$text <- paste0(
    x$Package,
    " (version ",
    x$Version,
    "; ",
    format_citation(x$Reference, authorsdate = TRUE, short = TRUE, intext = TRUE),
    ")"
  )
  x$summary <- paste0(
    x$Package,
    " (v",
    x$Version,
    ")"
  )

  x <- x[order(x$Reference), ]

  as.report_parameters(x$text, summary = x$summary, ...)
}
