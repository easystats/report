#' Citation formatting
#'
#' Convenience functions to manipulate and format citations. Only works with APA
#' formatted citations, for now.
#'
#' @param citation A character string of a citation.
#' @param authorsdate Only show authors and date (remove title, journal, etc.).
#' @param short If more than one authors, replace by `et al.`
#' @param intext Remove brackets around the date (so that it can be placed
#'   inside larger parentheses).
#'
#' @return A character string.
#'
#' @examples
#' library(report)
#'
#' citation <- "Makowski, D., Ben-Shachar, M. S., Patil, I., & Ludecke, D. (2020).
#' Methods and Algorithms for Correlation Analysis in R. Journal of Open Source
#' Software, 5(51), 2306."
#'
#' format_citation(citation, authorsdate = TRUE)
#' format_citation(citation, authorsdate = TRUE, short = TRUE)
#' format_citation(citation, authorsdate = TRUE, short = TRUE, intext = TRUE)
#'
#' cite_citation(citation)
#' clean_citation(citation())
#' @export
format_citation <- function(citation,
                            authorsdate = FALSE,
                            short = FALSE,
                            intext = FALSE) {
  if (isTRUE(authorsdate)) {
    citation <- trimws(gsub(")..*", ")", citation)) # Remove everything after first parenthesis (hopefully, the date)
    citation <- gsub("[A-Z]\\., ", "", citation) # Remove last first names
    citation <- gsub("[A-Z]\\. ", "", citation) # Remove remaining first names
    citation <- gsub(", \\(", " (", citation)
  }

  if (isTRUE(short)) {
    n_authors <- sapply(regmatches(citation, gregexpr(",", citation, fixed = TRUE)), length)
    for (i in 1:length(n_authors)) {
      if (n_authors[i] > 1 | grepl("&", citation[i])) {
        citation[i] <- trimws(gsub(",.*\\(", " et al. (", citation[i])) # Replace remaining authors by et al.
      }
    }
  }

  if (isTRUE(intext)) {
    citation <- trimws(gsub(").*", "", citation))
    citation <- trimws(gsub(" \\(", ", ", citation))
  }

  citation
}


#' @rdname format_citation
#' @export
cite_citation <- function(citation) {
  citation <- format_citation(citation, authorsdate = TRUE, short = TRUE, intext = TRUE)
  paste0("(", citation, ")")
}


#' @rdname format_citation
#' @export
clean_citation <- function(citation) {
  if ("citation" %in% class(citation)) {
    citation <- format(citation,
                       style = "text")
  }
  citation <- unlist(strsplit(citation, "\n"))
  citation <- paste(citation, collapse = "SPLIT")
  citation <- unlist(strsplit(citation, "SPLITSPLIT"))
  i <- 1
  while (grepl("To cite ", citation[i])) {
    i <- i + 1
  }
  citation <- gsub("  ", " ", trimws(gsub("SPLIT", "", citation[i]), which = "both"))
  as.character(citation)
}
