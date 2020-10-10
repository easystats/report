#' Report a textual description of an object
#'
#' Creates text containing a description of the parameters of R objects (see list of supported objects in \code{\link{report}}).
#'
#' @inheritParams report
#' @inheritParams report_table
#'
#' @return A \code{character} string.
#'
#' @examples
#' library(report)
#'
#' # Miscellaneous
#' r <- report_text(sessionInfo())
#' r
#' summary(r)
#' @export
report_text <- function(x, ...) {
  UseMethod("report_text")
}



# METHODS -----------------------------------------------------------------


#' @rdname report_table
#' @export
as.report_text <- function(x, summary=NULL, ...) {
  class(x) <- unique(c("report_text", class(x)))
  attributes(x) <- c(attributes(x), list(...))
  if(!is.null(summary)) {
    class(summary) <- unique(c("report_text", class(summary)))
    attr(x, "summary") <- summary
  }
  x
}


#' @export
summary.report_text <- function(object, ...) {
  attributes(object)$summary
}

#' @export
print.report_text <- function(x, ...) {
  x <- text_fullstop(x)  # Add full stop if missing
  cat(x)
}

# MISCELLANEOUS ------------------------------------------------------------



#' @export
report_text.sessionInfo <- function(x, ...) {
  sys <- report_system(x)
  pkg <- report_parameters(x)

  text <- paste0(sys,
                 ", using the packages ",
                 text_concatenate(pkg),
                 ".\n\nReferences\n----------\n",
                 as.character(cite_packages(x, ...)))

  short <- paste0(summary(sys),
                  ", using the packages ",
                  text_concatenate(summary(pkg)),
                  ".")

  as.report_text(text, summary=short)
}

