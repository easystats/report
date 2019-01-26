#' Dataframe Report
#'
#' Create a report of a dataframe.
#'
#' @param x Numeric vector.
#' @param median Show \link{mean} and \link{sd} (default) or \link{median} and \link{mad}.
#' @param dispersion Show dispersion (\link{sd} or \link{mad}).
#' @param range Show range.
#' @param n_characters Number of different character entries to show. Can be "all".
#' @param levels_percentage Show characters entries and factor levels by number (default) or percentage.
#' @param missing_percentage Show missings by number (default) or percentage.
#' @param ... Arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @examples
#' x <- iris
#' report(x)
#' report(x, median = TRUE, dispersion = TRUE, range = TRUE, missing_percentage = TRUE)
#' to_fulltext(report(x))
#' to_table(report(x))
#' to_fulltable(report(x))
#' @seealso report
#' @import dplyr
#'
#' @export
report.data.frame <- function(x, median = FALSE, dispersion = TRUE, range = TRUE, levels_percentage = FALSE, n_characters = 3, missing_percentage = FALSE, ...) {

  # Table -------------------------------------------------------------------
  table_full <- data.frame()
  table <- data.frame()
  text_full <- ""
  text <- ""
  values <- list()

  for (col in names(x)) {
    r <- report(x[[col]], median = median, dispersion = dispersion, range = range, levels_percentage = levels_percentage, n_characters = n_characters, missing_percentage = missing_percentage)

    current_table <- r$table
    current_table$Variable <- col
    r$values$table <- current_table
    table <- merge(table, current_table, all = TRUE)

    current_table <- r$table_full
    current_table$Variable <- col
    r$values$table_full <- current_table
    table_full <- merge(table_full, current_table, all = TRUE)

    text_full <- paste0(text_full, "\n  - ", col, ": ", r$text_full)
    text <- paste0(text, "\n  - ", col, ": ", r$text)

    r$values$text <- r$text
    r$values$text_full <- r$text_full

    values[[col]] <- r$values
  }
  if ("Level" %in% names(table)) {
    if ("percentage_Obs" %in% names(table)) {
      table <- select_(table, "Variable", "Level", "n_Obs", "percentage_Obs", "everything()")
      table_full <- select_(table_full, "Variable", "Level", "n_Obs", "percentage_Obs", "everything()")
    } else {
      table <- select_(table, "Variable", "Level", "n_Obs", "everything()")
      table_full <- select_(table_full, "Variable", "Level", "n_Obs", "everything()")
    }
  } else {
    table <- select_(table, "Variable", "n_Obs", "everything()")
    table_full <- select_(table_full, "Variable", "n_Obs", "everything()")
  }

  text <- paste0("The data contains ", nrow(x), " observations of the following variables:", text)
  text_full <- paste0("The data contains ", nrow(x), " observations of the following variables:", text_full)

  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full,
    values = values
  )

  return(as.report(out))
}





#' @inheritParams report.data.frame
#' @import dplyr
#' @export
report.grouped_df <- function(x, median = FALSE, dispersion = TRUE, range = TRUE, levels_percentage = FALSE, n_characters = 3, missing_percentage = FALSE, ...) {
  groups <- group_vars(x)
  ungrouped_x <- ungroup(x)
  xlist <- split(ungrouped_x, ungrouped_x[groups], sep = " - ")


  text <- paste0(
    "The data contains ", nrow(ungrouped_x),
    " observations, grouped by ",
    format_text_collapse(groups),
    ", of the following variables:"
  )
  text_full <- text

  table <- data.frame()
  table_full <- data.frame()

  values <- list()
  for (group in names(xlist)) {
    data <- xlist[[group]]
    data <- dplyr::select(data, -dplyr::one_of(groups))
    r <- report(data, median = median, dispersion = dispersion, range = range, levels_percentage = levels_percentage, n_characters = n_characters, missing_percentage = missing_percentage)

    current_text <- ""
    current_text_full <- ""
    for (col in names(r$values)) {
      current_text <- paste0(current_text, "\n  - ", col, ": ", r$values[[col]]$text)
      current_text_full <- paste0(current_text_full, "\n  - ", col, ": ", r$values[[col]]$text_full)
    }

    text <- paste0(text, "\n- ", group, " (n = ", nrow(data), "):", current_text)
    text_full <- paste0(text_full, "\n- ", group, " (n = ", nrow(data), "):", current_text_full)

    current_table <- r$table
    current_table$Group <- group
    table <- rbind(table, current_table)
    current_table_full <- r$table_full
    current_table_full$Group <- group
    table_full <- rbind(table_full, current_table_full)


    values[[group]] <- r$values
  }

  table <- dplyr::select_(table, "Group", "everything()")
  table_full <- dplyr::select_(table_full, "Group", "everything()")

  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full,
    values = values
  )

  return(as.report(out))
}
