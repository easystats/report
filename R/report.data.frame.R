#' Dataframe Report
#'
#' Create a report of a dataframe.
#'
#' @param model A data.frame or a vector.
#' @param median Show \link{mean} and \link{sd} (default) or \link{median} and \link{mad}.
#' @param dispersion Show dispersion (\link{sd} or \link{mad}).
#' @param range Show range.
#' @param distribution Returns Kurtosis and Skewness in table.
#' @param n_characters Number of different character entries to show. Can be "all".
#' @param levels_percentage Show characters entries and factor levels by number (default) or percentage.
#' @param missing_percentage Show missings by number (default) or percentage.
#' @param ... Arguments passed to or from other methods.
#'
#'
#'
#' @examples
#' library(report)
#' x <- iris
#'
#' report(x)
#' report(x, median = TRUE, dispersion = TRUE, range = TRUE, missing_percentage = TRUE)
#' to_fulltext(report(x))
#' to_table(report(x))
#' to_fulltable(report(x))
#'
#'
#' @seealso report
#' @import dplyr
#'
#' @export
report.data.frame <- function(model, median = FALSE, dispersion = TRUE, range = TRUE, distribution = TRUE, levels_percentage = FALSE, n_characters = 3, missing_percentage = FALSE, ...) {

  # Table -------------------------------------------------------------------
  table_full <- data.frame()
  table <- data.frame()
  text_full <- ""
  text <- ""
  values <- list()

  for (col in names(model)) {
    r <- report(model[[col]], median = median, dispersion = dispersion, range = range, distribution = distribution, levels_percentage = levels_percentage, n_characters = n_characters, missing_percentage = missing_percentage)

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
report.grouped_df <- function(model, median = FALSE, dispersion = TRUE, range = TRUE, distribution = TRUE, levels_percentage = FALSE, n_characters = 3, missing_percentage = FALSE, ...) {
  groups <- group_vars(model)
  ungrouped_x <- ungroup(model)
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
    r <- report(data, median = median, dispersion = dispersion, range = range, distribution = distribution, levels_percentage = levels_percentage, n_characters = n_characters, missing_percentage = missing_percentage)

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

  as.report(out)
}













#' @rdname report.data.frame
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
    text <- paste0(n_char$Entry, ", ", parameters::format_value(n_char$percentage_Entry), "%")
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
  text_percentage_Missing <- paste0(parameters::format_value(table_full$percentage_Missing[1]), "% missing")
  if (missing_percentage == TRUE) {
    text_full <- paste0(text_full, "(", text_percentage_Missing, ").")
    table <- dplyr::select(table, -one_of("n_Missing"))
    if (table_full$n_Missing[1] > 0) {
      text <- paste0(text, " (", text_percentage_Missing, ").")
    }
  } else {
    text_full <- paste0(text_full, " (", text_n_Missing, ").")
    table <- dplyr::select(table, -one_of("percentage_Missing"))
    if (table_full$n_Missing[1] > 0) {
      text <- paste0(text, " (", text_n_Missing, ").")
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
#' @import dplyr
#'
#' @export
report.factor <- function(model, levels_percentage = FALSE, ...) {

  if(length(model[is.na(model)]) != 0){
    model <- factor(ifelse(is.na(model), "missing", as.character(model)), levels = c(levels(model), "missing"))
  }

  # Table -------------------------------------------------------------------
  table_full <- data.frame(Level = model) %>%
    dplyr::group_by_("Level") %>%
    dplyr::summarise_(
      "n_Obs" = "n()",
      "percentage_Obs" = "n() / length(model) * 100"
    )

  table_no_missing <- table_full[table_full$Level != "missing",]
  # Text --------------------------------------------------------------------
  if (nrow(table_full) > 1) {
    text_total_levels <- paste0(nrow(table_no_missing), " levels: ")
  } else {
    text_total_levels <- paste0(nrow(table_no_missing), " level: ")
  }

  text_levels <- paste0(table_full$Level)
  text_n_Obs <- paste0("n = ", table_full$n_Obs)
  text_percentage_Obs <- paste0(parameters::format_value(table_full$percentage_Obs), "%")


  text_full <- paste0(
    text_levels, " (",
    text_n_Obs, ", ",
    text_percentage_Obs, ")"
  )
  # Selection ---------------------------------------------------------------
  table <- table_full
  if (levels_percentage == TRUE) {
    text <- paste0(text_levels, " (", text_percentage_Obs, ")")
  } else {
    table <- dplyr::select(table, -dplyr::one_of("percentage_Obs"))
    text <- paste0(text_levels, " (", text_n_Obs, ")")
  }


  text <- paste0(text_total_levels, format_text_collapse(text, sep = "; "), ".")
  text_full <- paste0(text_total_levels, format_text_collapse(text_full, sep = "; "), ".")

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













#' @rdname report.data.frame
#' @examples
#' \dontrun{
#' x <- rnorm(1000)
#' report(x)
#' report(x, median = TRUE, missing_percentage = TRUE, distribution=TRUE)
#' to_fulltext(report(x))
#' to_table(report(x))
#' to_fulltable(report(x))
#' }
#' @seealso report
#' @import dplyr
#' @importFrom stats mad sd
#'
#' @export
report.numeric <- function(model, median = FALSE, dispersion = TRUE, range = TRUE, distribution = TRUE, missing_percentage = FALSE, ...) {
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
    n_Missing = sum(is.na(model)),
    Skewness = parameters::skewness(model),
    Kurtosis = parameters::kurtosis(model)
  )


  table_full$percentage_Missing <- table_full$n_Missing / table_full$n_Obs * 100


  # Text --------------------------------------------------------------------

  # Centrality
  text_mean <- paste0("Mean = ", parameters::format_value(table_full$Mean[1]))
  text_median <- paste0("Median = ", parameters::format_value(table_full$Median[1]))

  # Dispersion
  text_sd <- parameters::format_value(table_full$SD[1])
  text_mad <- parameters::format_value(table_full$MAD[1])

  # Range
  text_range <- paste0(" [", parameters::format_value(table_full$Min[1]), ", ", parameters::format_value(table_full$Max[1]), "]")

  # Missings
  if (missing_percentage == TRUE) {
    text_missing <- paste0(", ", parameters::format_value(table_full$percentage_Missing[1], 1), "% missing.")
  } else {
    text_missing <- paste0(", ", table_full$n_Missing[1], " missing.")
  }



  # Selection ---------------------------------------------------------------
  table <- table_full
  if (median == TRUE) {
    if (dispersion == TRUE) {
      text <- paste0(text_median, ", MAD = ", text_mad)
      table <- dplyr::select(table, -one_of("Mean", "SD"))
    } else {
      text <- text_median
      table <- dplyr::select(table, -one_of("Mean", "SD", "MAD"))
    }
  } else {
    if (dispersion == TRUE) {
      text <- paste0(text_mean, ", SD = ", text_sd)
      table <- dplyr::select(table, -one_of("Median", "MAD"))
    } else {
      text <- text_mean
      table <- dplyr::select(table, -one_of("Median", "MAD", "SD"))
    }
  }

  if (range == TRUE) {
    text <- paste0(text, text_range)
  } else {
    table <- dplyr::select(table, -one_of("Min", "Max"))
  }

  if (missing_percentage == TRUE) {
    table <- dplyr::select(table, -one_of("n_Missing"))
  } else {
    table <- dplyr::select(table, -one_of("percentage_Missing"))
  }

  # Distribution
  if(distribution == FALSE){
    vars <- c("Skewness", "Kurtosis")
    table <- dplyr::select(table, -one_of(vars[vars %in% names(table)]))
  }




  # Text
  text_full <- paste0(
    text_mean, ", SD = ", text_sd, ", ",
    text_median, ", MAD = ", text_mad, ", Range =",
    text_range, text_missing
  )

  if (table_full$n_Missing[1] > 0) {
    text <- paste0(text, text_missing)
  } else{
    text <- paste0(text, ".")
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
