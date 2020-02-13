#' @rdname report.data.frame
#' @examples
#' x <- rnorm(1000)
#' report(x)
#' report(x, median = TRUE, missing_percentage = TRUE, distribution = TRUE)
#' model_table(x)
#' model_text(x)
#' summary(model_table(x))
#' summary(model_text(x))
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
    Kurtosis = parameters::kurtosis(model, type = 1),
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
  text_distribution <- paste0(
    ", Skewness = ",
    insight::format_value(table_full$Skewness[1]),
    ", Kurtosis = ",
    insight::format_value(table_full$Kurtosis[1])
  )

  # Missings
  if (!is.null(missing_percentage)) {
    if (missing_percentage == TRUE) {
      text_missing <- paste0(", ", insight::format_value(table_full$percentage_Missing[1], protect_integers = TRUE), "% missing")
    } else {
      text_missing <- paste0(", ", table_full$n_Missing[1], " missing")
    }
  } else {
    text_missing <- ""
  }




  # Selection ---------------------------------------------------------------
  table <- table_full

  # Centrality and dispersion
  if (centrality == TRUE) {
    if (median == TRUE) {
      if (dispersion == TRUE) {
        text <- paste0(text_median, ", MAD = ", text_mad)
        table <- remove_if_possible(table, c("Mean", "SD"))
      } else {
        text <- text_median
        table <- remove_if_possible(table, c("Mean", "SD", "MAD"))
      }
    } else {
      if (dispersion == TRUE) {
        text <- paste0(text_mean, ", SD = ", text_sd)
        table <- remove_if_possible(table, c("Median", "MAD"))
      } else {
        text <- text_mean
        table <- remove_if_possible(table, c("Median", "MAD", "SD"))
      }
    }
  } else {
    if (median == TRUE) {
      if (dispersion == TRUE) {
        text <- paste0("MAD = ", text_mad)
        table <- remove_if_possible(table, c("Mean", "Median", "SD"))
      } else {
        text <- ""
        table <- remove_if_possible(table, c("Mean", "Median", "SD", "MAD"))
      }
    } else {
      if (dispersion == TRUE) {
        text <- paste0("SD = ", text_sd)
        table <- remove_if_possible(table, c("Mean", "Median", "MAD"))
      } else {
        text <- ""
        table <- remove_if_possible(table, c("Mean", "Median", "MAD", "SD"))
      }
    }
  }

  # Range
  if (range == TRUE) {
    text <- paste0(text, ", range = ", text_range)
  } else {
    table <- remove_if_possible(table, c("Min", "Max"))
  }

  # Distribution
  if (distribution == TRUE) {
    text <- paste0(text, text_distribution)
  } else {
    table <- remove_if_possible(table, c("Skewness", "Kurtosis"))
  }


  # Missing
  if (!is.null(missing_percentage)) {
    if (missing_percentage == TRUE) {
      table <- remove_if_possible(table, "n_Missing")
      table_full <- remove_if_possible(table_full, "n_Missing")
    } else {
      table <- remove_if_possible(table, "percentage_Missing")
      table_full <- remove_if_possible(table_full, "percentage_Missing")
    }
  } else {
    table <- remove_if_possible(table, c("percentage_Missing", "n_Missing"))
    table_full <- remove_if_possible(table_full, c("percentage_Missing", "n_Missing"))
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
model_table.numeric <- function(model, median = FALSE, centrality = TRUE, dispersion = TRUE, range = TRUE, distribution = FALSE, missing_percentage = FALSE, ...) {
  r <- report(model, median = median, centrality = centrality, dispersion = dispersion, range = range, distribution = distribution, missing_percentage = missing_percentage, ...)
  r$tables
}


#' @export
model_text.numeric <- function(model, median = FALSE, centrality = TRUE, dispersion = TRUE, range = TRUE, distribution = FALSE, missing_percentage = FALSE, ...) {
  r <- report(model, median = median, centrality = centrality, dispersion = dispersion, range = range, distribution = distribution, missing_percentage = missing_percentage, ...)
  r$texts
}
