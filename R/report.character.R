#' @rdname report.data.frame
#' @export
report.character <- function(
  x,
  n_entries = 3,
  levels_percentage = "auto",
  missing_percentage = "auto",
  ...
) {
  report_table <- report_table(
    x,
    n_entries = n_entries,
    levels_percentage = levels_percentage,
    missing_percentage = missing_percentage,
    ...
  )

  report_text <- report_text(
    x,
    n_entries = n_entries,
    levels_percentage = levels_percentage,
    missing_percentage = missing_percentage,
    ...
  )

  as.report(report_text, table = report_table, ...)
}


# report_table ------------------------------------------------------------

#' @export
report_table.character <- function(
  x,
  n_entries = 3,
  levels_percentage = "auto",
  missing_percentage = "auto",
  ...
) {
  levels_percentage <- .report_dataframe_percentage(x, levels_percentage)
  missing_percentage <- .report_dataframe_percentage(x, missing_percentage)

  n_char <- as.data.frame(table(x))
  n_char <- n_char[order(n_char$Freq, decreasing = TRUE), ]
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
  summary_table <- table_full

  if (isTRUE(missing_percentage)) {
    summary_table <- datawizard::data_remove(summary_table, "n_Missing")
  } else {
    summary_table <- datawizard::data_remove(
      summary_table,
      "percentage_Missing"
    )
  }

  as.report_table(table_full, summary = summary_table, entries = n_char)
}


# report_parameters -------------------------------------------------------

#' @export
report_parameters.character <- function(
  x,
  table = NULL,
  n_entries = 3,
  levels_percentage = "auto",
  missing_percentage = "auto",
  ...
) {
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
    param_text <- paste0(
      entries$Entry,
      " (",
      insight::format_value(entries$percentage_Entry, as_percent = TRUE),
      ")"
    )
  } else {
    param_text <- paste0(entries$Entry, " (n = ", entries$n_Entry, ")")
  }

  n_entries_actual <- min(n_entries, length(param_text))
  as.report_parameters(param_text, summary = param_text[1:n_entries_actual], ...)
}


# report_text -------------------------------------------------------------

#' @export
report_text.character <- function(
  x,
  table = NULL,
  n_entries = 3,
  levels_percentage = "auto",
  missing_percentage = "auto",
  ...
) {
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

  report_text <- paste(summary(params), collapse = "; ")
  if (nrow(entries) > 1) {
    report_text <- paste0(
      name,
      ": ",
      nrow(entries),
      " entries, such as ",
      report_text
    )
  } else {
    report_text <- paste0(
      name,
      ": ",
      nrow(entries),
      " entry, such as ",
      report_text
    )
  }

  if (nrow(entries) - n_entries == 1) {
    report_text <- paste0(
      report_text,
      " and ",
      nrow(entries) - n_entries,
      " other"
    )
  }
  if (nrow(entries) - n_entries > 1) {
    report_text <- paste0(
      report_text,
      " and ",
      nrow(entries) - n_entries,
      " others"
    )
  }

  text_full <- report_text

  # Missing
  text_n_missing <- paste0(table$n_Missing[1], " missing")
  text_percentage_missing <- paste0(
    insight::format_value(table$percentage_Missing[1]),
    "% missing"
  )
  if (isTRUE(missing_percentage)) {
    text_full <- paste0(text_full, "(", text_percentage_missing, ")")
    if (table$n_Missing[1] > 0) {
      report_text <- paste0(report_text, " (", text_percentage_missing, ")")
    }
  } else {
    text_full <- paste0(text_full, " (", text_n_missing, ")")
    table <- datawizard::data_remove(table, "percentage_Missing")
    if (table$n_Missing[1] > 0) {
      report_text <- paste0(report_text, " (", text_n_missing, ")")
    }
  }

  as.report_text(text_full, summary = report_text)
}


# report_statistics -------------------------------------------------------

#' @export
report_statistics.character <- function(
  x,
  table = NULL,
  n_entries = 3,
  levels_percentage = "auto",
  missing_percentage = "auto",
  ...
) {
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
    stat_text <- paste0(
      entries$Entry,
      ", ",
      insight::format_value(entries$percentage_Entry, as_percent = TRUE),
      "%"
    )
  } else {
    stat_text <- paste0(entries$Entry, ", n = ", entries$n_Entry)
  }

  n_entries_actual <- min(n_entries, length(stat_text))
  as.report_statistics(
    paste(stat_text, collapse = "; "),
    summary = paste(stat_text[1:n_entries_actual], collapse = "; ")
  )
}
