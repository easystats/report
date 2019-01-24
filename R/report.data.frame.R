#' Dataframe Report
#'
#' Create a report of a dataframe.
#'
#' @param x a numeric vector.
#' @param median show \link{mean} and \link{sd} (default) or \link{median} and \link{mad}.
#' @param dispersion show dispersion (\link{sd} or \link{mad}).
#' @param range show range.
#' @param n_characters number of different character entries to show. Can be "all".
#' @param levels_percentage show characters entries and factor levels by percentage (default) or number.
#' @param missing_percentage show missings by number (default) or percentage
#' @param ... arguments passed to or from other methods.
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
report.data.frame <- function(x, median = FALSE, dispersion = TRUE, range = TRUE, levels_percentage = TRUE, n_characters = 3, missing_percentage = FALSE, ...) {

  # Table -------------------------------------------------------------------
  table_full <- data.frame()
  table <- data.frame()
  text_full <- ""
  text <- ""

  for(col in names(x)){
    r <- report(x[[col]], median = median, dispersion = dispersion, range = range, levels_percentage = levels_percentage, n_characters = n_characters, missing_percentage = missing_percentage)

    current_table <- r$table
    current_table$Variable <- col
    table <- merge(table, current_table, all=TRUE)

    current_table <- r$table_full
    current_table$Variable <- col
    table_full <- merge(table_full, current_table, all=TRUE)

    text_full <- paste0(text_full, "\n  - ", col, ": ", r$text_full)
    text <- paste0(text, "\n  - ", col, ": ", r$text)
  }
  if("Level" %in% names(table)){
    if("perc_Obs" %in% names(table)){
      table <- select_(table, "Variable", "Level", "n_Obs", "perc_Obs", "everything()")
      table_full <- select_(table_full, "Variable", "Level", "n_Obs", "perc_Obs", "everything()")
    } else{
      table <- select_(table, "Variable", "Level", "n_Obs", "everything()")
      table_full <- select_(table_full, "Variable", "Level", "n_Obs", "everything()")
    }
  } else{
    table <- select_(table, "Variable", "n_Obs", "everything()")
    table_full <- select_(table_full, "Variable", "n_Obs", "everything()")
  }


  text <- paste0("The data contains ", nrow(x), " observations of the following variables:", text)
  text_full <- paste0("The data contains ", nrow(x), " observations of the following variables:", text_full)

  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full
  )

  return(as.report(out))
}
