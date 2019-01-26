#' Cite Loaded Packages
#'
#' Citation table of loaded packages (show_packages includes version and name, and cite_packages includes only the citation).
#'
#' @param session A \link[=sessionInfo]{sessionInfo} object.
#'
#' @examples
#' \dontrun{
#' show_packages(sessionInfo())
#' cite_packages(sessionInfo())
#' }
#'
#' @author \href{https://github.com/DominiqueMakowski}{Dominique Makowski}
#' @import stringr dplyr
#' @importFrom utils packageVersion
#' @export
show_packages <- function(session) {
  pkgs <- session$otherPkgs
  citations <- c()
  versions <- c()
  names <- c()
  for (pkg_name in names(pkgs)) {
    pkg <- pkgs[[pkg_name]]

    citation <- format(citation(pkg_name))[[2]] %>%
      stringr::str_split("\n") %>%
      purrr::flatten() %>%
      paste(collapse = "SPLIT") %>%
      stringr::str_split("SPLITSPLIT")

    i <- 1
    while (stringr::str_detect(citation[[1]][i], "To cite ")) {
      i <- i + 1
    }

    citation <- citation[[1]][i] %>%
      stringr::str_remove_all("SPLIT") %>%
      stringr::str_trim() %>%
      stringr::str_squish()

    citations <- c(citations, citation)
    versions <- c(versions, as.character(packageVersion(pkg_name)))
    names <- c(names, pkg_name)
  }
  data <- data.frame("Package" = names,
                    "Version" = versions,
                    "References" = citations) %>%
    arrange_("Package")
  return(data)
}


#' @inherit show_packages
#' @export
cite_packages <- function(session) {
  data <- show_packages(session)
  data <- select(data, -one_of("Package", "Version")) %>%
    arrange_("References")
  return(data)
}