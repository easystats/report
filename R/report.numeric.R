#' @rdname report.data.frame
#' @export
report.numeric <- function(x,
                           n = FALSE,
                           centrality = "mean",
                           dispersion = TRUE,
                           range = TRUE,
                           distribution = FALSE,
                           missing_percentage = "auto",
                           digits = 2,
                           ...) {
  # Print warning if only two different vars
  if (length(unique(x)) <= 2) {
    if (is.null(names(x))) {
      name <- deparse(substitute(x))
    } else {
      name <- names(x)
    }
    warning(insight::format_message(
      paste0(
        "Variable `", name, "` contains only ", length(unique(x)),
        "different values. Consider converting it to a factor."
      )
    ), call. = FALSE)
  }

  numeric_table <- report_table(
    x,
    centrality = centrality,
    dispersion = dispersion,
    range = range,
    distribution = distribution,
    missing_percentage = missing_percentage,
    digits = digits,
    ...
  )

  result_text <- report_text(
    x,
    table = numeric_table,
    centrality = centrality,
    dispersion = dispersion,
    range = range,
    distribution = distribution,
    missing_percentage = missing_percentage,
    digits = digits,
    ...
  )

  as.report(result_text, table = numeric_table, ...)
}


# report_table ------------------------------------------------------------

#' @export
report_table.numeric <- function(x,
                                 n = FALSE,
                                 centrality = "mean",
                                 dispersion = TRUE,
                                 range = TRUE,
                                 distribution = FALSE,
                                 missing_percentage = "auto",
                                 digits = 2,
                                 ...) {
  missing_percentage <- .report_dataframe_percentage(x, missing_percentage)

  table_full <- data.frame(
    Mean = mean(x, na.rm = TRUE),
    SD = stats::sd(x, na.rm = TRUE),
    Median = stats::median(x, na.rm = TRUE),
    MAD = stats::mad(x, na.rm = TRUE),
    Min = min(x, na.rm = TRUE),
    Max = max(x, na.rm = TRUE),
    n_Obs = length(x),
    Skewness = as.numeric(datawizard::skewness(x, verbose = FALSE, ...)),
    Kurtosis = as.numeric(datawizard::kurtosis(x, verbose = FALSE, ...)),
    n_Missing = sum(is.na(x))
  )

  table_full$percentage_Missing <- table_full$n_Missing / table_full$n_Obs * 100

  # Summary table
  summary_table <- table_full

  # N observations
  if (isFALSE(n)) summary_table$n_Obs <- NULL

  # Centrality and dispersion
  if (!isFALSE(centrality) && !is.null(centrality)) {
    if (centrality == "median") {
      if (dispersion) {
        summary_table <- datawizard::data_remove(summary_table, c("Mean", "SD"))
      } else {
        summary_table <- datawizard::data_remove(summary_table, c("Mean", "SD", "MAD"))
      }
    } else if (dispersion) {
      summary_table <- datawizard::data_remove(summary_table, c("Median", "MAD"))
    } else {
      summary_table <- datawizard::data_remove(summary_table, c("Median", "MAD", "SD"))
    }
  }

  # Range
  if (!range) {
    summary_table <- datawizard::data_remove(summary_table, c("Min", "Max"))
  }

  # Distribution
  if (!distribution) {
    summary_table <- datawizard::data_remove(summary_table, c("Skewness", "Kurtosis"))
  }

  # Missing
  if (is.null(missing_percentage)) {
    summary_table <- datawizard::data_remove(summary_table, c("percentage_Missing", "n_Missing"))
    table_full <- datawizard::data_remove(table_full, c("percentage_Missing", "n_Missing"))
  } else if (isTRUE(missing_percentage)) {
    summary_table <- datawizard::data_remove(summary_table, "n_Missing")
    table_full <- datawizard::data_remove(table_full, "n_Missing")
  } else {
    summary_table <- datawizard::data_remove(summary_table, "percentage_Missing")
    table_full <- datawizard::data_remove(table_full, "percentage_Missing")
  }

  as.report_table(table_full, summary = summary_table)
}


# report_parameters -------------------------------------------------------

