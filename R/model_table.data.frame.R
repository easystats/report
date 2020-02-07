#' @examples
#' x <- c("A", "B", "C", "A", "B", "B", "D", "E", "B", "D", "A")
#' model_table(x)
#' summary(model_table(x))
#' @seealso report
#'
#' @export
model_table.character <- function(model, n_entries = 3, levels_percentage = FALSE, missing_percentage = FALSE, ...) {
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

  as.model_table(table, table_full)
}




#' @examples
#' x <- factor(rep(c("A", "B", "C"), 10))
#' model_table(x)
#' summary(model_table(x))
#'
#' @seealso report
#'
#' @export
model_table.factor <- function(model, levels_percentage = FALSE, ...) {
  model <- as.factor(model)

  if (length(model[is.na(model)]) != 0) {
    model <- factor(ifelse(is.na(model), "missing", as.character(model)), levels = c(levels(model), "missing"))
  }

  # Table -------------------------------------------------------------------
  table_full <- as.data.frame(table(model))
  names(table_full) <- c("Level", "n_Obs")
  table_full$percentage_Obs <- table_full$n_Obs / length(model) * 100


  # Selection ---------------------------------------------------------------
  table <- table_full
  if (levels_percentage == FALSE) {
    table <- remove_if_possible(table, "percentage_Obs")
  }

  values <- list()
  for (level in table_full$Level) {
    values[[level]] <- as.list(table_full[table_full$Level == level, ])
  }


  as.model_table(table, table_full)
}


#' @export
model_table.logical <- model_table.factor












#' @keywords internal
.order_columns <- function(df, cols) {
  remaining_columns <- setdiff(colnames(df), cols)
  df[, c(cols, remaining_columns)]
}
