#' @rdname report.data.frame
#' @examples
#' x <- c("A", "B", "C", "A", "B", "B", "D", "E", "B", "D", "A")
#' report(x)
#' model_table(x)
#' model_text(x)
#' summary(model_table(x))
#' summary(model_text(x))
#' @seealso report
#' @export
report.character <- function(model, n_entries = 3, levels_percentage = FALSE, missing_percentage = FALSE, ...) {
  n_char <- as.data.frame(sort(table(model), decreasing = TRUE))
  names(n_char) <- c("Entry", "n_Entry")
  n_char$percentage_Entry <- n_char$n_Entry / length(model)

  if (n_entries == "all" | n_entries > nrow(n_char)) {
    n_entries <- nrow(n_char)
  }

  # Table -------------------------------------------------------------------

  table_full <- data.frame(
    n_Entries = nrow(n_char),
    n_Obs = length(model),
    n_Missing = sum(is.na(model))
  )
  table_full$percentage_Missing <- table_full$n_Missing / table_full$n_Obs * 100


  if (levels_percentage == TRUE) {
    text <- paste0(n_char$Entry, ", ", insight::format_value(n_char$percentage_Entry * 100), "%")
  } else {
    text <- paste0(n_char$Entry, ", n = ", n_char$n_Entry)
  }

  text <- text[1:n_entries]
  text <- paste0(text, collapse = "; ")
  table_full$Entries <- text
  table <- table_full


  if (nrow(n_char) > 1) {
    text <- paste0(nrow(n_char), " entries: ", text)
  } else {
    text <- paste0(nrow(n_char), " entry: ", text)
  }

  if (nrow(n_char) - n_entries == 1) {
    text <- paste0(text, " and ", nrow(n_char) - n_entries, " other")
  }
  if (nrow(n_char) - n_entries > 1) {
    text <- paste0(text, " and ", nrow(n_char) - n_entries, " others")
  }

  text_full <- text

  text_n_Missing <- paste0(table_full$n_Missing[1], " missing")
  text_percentage_Missing <- paste0(insight::format_value(table_full$percentage_Missing[1]), "% missing")
  if (missing_percentage == TRUE) {
    text_full <- paste0(text_full, "(", text_percentage_Missing, ")")
    table <- remove_if_possible(table, "n_Missing")
    if (table_full$n_Missing[1] > 0) {
      text <- paste0(text, " (", text_percentage_Missing, ")")
    }
  } else {
    text_full <- paste0(text_full, " (", text_n_Missing, ")")
    table <- remove_if_possible(table, "percentage_Missing")
    if (table_full$n_Missing[1] > 0) {
      text <- paste0(text, " (", text_n_Missing, ")")
    }
  }


  # Output
  tables <- as.model_table(table, table_full)
  texts <- as.model_text(text, text_full)

  out <- list(
    texts = texts,
    tables = tables
  )

  as.report(out, ...)
}







#' @export
model_table.character <- function(model, n_entries = 3, levels_percentage = FALSE, missing_percentage = FALSE, ...) {
  r <- report(model, n_entries = n_entries, levels_percentage = levels_percentage, missing_percentage = missing_percentage, ...)
  r$tables
}


#' @export
model_text.character <- function(model, n_entries = 3, levels_percentage = FALSE, missing_percentage = FALSE, ...) {
  r <- report(model, n_entries = n_entries, levels_percentage = levels_percentage, missing_percentage = missing_percentage, ...)
  r$texts
}