#' @export
report_parameters.numeric <- function(x,
                                      table = NULL,
                                      n = FALSE,
                                      centrality = "mean",
                                      dispersion = TRUE,
                                      range = TRUE,
                                      distribution = FALSE,
                                      missing_percentage = "auto",
                                      digits = 2,
                                      ...) {
  missing_percentage <- .report_dataframe_percentage(x, missing_percentage)

  # Get table
  if (is.null(table)) {
    table <- report_table(
      x,
      n = n,
      centrality = centrality,
      dispersion = dispersion,
      range = range,
      distribution = distribution,
      missing_percentage = missing_percentage,
      digits = digits,
      ...
    )
  }

  # Compute text elements ---
  text_n <- paste0("n = ", insight::format_value(table$n_Obs, protect_integers = TRUE))

  # Centrality
  text_mean <- paste0("Mean = ", insight::format_value(table$Mean[1], digits = digits))
  text_median <- paste0("Median = ", insight::format_value(table$Median[1], digits = digits))

  # Dispersion
  text_sd <- insight::format_value(table$SD[1], digits = digits)
  text_mad <- insight::format_value(table$MAD[1], digits = digits)

  # Range
  text_range <- paste0(
    "[",
    insight::format_value(table$Min[1], protect_integers = TRUE, digits = digits),
    ", ", insight::format_value(table$Max[1], protect_integers = TRUE), "]"
  )

  # Distribution
  text_skewness <- paste0("Skewness = ", insight::format_value(table$Skewness[1]))
  text_kurtosis <- paste0("Kurtosis = ", insight::format_value(table$Kurtosis[1]))

  # Missing
  if (is.null(missing_percentage)) {
    text_missing <- NULL
  } else if (isTRUE(missing_percentage)) {
    n_missing <- table$percentage_Missing[1]
    text_missing <- paste0(
      insight::format_value(table$percentage_Missing[1],
        protect_integers = TRUE,
        digits = digits
      ),
      "% missing"
    )
  } else {
    n_missing <- table$n_Missing[1]
    text_missing <- paste0(table$n_Missing[1], " missing")
  }

  text_full <- c(
    n_Obs = text_n,
    Mean = text_mean,
    Dispersion_Mean = paste0("SD = ", text_sd),
    Median = text_median,
    Dispersion_Median = paste0("MAD = ", text_mad),
    Range = paste0("range: ", text_range),
    Skewness = text_skewness,
    Kurtosis = text_kurtosis,
    Missing = text_missing
  )

  # Shorten ---
  result_text <- text_full

  # N observations
  if (isFALSE(n)) result_text <- result_text[names(result_text) != "n_Obs"]

  # Centrality and dispersion
  if (!isFALSE(centrality) && !is.null(centrality)) {
    if (centrality == "median") {
      result_text <- result_text[!names(result_text) %in% c("Mean", "Dispersion_Mean")]
      if (!dispersion) {
        result_text <- result_text[names(result_text) != "Dispersion_Median"]
      }
    } else {
      result_text <- result_text[!names(result_text) %in% c("Median", "Dispersion_Median")]
      if (!dispersion) {
        result_text <- result_text[names(result_text) != "Dispersion_Mean"]
      }
    }
  } else {
    result_text <- result_text[!names(result_text) %in% c("Mean", "Dispersion_Mean", "Median", "Dispersion_Median")]
  }

  # Range
  if (!range) {
    result_text <- result_text[names(result_text) != "Range"]
  }

  # Distribution
  if (!distribution) {
    result_text <- result_text[!names(result_text) %in% c("Skewness", "Kurtosis")]
  }

  if (is.null(missing_percentage) || n_missing == 0) {
    result_text <- result_text[names(result_text) != "Missing"]
  }

  as.report_parameters(text_full, summary = result_text, ...)
}


# report_text -------------------------------------------------------------

#' @export
report_text.numeric <- function(x,
                                table = NULL,
                                n = FALSE,
                                centrality = "mean",
                                dispersion = TRUE,
                                range = TRUE,
                                distribution = FALSE,
                                missing_percentage = "auto",
                                digits = 2,
                                ...) {
  if (!is.null(list(...)$varname)) {
    name <- list(...)$varname
  } else if (is.null(names(x))) {
    name <- deparse(substitute(x))
  } else {
    name <- "Continuous variable"
  }

  # Get parameters
  params <- report_parameters(
    x,
    table = table,
    n = n,
    centrality = centrality,
    dispersion = dispersion,
    range = range,
    distribution = distribution,
    missing_percentage = missing_percentage,
    digits = digits,
    ...
  )

  result_text <- paste0(
    name,
    ": ",
    toString(params)
  )

  short <- paste0(
    name,
    ": ",
    toString(summary(params))
  )

  as.report_text(result_text, summary = short)
}


# report_statistics -------------------------------------------------------


#' @export
report_statistics.numeric <- function(x,
                                      table = NULL,
                                      n = FALSE,
                                      centrality = "mean",
                                      dispersion = TRUE,
                                      range = TRUE,
                                      distribution = FALSE,
                                      missing_percentage = "auto",
                                      digits = 2,
                                      ...) {
  # Get parameters
  params <- report_parameters(
    x,
    table = table,
    n = n,
    centrality = centrality,
    dispersion = dispersion,
    range = range,
    distribution = distribution,
    missing_percentage = missing_percentage,
    digits = digits,
    ...
  )

  result_text <- toString(params)
  short <- toString(summary(params))

  as.report_statistics(result_text, summary = short)
}
