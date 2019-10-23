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
#' @param ... Arguments passed to or from other methods.
#'
#'
#'
#' @examples
#' library(report)
#'
#' report(iris)
#' r <- report(iris, median = TRUE, dispersion = FALSE, distribution = TRUE, missing_percentage = TRUE)
#' to_fulltext(r)
#' to_table(r)
#' to_fulltable(r)
#' @seealso report
#'
#' @export
report.data.frame <- function(model, median = FALSE, centrality = TRUE, dispersion = TRUE, range = TRUE, distribution = FALSE, levels_percentage = FALSE, n_entries = 3, missing_percentage = FALSE, ...) {

  # Table -------------------------------------------------------------------
  table_full <- data.frame()
  table <- data.frame()
  text_full <- ""
  text <- ""
  values <- list()

  for (i in 1:ncol(model)) {
    col <- names(model)[i]
    r <- report(model[[col]], median = median, centrality = centrality, dispersion = dispersion, range = range, distribution = distribution, levels_percentage = levels_percentage, n_entries = n_entries, missing_percentage = missing_percentage)

    current_table <- r$table
    current_table$Variable <- col
    current_table$.order <- i
    r$values$table <- current_table
    if(nrow(table) == 0){
      table <- current_table
    } else{
      table <- merge(table, current_table, all = TRUE)
    }


    current_table <- r$table_full
    current_table$Variable <- col
    current_table$.order <- i
    r$values$table_full <- current_table
    if(nrow(table_full) == 0){
      table_full <- current_table
    } else{
      table_full <- merge(table_full, current_table, all = TRUE)
    }

    text_full <- paste0(text_full, "\n  - ", col, ": ", r$text_full)
    text <- paste0(text, "\n  - ", col, ": ", r$text)

    r$values$text <- r$text
    r$values$text_full <- r$text_full

    values[[col]] <- r$values
  }
  if ("Level" %in% names(table)) {
    if ("percentage_Obs" %in% names(table)) {
      table <- .order_columns(table, c("Variable", "Level", "n_Obs", "percentage_Obs"))
      table_full <- .order_columns(table_full, c("Variable", "Level", "n_Obs", "percentage_Obs"))
    } else {
      table <- .order_columns(table, c("Variable", "Level", "n_Obs"))
      table_full <- .order_columns(table_full, c("Variable", "Level", "n_Obs"))
    }
  } else {
    table <- .order_columns(table, c("Variable", "n_Obs"))
    table_full <- .order_columns(table_full, c("Variable", "n_Obs"))
  }

  # Reorder cols
  table <- table[order(table$`.order`), ]
  table$`.order` <- NULL
  table_full <- table_full[order(table_full$`.order`), ]
  table_full$`.order` <- NULL

  # Concatenate text
  text <- paste0("The data contains ", nrow(model), " observations of the following variables:", text)
  text_full <- paste0("The data contains ", nrow(model), " observations of the following variables:", text_full)

  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full,
    values = values
  )

  as.report(out)
}





#' @import dplyr
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

  values <- list()
  for (group in names(xlist)) {
    data <- xlist[[group]]
    data <- .remove_columns(data, groups)
    r <- report(data, median = median, centrality = centrality, dispersion = dispersion, range = range, distribution = distribution, levels_percentage = levels_percentage, n_entries = n_entries, missing_percentage = missing_percentage)

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

  table <- .order_columns(table, "Group")
  table_full <- .order_columns(table_full, "Group")

  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full,
    values = values
  )

  as.report(out)
}













#' @rdname report.data.frame
#' @examples
#' x <- c("A", "B", "C", "A", "B", "B", "D", "E", "B", "D", "A")
#' report(x)
#' report(x, n_entries = 2, levels_percentage = TRUE, missing_percentage = TRUE)
#' to_fulltext(report(x))
#' to_table(report(x, n_entries = "all"))
#' to_fulltable(report(x))
#' @seealso report
#'
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
    table <- .remove_columns(table, "n_Missing")
    if (table_full$n_Missing[1] > 0) {
      text <- paste0(text, " (", text_percentage_Missing, ")")
    }
  } else {
    text_full <- paste0(text_full, " (", text_n_Missing, ")")
    table <- .remove_columns(table, "percentage_Missing")
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

  as.report(out)
}























