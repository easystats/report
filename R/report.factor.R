#' @rdname report.data.frame
#' @inherit report return seealso
#' @examples
#' x <- factor(rep(c("A", "B", "C"), 10))
#' report(x)
#' model_table(x)
#' model_text(x)
#' summary(model_table(x))
#' summary(model_text(x))
#' @export
report.factor <- function(model, levels_percentage = FALSE, ...) {
  model <- as.factor(model)

  if (length(model[is.na(model)]) != 0) {
    model <- factor(ifelse(is.na(model), "missing", as.character(model)), levels = c(levels(model), "missing"))
  }

  # Table -------------------------------------------------------------------
  table_full <- as.data.frame(table(model))
  names(table_full) <- c("Level", "n_Obs")
  table_full$percentage_Obs <- table_full$n_Obs / length(model) * 100

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
    table <- remove_if_possible(table, "percentage_Obs")
    text <- paste0(text_levels, ", ", text_n_Obs)
  }


  text <- paste0(text_total_levels, format_text(text, sep = "; "))
  text_full <- paste0(text_total_levels, format_text(text_full, sep = "; "))

  values <- list()
  for (level in table_full$Level) {
    values[[level]] <- as.list(table_full[table_full$Level == level, ])
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
report.logical <- report.factor



#' @export
model_table.factor <- function(model, levels_percentage = FALSE, ...) {
  r <- report(model, levels_percentage = levels_percentage, ...)
  r$tables
}


#' @export
model_text.factor <- function(model, levels_percentage = FALSE, ...) {
  r <- report(model, levels_percentage = levels_percentage, ...)
  r$texts
}
