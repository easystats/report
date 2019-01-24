#' Character Vector Report
#'
#' Create a report of a character vector.
#'
#' @param x a character vector.
#' @param n_characters number of different character entries to show. Can be "all".
#' @param levels_percentage show characters entries by percentage (default) or number.
#' @param missing_percentage show missings by number (default) or percentage
#' @param ... arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @examples
#' x <- c("A", "B", "C", "A", "B", "B", "D", "E", "B", "D", "A")
#' report(x)
#' report(x, n_characters = 2, levels_percentage = FALSE, missing_percentage = TRUE)
#' to_fulltext(report(x))
#' to_table(report(x, n_characters = "all"))
#' to_fulltable(report(x))
#' @seealso report
#' @import dplyr
#'
#' @export
report.character <- function(x, n_characters = 3, levels_percentage = TRUE, missing_percentage = FALSE, ...) {
  n_char <- as.data.frame(sort(table(x), decreasing = TRUE))
  names(n_char) <- c("Entry", "n_Entry")
  n_char$perc_Entry <- n_char$n_Entry / length(x)

  if (n_characters == "all" | n_characters > nrow(n_char)) {
    n_characters <- nrow(n_char)
  }

  # Table -------------------------------------------------------------------

  table_full <- data.frame(
    n_Entries = nrow(n_char),
    n_Obs = length(x),
    n_Missing = sum(is.na(x))
  )
  table_full$perc_Missing <- table_full$n_Missing / table_full$n_Obs * 100


  if (levels_percentage == TRUE) {
    text <- paste0(n_char$Entry, ", ", format_value(n_char$perc_Entry), "%")
  } else {
    text <- paste0(n_char$Entry, ", n = ", n_char$n_Entry)
  }

  text <- text[1:n_characters]
  text <- paste0(text, collapse = "; ")
  table_full$Entries <- text
  table <- table_full


  if (nrow(n_char) > 1) {
    text <- paste0(nrow(n_char), " entries: ", text)
  } else {
    text <- paste0(nrow(n_char), " entry: ", text)
  }

  if (nrow(n_char) - n_characters == 1) {
    text <- paste0(text, " and ", nrow(n_char) - n_characters, " other")
  }
  if (nrow(n_char) - n_characters > 1) {
    text <- paste0(text, " and ", nrow(n_char) - n_characters, " others")
  }

  text_full <- text


  text_n_Missing <- paste0(table_full$n_Missing[1], " missing")
  text_perc_Missing <- paste0(format_value(table_full$perc_Missing[1]), "% missing")
  if (missing_percentage == TRUE) {
    text_full <- paste0(text_full, "(", text_perc_Missing, ")")
    table <- dplyr::select(table, -one_of("n_Missing"))
    if (table_full$n_Missing[1] > 0) {
      text <- paste0(text, " (", text_perc_Missing, ")")
    }
  } else {
    text_full <- paste0(text_full, " (", text_n_Missing, ")")
    table <- dplyr::select(table, -one_of("perc_Missing"))
    if (table_full$n_Missing[1] > 0) {
      text <- paste0(text, " (", text_n_Missing, ")")
    }
  }


  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full
  )

  return(as.report(out))
}