#' @rdname report.data.frame
#' @examples
#' x <- factor(rep(c("A", "B", "C"), 10))
#' report(x)
#' report(x, levels_percentage = TRUE, missing_percentage = TRUE)
#' to_fulltext(report(x))
#' to_table(report(x))
#' to_fulltable(report(x))
#' @seealso report
#'
#' @export
report.factor <- function(model, levels_percentage = FALSE, ...) {
  model <- as.factor(model)

  if (length(model[is.na(model)]) != 0) {
    model <- factor(ifelse(is.na(model), "missing", as.character(model)), levels = c(levels(model), "missing"))
  }

  # Table -------------------------------------------------------------------
  table_full <- data.frame(Level = model) %>%
    dplyr::group_by_("Level") %>%
    dplyr::summarise_(
      "n_Obs" = "n()",
      "percentage_Obs" = "n() / length(model) * 100"
    )

  table_no_missing <- table_full[table_full$Level != "missing", ]
  # Text --------------------------------------------------------------------
  if (nrow(table_full) > 1) {
    text_total_levels <- paste0(nrow(table_no_missing), " levels: ")
  } else {
    text_total_levels <- paste0(nrow(table_no_missing), " level: ")
  }

  text_levels <- paste0(table_full$Level)
  text_n_Obs <- paste0("n = ", table_full$n_Obs)
  text_percentage_Obs <- paste0(insight::format_value(table_full$percentage_Obs), "%")


  text_full <- paste0(
    text_levels, " (",
    text_n_Obs, ", ",
    text_percentage_Obs, ")"
  )
  # Selection ---------------------------------------------------------------
  table <- table_full
  if (levels_percentage == TRUE) {
    text <- paste0(text_levels, ", ", text_percentage_Obs)
  } else {
    table <- .remove_columns(table, "percentage_Obs")
    text <- paste0(text_levels, ", ", text_n_Obs)
  }


  text <- paste0(text_total_levels, format_text(text, sep = "; "))
  text_full <- paste0(text_total_levels, format_text(text_full, sep = "; "))

  values <- list()
  for (level in table_full$Level) {
    values[[level]] <- as.list(table_full[table_full$Level == level, ])
  }


  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full,
    values = values
  )

  as.report(out)
}


#' @export
report.logical <- report.factor










