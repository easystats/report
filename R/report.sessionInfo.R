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
#' report_packages()
#' report_system()
#' cite_packages()
#'
#' session <- sessionInfo()
#' report(session)
#'
#'
#' @importFrom utils packageVersion sessionInfo
#' @export
report.sessionInfo <- function(x, ...) {
  report_packages(x, ...)
}



# TODO: Add report.sessionInfo with table and all









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

  x <- report_table(session)
  x <- x$Reference[order(x$Reference)]  # Extract the references

  as.report_parameters(x, ...)
}




# Components --------------------------------------------------------------


#' @rdname report.sessionInfo
#' @export
report_system <- function(session = NULL) {
  if (is.null(session)) {
    session <- sessionInfo()
  }

  text <- paste0("The analysis was done using ",
              session$R.version$version.string,
              " on ",
              session$running)

  short <- paste0("The analysis was done using ",
                 session$R.version$major,
                 session$R.version$minor,
                 " on ",
                 text_remove(session$running, " \\(build.*"))

  as.report_text(text, summary=short)
}

