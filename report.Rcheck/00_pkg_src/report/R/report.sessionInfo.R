#' Report R environment (packages, system, etc.)
#'
#' @inheritParams report
#' @inheritParams as.report_parameters
#' @param session A [sessionInfo][utils::sessionInfo] object.
#' @param include_R Include R in the citations.
#'
#' @return
#'
#'  For `report_packages`, a data frame of class with information on package
#'  name, version and citation.
#'
#' @examples
#'
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
#' report_packages(include_R = FALSE)
#' cite_packages(prefix = "> ")
#' report_system()
#'
#' @return An object of class [report()].
#' @export
report.sessionInfo <- function(x, ...) {
  table <- report_table(x, ...)
  text <- report_text(x, table = table)

  as.report(text, table = table, ...)
}


# Aliases -----------------------------------------------------------------


#' @rdname report.sessionInfo
#' @export
report_packages <- function(session = NULL, include_R = TRUE, ...) {
  if (is.null(session)) session <- utils::sessionInfo()
  report_parameters(session, include_R = include_R, ...)
}


#' @rdname report.sessionInfo
#' @export
cite_packages <- function(session = NULL, include_R = TRUE, ...) {
  if (is.null(session)) session <- utils::sessionInfo()

  # Do not recompute table if passed
  if (!is.null(list(...)$table)) {
    x <- list(...)$table
  } else {
    x <- report_table(session, include_R = include_R)
  }

  x <- sort(x$Reference, na.last = TRUE) # Extract the references

  as.report_parameters(x, ...)
}


# report_system --------------------------------------------------------------


#' @rdname report.sessionInfo
#' @export
report_system <- function(session = NULL) {
  if (is.null(session)) {
    session <- utils::sessionInfo()
  }

  version <- paste0(session$R.version$major, ".", session$R.version$minor)
  year <- paste0(session$R.version$year, "-", session$R.version$month, "-", session$R.version$day)
  citation <- format_citation(clean_citation(utils::citation()), authorsdate = TRUE, intext = TRUE)

  text <- paste0(
    "Analyses were conducted using the R Statistical language (version ",
    version,
    "; ",
    citation,
    ") on ",
    session$running
  )

  short <- paste0(
    "The analysis was done using the R Statistical language (v",
    version,
    "; ",
    citation,
    ") on ",
    datawizard::text_remove(session$running, " \\(build.*")
  )

  as.report_text(text, summary = short)
}


# report_table ------------------------------------------------------------

#' @export
report_table.sessionInfo <- function(x, include_R = TRUE, ...) {
  pkgs <- x$otherPkgs

  if (isTRUE(include_R)) {
    citations <- clean_citation(utils::citation("base"))
    versions <- paste0(x$R.version$major, ".", x$R.version$minor)
    names <- "R"
  } else {
    citations <- NULL
    versions <- NULL
    names <- NULL
  }


  for (pkg_name in names(pkgs)) {
    citations <- c(citations, clean_citation(utils::citation(pkg_name)))
    versions <- c(versions, as.character(utils::packageVersion(pkg_name)))
    names <- c(names, pkg_name)
  }

  data <- data.frame(
    Package = names,
    Version = versions,
    Reference = citations,
    stringsAsFactors = FALSE
  )

  x <- data[order(data$Package), ]
  row.names(x) <- NULL
  as.report_table(x, summary = x[c("Package", "Version")])
}


# report_parameters -------------------------------------------------------

#' @export
report_parameters.sessionInfo <- function(x, table = NULL, include_R = TRUE, ...) {
  # Get table
  if (is.null(table)) {
    x <- report_table(x)
  } else {
    x <- table
  }

  if (isFALSE(include_R)) x <- x[x$Package != "R", ]

  # Generate text
  x$text <- paste0(
    x$Package,
    " (version ",
    x$Version,
    "; ",
    format_citation(x$Reference, authorsdate = TRUE, short = TRUE, intext = TRUE),
    ")"
  )

  x$summary <- paste0(x$Package, " (v", x$Version, ")")

  x <- x[order(x$Reference), ]


  params <- x$text
  names(params) <- x$Package
  short <- x$summary
  names(short) <- x$Package

  as.report_parameters(params, summary = short, ...)
}


# report_text -------------------------------------------------------------

#' @export
report_text.sessionInfo <- function(x, table = NULL, ...) {
  sys <- report_system(x)
  params <- report_parameters(x, table = table, include_R = FALSE)

  text <- paste0(
    sys,
    ", using the packages ",
    datawizard::text_concatenate(params),
    ".\n\nReferences\n----------\n",
    as.character(cite_packages(x, table = table, ...))
  )

  short <- paste0(
    summary(sys),
    ", using the packages ",
    datawizard::text_concatenate(summary(params)),
    "."
  )

  as.report_text(text, summary = short)
}
