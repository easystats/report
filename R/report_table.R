#' Report a descriptive table
#'
#' Creates tables to describe different objects (see list of supported objects in \code{\link{report}}).
#'
#' @inheritParams report
#' @param summary Add a summary as attribute (to be extracted via \code{summary()}).
#'
#' @return A \code{data.frame}.
#'
#' @examples
#' library(report)
#'
#' # Miscellaneous
#' r <- report_table(sessionInfo())
#' r
#' summary(r)
#'
#' # Data
#' # report_table(iris)
#'
#' # Tests
#' # report_table(t.test(mpg ~ am, data = mtcars))
#'
#' @export
report_table <- function(x, ...) {
  UseMethod("report_table")
}


# METHODS -----------------------------------------------------------------

#' @rdname report_table
#' @export
as.report_table <- function(x, summary=NULL, ...) {
  class(x) <- unique(c("report_table", class(x)))
  attributes(x) <- c(attributes(x), list(...))
  if(!is.null(summary)) {
    class(summary) <- unique(c("report_table", class(summary)))
    attr(x, "summary") <- summary
  }
  x
}


#' @export
summary.report_table <- function(object, ...) {
  attributes(object)$summary
}


#' @export
print.report_table <- function(x, ...) {
  cat(insight::format_table(x, ...))
}


# MISCELLANEOUS ------------------------------------------------------------



#' @export
report_table.sessionInfo <- function(x, ...) {
  pkgs <- x$otherPkgs
  citations <- c()
  versions <- c()
  names <- c()
  for (pkg_name in names(pkgs)) {
    citation <- format(citation(pkg_name))[[2]]
    citation <- unlist(strsplit(citation, "\n"))
    citation <- paste(citation, collapse = "SPLIT")
    citation <- unlist(strsplit(citation, "SPLITSPLIT"))

    i <- 1
    while (grepl("To cite ", citation[i])) {
      i <- i + 1
    }

    citation <- gsub("  ", " ", trimws(gsub("SPLIT", "", citation[i]), which = "both"))

    citations <- c(citations, citation)
    versions <- c(versions, as.character(packageVersion(pkg_name)))
    names <- c(names, pkg_name)
  }

  data <- data.frame(
    "Package" = names,
    "Version" = versions,
    "Reference" = citations,
    stringsAsFactors = FALSE
  )

  x <- data[order(data$Package), ]
  row.names(x) <- NULL
  as.report_table(x, summary=x[c("Package", "Version")])
}






