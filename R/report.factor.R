#' @rdname report.data.frame
#' @export
report.factor <- function(x, levels_percentage = "auto", ...) {
  if (!is.factor(x)) {
    x <- as.factor(x)
  }
  table <- report_table(x, levels_percentage = levels_percentage, ...)
  text <- report_text(x, levels_percentage = levels_percentage, ...)

  as.report(text, table = table, ...)
}

#' @export
report.logical <- report.factor

#' @export
report.Date <- report.factor


# report_table ------------------------------------------------------------


#' @export
report_table.factor <- function(x, levels_percentage = "auto", ...) {
  if (!is.factor(x)) {
    x <- as.factor(x)
  }
  levels_percentage <- .report_dataframe_percentage(x, levels_percentage)

  if (length(x[is.na(x)]) != 0) {
    x <- factor(
      ifelse(is.na(x), "missing", as.character(x)),
      levels = c(levels(x), "missing")
    )
  }

  # Table
  table_full <- as.data.frame(table(x))
  names(table_full) <- c("Level", "n_Obs")
  table_full$percentage_Obs <- table_full$n_Obs / length(x) * 100

  # Shorten
  table <- table_full
  if (!levels_percentage) {
    table <- datawizard::data_remove(table, "percentage_Obs")
  }

  as.report_table(table_full, summary = table)
}

#' @export
report_table.logical <- report_table.factor

#' @export
report_table.Date <- report_table.factor


# report_parameters -------------------------------------------------------


#' @export
report_parameters.factor <- function(x, table = NULL,
                                     levels_percentage = "auto", ...) {
  if (!is.factor(x)) {
    x <- as.factor(x)
  }
  # Get table
  if (is.null(table)) {
    table <- report_table(x, levels_percentage = levels_percentage, ...)
  }

  text_levels <- paste0(table$Level)
  text_n_obs <- paste0("n = ", table$n_Obs)
  text_percentage_obs <- paste0(
    insight::format_value(table$percentage_Obs), "%"
  )

  text_full <- paste0(
    text_levels, " (",
    text_n_obs, ", ",
    text_percentage_obs, ")"
  )

  if (isTRUE(levels_percentage)) {
    text <- paste0(
      text_levels, " (",
      text_percentage_obs, ")"
    )
  } else {
    text <- paste0(
      text_levels, " (",
      text_n_obs, ")"
    )
  }

  as.report_parameters(text_full, summary = text, ...)
}

#' @export
report_parameters.logical <- report_parameters.factor

#' @export
report_parameters.Date <- report_parameters.factor


# report_text -------------------------------------------------------------

#' @export
report_text.factor <- function(x, table = NULL, levels_percentage = "auto",
                               ...) {
  if (!is.factor(x)) {
    x <- as.factor(x)
  }
  if (!is.null(list(...)$varname)) {
    name <- list(...)$varname
  } else if (is.null(names(x))) {
    name <- deparse(substitute(x))
  } else {
    name <- "Factor"
  }

  if (is.null(table)) {
    table <- report_table(x, levels_percentage = levels_percentage, ...)
  }

  table_no_missing <- table[table$Level != "missing", ]
  params <- report_parameters(
    x, table = table, levels_percentage = levels_percentage, ...
  )

  if (nrow(table) > 1) {
    text_total_levels <- paste0(
      name, ": ", nrow(table_no_missing), " levels, namely "
    )
  } else {
    text_total_levels <- paste0(
      name, ": ", nrow(table_no_missing), " level, namely "
    )
  }

  text_full <- paste0(
    text_total_levels, datawizard::text_concatenate(params, sep = ", ")
  )
  text <- paste0(
    text_total_levels, datawizard::text_concatenate(summary(params), sep = ", ")
  )

  as.report_text(text_full, summary = text)
}

#' @export
report_text.logical <- report_text.factor

#' @export
report_text.Date <- report_text.factor


# report_statistics -------------------------------------------------------


#' @export
report_statistics.factor <- function(x, table = NULL,
                                     levels_percentage = "auto", ...) {
  if (!is.factor(x)) {
    x <- as.factor(x)
  }
  if (is.null(table)) {
    table <- report_table(
      x, levels_percentage = levels_percentage, ...
    )
  }

  text_levels <- paste0(table$Level)
  text_n_obs <- paste0("n = ", table$n_Obs)
  text_percentage_obs <- paste0(
    insight::format_value(table$percentage_Obs), "%"
  )

  text_full <- paste0(
    text_levels, ", ",
    text_n_obs, ", ",
    text_percentage_obs
  )

  if (isTRUE(levels_percentage)) {
    text <- paste0(
      text_levels, ", ",
      text_percentage_obs
    )
  } else {
    text <- paste0(
      text_levels, ", ",
      text_n_obs
    )
  }

  as.report_statistics(
    paste(text_full, collapse = "; "),
    summary = paste(text, collapse = "; ")
  )
}

#' @export
report_statistics.Date <- report_statistics.factor
