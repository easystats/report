#' Character Vector Report
#'
#' Create a report of a character vector.
#'
#' @param model Character vector.
#' @param n_characters Number of different character entries to show. Can be "all".
#' @param levels_percentage Show characters entries by number (default) or percentage.
#' @param missing_percentage Show missings by number (default) or percentage.
#' @param ... Arguments passed to or from other methods.
#'
#' 
#'
#' @examples
#' x <- c("A", "B", "C", "A", "B", "B", "D", "E", "B", "D", "A")
#' report(x)
#' report(x, n_characters = 2, levels_percentage = TRUE, missing_percentage = TRUE)
#' to_fulltext(report(x))
#' to_table(report(x, n_characters = "all"))
#' to_fulltable(report(x))
#' @seealso report
#' @import dplyr
#'
#' @export
report.character <- function(model, n_characters = 3, levels_percentage = FALSE, missing_percentage = FALSE, ...) {
  n_char <- as.data.frame(sort(table(model), decreasing = TRUE))
  names(n_char) <- c("Entry", "n_Entry")
  n_char$percentage_Entry <- n_char$n_Entry / length(model)

  if (n_characters == "all" | n_characters > nrow(n_char)) {
    n_characters <- nrow(n_char)
  }

  # Table -------------------------------------------------------------------

  table_full <- data.frame(
    n_Entries = nrow(n_char),
    n_Obs = length(model),
    n_Missing = sum(is.na(model))
  )
  table_full$percentage_Missing <- table_full$n_Missing / table_full$n_Obs * 100


  if (levels_percentage == TRUE) {
    text <- paste0(n_char$Entry, ", ", format_value(n_char$percentage_Entry), "%")
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
  text_percentage_Missing <- paste0(format_value(table_full$percentage_Missing[1]), "% missing")
  if (missing_percentage == TRUE) {
    text_full <- paste0(text_full, "(", text_percentage_Missing, ")")
    table <- dplyr::select(table, -one_of("n_Missing"))
    if (table_full$n_Missing[1] > 0) {
      text <- paste0(text, " (", text_percentage_Missing, ")")
    }
  } else {
    text_full <- paste0(text_full, " (", text_n_Missing, ")")
    table <- dplyr::select(table, -one_of("percentage_Missing"))
    if (table_full$n_Missing[1] > 0) {
      text <- paste0(text, " (", text_n_Missing, ")")
    }
  }


  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full,
    values = as.list(table_full)
  )

  return(as.report(out))
}
