#' Cite Loaded Packages
#'
#' Citation table of loaded packages (\link{show_packages} includes version and name, and \link{cite_packages} includes only the citation).
#'
#' @param session A \link[=sessionInfo]{sessionInfo} object.
#'
#' @examples
#' show_packages(sessionInfo())
#' cite_packages(sessionInfo())
#' @importFrom utils packageVersion
#' @export
show_packages <- function(session) {
  pkgs <- session$otherPkgs
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
    "References" = citations,
    stringsAsFactors = FALSE
  )

  x <- data[order(data$Package), ]
  row.names(x) <- NULL
  class(x) <- c("report_packages", class(x))
  x
}





#' @rdname show_packages
#' @export
cite_packages <- function(session) {
  data <- show_packages(session)
  data$Package <- NULL
  data$Version <- NULL

  x <- as.data.frame(data[order(data$References), ])
  row.names(x) <- NULL
  class(x) <- c("report_packages", class(x))
  x
}





#' @export
report.sessionInfo <- function(model, ...){
  show_packages(model)
}




#' @export
print.report_packages <- function(x, ...){
  cat(insight::format_table(x, ...))
}