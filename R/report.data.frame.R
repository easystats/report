#' Dataframe Report
#'
#' Create a report of a dataframe.
#'
#' @param model A data.frame or a vector.
#' @param median Show \link{mean} and \link{sd} (default) or \link{median} and \link{mad}.
#' @param centrality Show index of centrality (\link{mean} or \link{median}).
#' @param dispersion Show index of dispersion (\link{sd} or \link{mad}).
#' @param range Show range.
#' @param distribution Returns Kurtosis and Skewness in table.
#' @param n_entries Number of different character entries to show. Can be "all".
#' @param levels_percentage Show characters entries and factor levels by number (default) or percentage.
#' @param missing_percentage Show missings by number (default) or percentage.
#' @inheritParams report
#'
#'
#'
#' @examples
#' library(report)
#'
#' r <- report(iris, median = TRUE, dispersion = FALSE, distribution = TRUE, missing_percentage = TRUE)
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#'
#' library(dplyr)
#' r <- iris %>%
#'   dplyr::group_by(Species) %>%
#'   report()
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#' @seealso report
#'
#' @export
report.data.frame <- function(model, median = FALSE, centrality = TRUE, dispersion = TRUE, range = TRUE, distribution = FALSE, levels_percentage = FALSE, n_entries = 3, missing_percentage = FALSE, ...) {

  # Table -------------------------------------------------------------------
  table_full <- data.frame()
  table <- data.frame()
  text_full <- ""
  text <- ""

  for (i in 1:ncol(model)) {
    col <- names(model)[i]
    r <- report(model[[col]], median = median, centrality = centrality, dispersion = dispersion, range = range, distribution = distribution, levels_percentage = levels_percentage, n_entries = n_entries, missing_percentage = missing_percentage, ...)

    current_table <- table_short(r)
    current_table$Variable <- col
    current_table$.order <- i

    if (nrow(table) == 0) {
      table <- current_table
    } else {
      table <- merge(table, current_table, all = TRUE)
    }


    current_table <- table_long(r)
    current_table$Variable <- col
    current_table$.order <- i

    if (nrow(table_full) == 0) {
      table_full <- current_table
    } else {
      table_full <- merge(table_full, current_table, all = TRUE)
    }

    text_full <- paste0(text_full, "\n  - ", col, ": ", text_long(r))
    text <- paste0(text, "\n  - ", col, ": ", text_short(r))
  }

  if ("Level" %in% names(table)) {
    if ("percentage_Obs" %in% names(table)) {
      table <- reorder_if_possible(table, c("Variable", "Level", "n_Obs", "percentage_Obs"))
      table_full <- reorder_if_possible(table_full, c("Variable", "Level", "n_Obs", "percentage_Obs"))
    } else {
      table <- reorder_if_possible(table, c("Variable", "Level", "n_Obs"))
      table_full <- reorder_if_possible(table_full, c("Variable", "Level", "n_Obs"))
    }
  } else {
    table <- reorder_if_possible(table, c("Variable", "n_Obs"))
    table_full <- reorder_if_possible(table_full, c("Variable", "n_Obs"))
  }

  # Reorder cols
  table <- table[order(table$`.order`), ]
  table$`.order` <- NULL
  table_full <- table_full[order(table_full$`.order`), ]
  table_full$`.order` <- NULL

  # Concatenate text
  text <- paste0("The data contains ", nrow(model), " observations of the following variables:", text)
  text_full <- paste0("The data contains ", nrow(model), " observations of the following variables:", text_full)

  # Output
  tables <- as.model_table(table, table_full)
  texts <- as.model_text(text, text_full)

  out <- list(
    texts = texts,
    tables = tables
  )

  as.report(out, ...)
}





#' @importFrom dplyr group_vars ungroup
#' @export
report.grouped_df <- function(model, median = FALSE, centrality = TRUE, dispersion = TRUE, range = TRUE, distribution = FALSE, levels_percentage = FALSE, n_entries = 3, missing_percentage = FALSE, ...) {
  groups <- dplyr::group_vars(model)
  ungrouped_x <- dplyr::ungroup(model)
  xlist <- split(ungrouped_x, ungrouped_x[groups], sep = " - ")


  text <- paste0(
    "The data contains ", nrow(ungrouped_x),
    " observations, grouped by ",
    format_text(groups),
    ", of the following variables:"
  )
  text_full <- text

  table <- data.frame()
  table_full <- data.frame()

  for (group in names(xlist)) {
    data <- xlist[[group]]
    data <- remove_if_possible(data, groups)
    r <- report(data, median = median, centrality = centrality, dispersion = dispersion, range = range, distribution = distribution, levels_percentage = levels_percentage, n_entries = n_entries, missing_percentage = missing_percentage)

    # Get text
    current_text <- as.character(text_short(r))
    current_text_full <- as.character(text_long(r))

    # Remove first line about number of obs
    current_text <- paste0(strsplit(current_text, "\n")[[1]][-1], collapse = "\n")
    current_text_full <- paste0(strsplit(current_text_full, "\n")[[1]][-1], collapse = "\n")

    # Add group infi
    text <- paste0(text, "\n- ", group, " (n = ", nrow(data), "):\n", current_text)
    text_full <- paste0(text_full, "\n- ", group, " (n = ", nrow(data), "):\n", current_text_full)

    current_table <- table_short(r)
    current_table$Group <- group
    table <- rbind(table, current_table)
    current_table_full <- table_long(r)
    current_table_full$Group <- group
    table_full <- rbind(table_full, current_table_full)
  }

  table <- reorder_if_possible(table, "Group")
  table_full <- reorder_if_possible(table_full, "Group")

  # Output
  tables <- as.model_table(table, table_full)
  texts <- as.model_text(text, text_full)

  out <- list(
    texts = texts,
    tables = tables
  )

  as.report(out, ...)
}
