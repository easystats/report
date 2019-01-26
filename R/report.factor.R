#' Factor (Categorical Vector) Report
#'
#' Create a report of a categorical vector.
#'
#' @param x Categorical vector.
#' @param levels_percentage Show factor levels by number (default) or percentage.
#' @param missing_percentage Show missings by number (default) or percentage.
#' @param ... Arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
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
report.factor <- function(x, levels_percentage = FALSE, missing_percentage = FALSE, ...) {

  # Table -------------------------------------------------------------------
  table_full <- data.frame(Level = x) %>%
    group_by_("Level") %>%
    summarise_(
      "n_Obs" = "n()",
      "percentage_Obs" = "n() / length(x) * 100",
      "n_Missing" = "sum(is.na(x))",
      "percentage_Missing" = "n_Missing / n_Obs * 100"
    )

  # Text --------------------------------------------------------------------
  if (nrow(table_full) > 1) {
    text_total_levels <- paste0(nrow(table_full), " levels: ")
  } else {
    text_total_levels <- paste0(nrow(table_full), " level: ")
  }

  text_levels <- paste0(table_full$Level)
  text_n_Obs <- paste0("n = ", table_full$n_Obs)
  text_percentage_Obs <- paste0(format_value(table_full$percentage_Obs), "%")
  text_n_Missing <- paste0(table_full$n_Missing, " missing")
  text_percentage_Missing <- paste0(format_value(table_full$percentage_Missing), "% missing")

  text_full <- paste0(
    text_levels, " (",
    text_n_Obs, ", ",
    text_percentage_Obs, "; "
  )
  # Selection ---------------------------------------------------------------
  table <- table_full
  if (levels_percentage == TRUE) {
    text <- paste0(text_levels, " (", text_percentage_Obs)
  } else {
    table <- dplyr::select(table, -one_of("percentage_Obs"))
    text <- paste0(text_levels, " (", text_n_Obs)
  }


  if (missing_percentage == TRUE) {
    text_full <- paste0(text_full, text_percentage_Missing, ")")
    table <- dplyr::select(table, -one_of("n_Missing"))
    if (any(table_full$n_Missing > 0)) {
      text <- paste0(text, "; ", text_percentage_Missing, ")")
    } else {
      text <- paste0(text, ")")
    }
  } else {
    text_full <- paste0(text_full, text_n_Missing, ")")
    table <- dplyr::select(table, -one_of("percentage_Missing"))
    if (any(table_full$n_Missing > 0)) {
      text <- paste0(text, "; ", text_n_Missing, ")")
    } else {
      text <- paste0(text, ")")
    }
  }

  text <- paste0(text_total_levels, paste0(text, collapse = "; "))
  text_full <- paste0(text_total_levels, paste0(text_full, collapse = "; "))

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

  return(as.report(out))
}
