#' Cite Loaded Packages
#'
#' Citation table of loaded packages (\link{show_packages} includes version and name, and \link{cite_packages} includes only the citation).
#'
#' @param session A \link[=sessionInfo]{sessionInfo} object.
#'
#' @examples
#' show_packages(sessionInfo())
#' cite_packages(sessionInfo())
#' @import stringr
#' @import dplyr
#' @importFrom utils packageVersion
#' @export
show_packages <- function(session) {
  pkgs <- session$otherPkgs
  citations <- c()
  versions <- c()
  names <- c()
  for (pkg_name in names(pkgs)) {
    citation <- format(citation(pkg_name))[[2]] %>%
      strsplit("\n") %>%
      unlist() %>%
      paste(collapse = "SPLIT") %>%
      strsplit("SPLITSPLIT") %>%
      unlist()

    i <- 1
    while (stringr::str_detect(citation[i], "To cite ")) {
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
    "References" = citations
  ) %>%
    arrange_("Package")
  return(data)
}

#' @rdname show_packages
#' @export
cite_packages <- function(session) {
  data <- show_packages(session)
  data <- select(data, -one_of("Package", "Version")) %>%
    arrange_("References")
  return(data)
}