#' @rdname report.data.frame
#' @examples
#' \dontrun{
#' x <- rnorm(1000)
#' report(x)
#' report(x, median = TRUE, missing_percentage = TRUE, distribution = TRUE)
#' to_fulltext(report(x))
#' to_table(report(x))
#' to_fulltable(report(x))
#' }
#' @seealso report
#' @importFrom stats mad sd
#'
#' @export
report.numeric <- function(model, median = FALSE, centrality = TRUE, dispersion = TRUE, range = TRUE, distribution = FALSE, missing_percentage = FALSE, ...) {
  if (length(unique(model)) == 2) {
    if (is.null(names(model))) {
      name <- deparse(substitute(model))
    } else {
      name <- names(model)
    }
    warning(paste0("Variable `", name, "` contains only two different values. Consider converting it to a factor."))
  }



  # Table -------------------------------------------------------------------
  table_full <- data.frame(
    Mean = mean(model, na.rm = TRUE),
    SD = sd(model, na.rm = TRUE),
    Median = median(model),
    MAD = mad(model, na.rm = TRUE),
    Min = min(model, na.rm = TRUE),
    Max = max(model, na.rm = TRUE),
    n_Obs = length(model),
    Skewness = parameters::skewness(model),
    Kurtosis = parameters::kurtosis(model),
    n_Missing = sum(is.na(model))
  )


  table_full$percentage_Missing <- table_full$n_Missing / table_full$n_Obs * 100


  # Text --------------------------------------------------------------------

  # Centrality
  text_mean <- paste0("Mean = ", insight::format_value(table_full$Mean[1]))
  text_median <- paste0("Median = ", insight::format_value(table_full$Median[1]))

  # Dispersion
  text_sd <- insight::format_value(table_full$SD[1])
  text_mad <- insight::format_value(table_full$MAD[1])

  # Range
  text_range <- paste0("[", insight::format_value(table_full$Min[1], protect_integers = TRUE), ", ", insight::format_value(table_full$Max[1], protect_integers = TRUE), "]")

  # Distribution
  text_distribution <- paste0("Skewness = ",
                              insight::format_value(table_full$Skewness[1]),
                              ", Kurtosis = ",
                              insight::format_value(table_full$Kurtosis[1]))

  # Missings
  if(!is.null(missing_percentage)){
    if (missing_percentage == TRUE) {
      text_missing <- paste0(", ", insight::format_value(table_full$percentage_Missing[1], protect_integers = TRUE), "% missing")
    } else {
      text_missing <- paste0(", ", table_full$n_Missing[1], " missing")
    }
  } else{
    text_missing <- ""
  }




  # Selection ---------------------------------------------------------------
  table <- table_full

  # Centrality and dispersion
  if(centrality == TRUE){
    if (median == TRUE) {
      if (dispersion == TRUE) {
        text <- paste0(text_median, ", MAD = ", text_mad)
        table <- .remove_columns(table, c("Mean", "SD"))
      } else {
        text <- text_median
        table <- .remove_columns(table, c("Mean", "SD", "MAD"))
      }
    } else {
      if (dispersion == TRUE) {
        text <- paste0(text_mean, ", SD = ", text_sd)
        table <- .remove_columns(table, c("Median", "MAD"))
      } else {
        text <- text_mean
        table <- .remove_columns(table, c("Median", "MAD", "SD"))
      }
    }
  } else{
    if (median == TRUE) {
      if (dispersion == TRUE) {
        text <- paste0("MAD = ", text_mad)
        table <- .remove_columns(table, c("Mean", "Median", "SD"))
      } else {
        text <- ""
        table <- .remove_columns(table, c("Mean", "Median", "SD", "MAD"))
      }
    } else {
      if (dispersion == TRUE) {
        text <- paste0("SD = ", text_sd)
        table <- .remove_columns(table, c("Mean", "Median", "MAD"))
      } else {
        text <- ""
        table <- .remove_columns(table, c("Mean", "Median", "MAD", "SD"))
      }
    }
  }

  # Range
  if (range == TRUE) {
    text <- paste0(text, ", range = ", text_range)
  } else {
    table <- .remove_columns(table, c("Min", "Max"))
  }

  # Distribution
  if (distribution == TRUE) {
    text <- paste0(text, ", ", text_distribution)
  } else {
    table <- .remove_columns(table, c("Skewness", "Kurtosis"))
  }


  # Missing
  if(!is.null(missing_percentage)){
    if (missing_percentage == TRUE) {
      table <- .remove_columns(table, "n_Missing")
      table_full <- .remove_columns(table_full, "n_Missing")
    } else {
      table <- .remove_columns(table, "percentage_Missing")
      table_full <- .remove_columns(table_full, "percentage_Missing")
    }
  } else{
    table <- .remove_columns(table, c("percentage_Missing", "n_Missing"))
    table_full <- .remove_columns(table_full, c("percentage_Missing", "n_Missing"))
  }



  # Text
  text_full <- paste0(
    text_mean, ", SD = ", text_sd, ", ",
    text_median, ", MAD = ", text_mad, ", range: ",
    text_range, text_distribution, text_missing
  )

  if (!is.null(missing_percentage)) {
    text <- paste0(text, text_missing)
  }


  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full,
    values = as.list(table_full)
  )

  as.report(out)
}



#' @keywords internal
.order_columns <- function(df, cols) {
  remaining_columns <- setdiff(colnames(df), cols)
  df[, c(cols, remaining_columns)]
}


#' @keywords internal
.remove_columns <- function(df, cols) {
  df[!(colnames(df) %in% cols)]
}