#' @rdname report.data.frame
#' @export
report.character <- function(x,
                             n_entries = 3,
                             levels_percentage = "auto",
                             missing_percentage = "auto",
                             ...) {
  table <- report_table(
    x,
    n_entries = n_entries,
    levels_percentage = levels_percentage,
    missing_percentage = missing_percentage,
    ...
  )

  text <- report_text(
    x,
    n_entries = n_entries,
    levels_percentage = levels_percentage,
    missing_percentage = missing_percentage,
    ...
  )

  as.report(text, table = table, ...)
}





# report_table ------------------------------------------------------------



#' @export
report_table.character <- function(x,
                                   n_entries = 3,
                                   levels_percentage = "auto",
                                   missing_percentage = "auto",
                                   ...) {
  levels_percentage <- .report_dataframe_percentage(x, levels_percentage)
  missing_percentage <- .report_dataframe_percentage(x, missing_percentage)

  n_char <- as.data.frame(sort(table(x), decreasing = TRUE))
  names(n_char) <- c("Entry", "n_Entry")
  n_char$percentage_Entry <- n_char$n_Entry / length(x)

  if (n_entries == "all" || n_entries > nrow(n_char)) {
    n_entries <- nrow(n_char)
  }


  table_full <- data.frame(
    n_Entries = nrow(n_char),
    n_Obs = length(x),
    n_Missing = sum(is.na(x))
  )
  table_full$percentage_Missing <- table_full$n_Missing / table_full$n_Obs * 100
  table <- table_full

  if (isTRUE(missing_percentage)) {
    table <- datawizard::data_remove(table, "n_Missing")
  } else {
    table <- datawizard::data_remove(table, "percentage_Missing")
  }

  as.report_table(table_full, summary = table, entries = n_char)
}



# report_parameters -------------------------------------------------------

#' @export
report_parameters.character <- function(x,
                                        table = NULL,
                                        n_entries = 3,
                                        levels_percentage = "auto",
                                        missing_percentage = "auto",
                                        ...) {
  levels_percentage <- .report_dataframe_percentage(x, levels_percentage)

  # Get table
  if (is.null(table)) {
    table <- report_table(
      x,
      n_entries = n_entries,
      levels_percentage = levels_percentage,
      missing_percentage = missing_percentage,
      ...
    )
  }
  entries <- attributes(table)$entries

  if (levels_percentage) {
    text <- paste0(entries$Entry, " (", insight::format_value(entries$percentage_Entry, as_percent = TRUE), ")")
  } else {
    text <- paste0(entries$Entry, " (n = ", entries$n_Entry, ")")
  }

  as.report_parameters(text, summary = text[1:n_entries], ...)
}



# report_text -------------------------------------------------------------

#' @export
report_text.character <- function(x,
                                  table = NULL,
                                  n_entries = 3,
                                  levels_percentage = "auto",
                                  missing_percentage = "auto",
                                  ...) {
  if (!is.null(list(...)$varname)) {
    name <- list(...)$varname
  } else if (is.null(names(x))) {
    name <- deparse(substitute(x))
  } else {
    name <- "Character variable"
  }

  if (is.null(table)) {
    table <- report_table(
      x,
      n_entries = n_entries,
      levels_percentage = levels_percentage,
      missing_percentage = missing_percentage,
      ...
    )
  }
  entries <- attributes(table)$entries
  params <- report_parameters(
    x,
    table = table,
    n_entries = n_entries,
    levels_percentage = levels_percentage,
    missing_percentage = missing_percentage,
    ...
  )

  text <- paste0(summary(params), collapse = "; ")
  if (nrow(entries) > 1) {
    text <- paste0(name, ": ", nrow(entries), " entries, such as ", text)
  } else {
    text <- paste0(name, ": ", nrow(entries), " entry, such as ", text)
  }

  if (nrow(entries) - n_entries == 1) {
    text <- paste0(text, " and ", nrow(entries) - n_entries, " other")
  }
  if (nrow(entries) - n_entries > 1) {
    text <- paste0(text, " and ", nrow(entries) - n_entries, " others")
  }

  text_full <- text

  # Missing
  text_n_Missing <- paste0(table$n_Missing[1], " missing")
  text_percentage_Missing <- paste0(insight::format_value(table$percentage_Missing[1]), "% missing")
  if (isTRUE(missing_percentage)) {
    text_full <- paste0(text_full, "(", text_percentage_Missing, ")")
    if (table$n_Missing[1] > 0) {
      text <- paste0(text, " (", text_percentage_Missing, ")")
    }
  } else {
    text_full <- paste0(text_full, " (", text_n_Missing, ")")
    table <- datawizard::data_remove(table, "percentage_Missing")
    if (table$n_Missing[1] > 0) {
      text <- paste0(text, " (", text_n_Missing, ")")
    }
  }

  as.report_text(text_full, summary = text)
}



# report_statistics -------------------------------------------------------


#' @export
report_statistics.character <- function(x,
                                        table = NULL,
                                        n_entries = 3,
                                        levels_percentage = "auto",
                                        missing_percentage = "auto",
                                        ...) {
  levels_percentage <- .report_dataframe_percentage(x, levels_percentage)

  if (is.null(table)) {
    table <- report_table(
      x,
      n_entries = n_entries,
      levels_percentage = levels_percentage,
      missing_percentage = missing_percentage,
      ...
    )
  }
  entries <- attributes(table)$entries

  if (levels_percentage) {
    text <- paste0(entries$Entry, ", ", insight::format_value(entries$percentage_Entry, as_percent = TRUE), "%")
  } else {
    text <- paste0(entries$Entry, ", n = ", entries$n_Entry)
  }

  as.report_statistics(paste0(text, collapse = "; "), summary = paste0(text[1:n_entries], collapse = "; "))
}
