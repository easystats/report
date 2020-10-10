#' Report R environment (packages, system, etc.)
#'
#' @inheritParams report
#' @inheritParams as.report_parameters
#' @param session A \link[=sessionInfo]{sessionInfo} object.
#'
#' @return \itemize{
#'   \item{For \code{report_packages}, a data frame of class with information on package name, version and citation.}
#' }
#'
#'
#' @examples
#' library(report)
#'
#' session <- sessionInfo()
#'
#' r <- report(session)
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#'
#' # Convenience functions
#' report_packages()
#' report_system()
#' cite_packages()
#' @importFrom utils packageVersion sessionInfo
#' @export
report.sessionInfo <- function(x, ...) {
  table <- report_table(x, ...)
  text <- report_text(x, table = table)

  as.report(text, table = table, ...)
}










# Aliases -----------------------------------------------------------------




#' @rdname report.sessionInfo
#' @export
report_packages <- function(session = NULL, ...) {
  if (is.null(session)) session <- sessionInfo()
  report_parameters(session, ...)
}



#' @rdname report.sessionInfo
#' @export
cite_packages <- function(session = NULL, ...) {
  if (is.null(session)) session <- sessionInfo()

  # Do not recompute table if passed
  if (!is.null(list(...)$table)) {
    x <- list(...)$table
  } else {
    x <- report_table(session)
  }

  x <- x$Reference[order(x$Reference)] # Extract the references

  as.report_parameters(x, ...)
}




# report_system --------------------------------------------------------------


#' @rdname report.sessionInfo
#' @export
report_system <- function(session = NULL) {
  if (is.null(session)) {
    session <- sessionInfo()
  }

  version <- paste0(session$R.version$major, ".", session$R.version$minor)
  year <- paste0(session$R.version$year, "-", session$R.version$month, "-", session$R.version$day)

  text <- paste0(
    "Analyses were conducted using the R Statistical language (version ",
    version,
    ") on ",
    session$running
  )

  short <- paste0(
    "The analysis was done using the R Statistical language (v",
    version,
    ") on ",
    text_remove(session$running, " \\(build.*")
  )

  as.report_text(text, summary = short)
}



# report_table ------------------------------------------------------------


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
  as.report_table(x, summary = x[c("Package", "Version")])
}




# report_parameters -------------------------------------------------------




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



# report_text -------------------------------------------------------------

#' @export
report_text.sessionInfo <- function(x, table = NULL, ...) {
  sys <- report_system(x)
  pkg <- report_parameters(x, table = table)

  text <- paste0(
    sys,
    ", using the packages ",
    text_concatenate(pkg),
    ".\n\nReferences\n----------\n",
    as.character(cite_packages(x, table = table, ...))
  )

  short <- paste0(
    summary(sys),
    ", using the packages ",
    text_concatenate(summary(pkg)),
    "."
  )

  as.report_text(text, summary = short)
}
