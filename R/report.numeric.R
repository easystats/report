#' Numeric Vector Report
#'
#' Create a report of a numeric vector.
#'
#' @param model Numeric vector.
#' @param median Show \link{mean} and \link{sd} (default) or \link{median} and \link{mad}.
#' @param dispersion Show dispersion (\link{sd} or \link{mad}).
#' @param range Show range.
#' @param missing_percentage Show missings by number (default) or percentage
#' @param ... Arguments passed to or from other methods.
#'
#'
#'
#' @examples
#' x <- rnorm(1000)
#' report(x)
#' report(x, median = TRUE, dispersion = TRUE, range = TRUE, missing_percentage = TRUE)
#' to_fulltext(report(x))
#' to_table(report(x))
#' to_fulltable(report(x))
#' @seealso report
#' @import dplyr
#' @importFrom stats mad sd
#'
#' @export
report.numeric <- function(model, median = FALSE, dispersion = TRUE, range = TRUE, missing_percentage = FALSE, ...) {
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
    Mean = mean(model),
    SD = sd(model),
    Median = median(model),
    MAD = mad(model),
    Min = min(model),
    Max = max(model),
    n_Obs = length(model),
    n_Missing = sum(is.na(model))
  )
  table_full$percentage_Missing <- table_full$n_Missing / table_full$n_Obs * 100


  # Text --------------------------------------------------------------------
  # Centrality
  text_mean <- paste0("Mean = ", format_value(table_full$Mean[1]))
  text_median <- paste0("Median = ", format_value(table_full$Median[1]))

  # Dispersion
  text_sd <- format_value(table_full$SD[1])
  text_mad <- format_value(table_full$MAD[1])

  # Range
  text_range <- paste0(" [", format_value(table_full$Min[1]), ", ", format_value(table_full$Max[1]), "]")

  # Missings
  if (missing_percentage == TRUE) {
    text_missing <- paste0(", ", format_value(table_full$percentage_Missing[1], 1), "% missing.")
  } else {
    text_missing <- paste0(", ", table_full$n_Missing[1], " missing.")
  }



  # Selection ---------------------------------------------------------------
  table <- table_full
  if (median == TRUE) {
    if (dispersion == TRUE) {
      text <- paste0(text_median, " +- ", text_mad)
      table <- dplyr::select(table, -one_of("Mean", "SD"))
    } else {
      text <- text_median
      table <- dplyr::select(table, -one_of("Mean", "SD", "MAD"))
    }
  } else {
    if (dispersion == TRUE) {
      text <- paste0(text_mean, " +- ", text_sd)
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


  # Text
  text_full <- paste0(
    text_mean, ", SD = ", text_sd, ", ",
    text_median, ", MAD = ", text_mad, ", Range =",
    text_range, text_missing
  )

  if (table_full$n_Missing[1] > 0) {
    text <- paste0(text, text_missing)
  }


  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full,
    values = as.list(table_full)
  )

  return(as.report(out))
}
