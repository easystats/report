#' Reporting Datasets and Dataframes
#'
#' Create reports for data frames.
#'
#' @inheritParams report
#' @param n Include number of observations for each individual variable.
#' @param centrality Character vector, indicating the index of centrality
#'   (either \code{"mean"} or \code{"median"}).
#' @param dispersion Show index of dispersion (\link{sd} if \code{centrality = "mean"}, or \link{mad} if \code{centrality = "median"}).
#' @param range Show range.
#' @param distribution Show \code{\link[parameters:skewness]{kurtosis}} and \code{\link[parameters:skewness]{skewness}}.
#' @param n_entries Number of different character entries to show. Can be "all".
#' @param levels_percentage Show characters entries and factor levels by number
#'   or percentage. If "auto", then will be set to number and percentage if the
#'   length if n observations larger than 100.
#' @param missing_percentage Show missing by number (default) or percentage. If
#'   "auto", then will be set to number and percentage if the length if n
#'   observations larger than 100.
#' @param digits Number of significant digits.
#'
#' @examples
#' library(report)
#'
#' r <- report(iris,
#'   centrality = "median", dispersion = FALSE,
#'   distribution = TRUE, missing_percentage = TRUE
#' )
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#'
#' if (require("dplyr")) {
#'   r <- iris %>%
#'     dplyr::group_by(Species) %>%
#'     report()
#'   r
#'   summary(r)
#'   as.data.frame(r)
#'   summary(as.data.frame(r))
#' }
#' @export
report.data.frame <- function(x,
                              n = FALSE,
                              centrality = "mean",
                              dispersion = TRUE,
                              range = TRUE,
                              distribution = FALSE,
                              levels_percentage = "auto",
                              digits = 2,
                              n_entries = 3,
                              missing_percentage = "auto",
                              ...) {

  # remove list columns
  x <- x[, sapply(x, class) != "list"]

  table <-
    report_table(
      x,
      n = n,
      centrality = centrality,
      dispersion = dispersion,
      range = range,
      distribution = distribution,
      levels_percentage = levels_percentage,
      digits = digits,
      n_entries = n_entries,
      missing_percentage = missing_percentage,
      ...
    )

  text <-
    report_text(
      x,
      n = n,
      centrality = centrality,
      dispersion = dispersion,
      range = range,
      distribution = distribution,
      levels_percentage = levels_percentage,
      digits = digits,
      n_entries = n_entries,
      missing_percentage = missing_percentage,
      ...
    )

  as.report(text, table = table, ...)
}


# report_table ------------------------------------------------------------



#' @export
report_table.data.frame <- function(x,
                                    n = FALSE,
                                    centrality = "mean",
                                    dispersion = TRUE,
                                    range = TRUE,
                                    distribution = FALSE,
                                    levels_percentage = "auto",
                                    digits = 2,
                                    n_entries = 3,
                                    missing_percentage = "auto",
                                    ...) {
  table_full <- data.frame()
  table <- data.frame()

  for (i in 1:ncol(x)) {
    col <- names(x)[i]
    current_table_full <- report_table(
      x[[col]],
      n = n,
      centrality = centrality,
      dispersion = dispersion,
      range = range,
      distribution = distribution,
      levels_percentage = levels_percentage,
      digits = digits,
      n_entries = n_entries,
      missing_percentage = missing_percentage,
      ...
    )

    current_table <- current_table_full
    current_table$Variable <- col
    current_table$.order <- i

    if (nrow(table_full) == 0) {
      table_full <- current_table
    } else {
      table_full <- merge(table_full, current_table, all = TRUE)
    }

    current_table <- summary(current_table_full)
    current_table$Variable <- col
    current_table$.order <- i

    if (nrow(table) == 0) {
      table <- current_table
    } else {
      table <- merge(table, current_table, all = TRUE)
    }
  }

  if ("Level" %in% names(table)) {
    if ("percentage_Obs" %in% names(table)) {
      table <- data_reorder(table, c("Variable", "Level", "n_Obs", "percentage_Obs"))
      table_full <- data_reorder(table_full, c("Variable", "Level", "n_Obs", "percentage_Obs"))
    } else {
      table <- data_reorder(table, c("Variable", "Level", "n_Obs"))
      table_full <- data_reorder(table_full, c("Variable", "Level", "n_Obs"))
    }
  } else {
    table <- data_reorder(table, c("Variable", "n_Obs"))
    table_full <- data_reorder(table_full, c("Variable", "n_Obs"))
  }

  # Reorder cols
  table <- table[order(table$`.order`), ]
  table$`.order` <- NULL
  table_full <- table_full[order(table_full$`.order`), ]
  table_full$`.order` <- NULL

  as.report_table(table_full, summary = table)
}




# report_parameters -------------------------------------------------------



#' @export
report_parameters.data.frame <- function(x,
                                         table = NULL,
                                         n = FALSE,
                                         centrality = "mean",
                                         dispersion = TRUE,
                                         range = TRUE,
                                         distribution = FALSE,
                                         levels_percentage = "auto",
                                         digits = 2,
                                         n_entries = 3,
                                         missing_percentage = "auto",
                                         ...) {
  text_full <- c()
  text <- c()

  for (i in 1:ncol(x)) {
    r <- report_text(
      x[[names(x)[i]]],
      n = n,
      centrality = centrality,
      dispersion = dispersion,
      range = range,
      distribution = distribution,
      levels_percentage = levels_percentage,
      digits = digits,
      n_entries = n_entries,
      missing_percentage = missing_percentage,
      varname = names(x)[i],
      ...
    )

    text_full <- c(text_full, r)
    text <- c(text, summary(r))
  }

  as.report_parameters(text_full, summary = text, ...)
}



# report_text -------------------------------------------------------------

#' @export
report_text.data.frame <- function(x,
                                   table = NULL,
                                   n = FALSE,
                                   centrality = "mean",
                                   dispersion = TRUE,
                                   range = TRUE,
                                   distribution = FALSE,
                                   levels_percentage = "auto",
                                   digits = 2,
                                   n_entries = 3,
                                   missing_percentage = "auto",
                                   ...) {
  params <- report_parameters(
    x,
    n = n,
    centrality = centrality,
    dispersion = dispersion,
    range = range,
    distribution = distribution,
    levels_percentage = levels_percentage,
    digits = digits,
    n_entries = n_entries,
    missing_percentage = missing_percentage,
    ...
  )

  # Concatenate text
  text_full <- paste0("The data contains ", nrow(x), " observations of the following variables:\n", as.character(params))
  text <- paste0("The data contains ", nrow(x), " observations of the following variables:\n", as.character(summary(params)))

  as.report_text(text_full, summary = text)
}



# report_statistics -------------------------------------------------------


#' @export
report_statistics.data.frame <- function(x,
                                         table = NULL,
                                         n = FALSE,
                                         centrality = "mean",
                                         dispersion = TRUE,
                                         range = TRUE,
                                         distribution = FALSE,
                                         levels_percentage = "auto",
                                         digits = 2,
                                         n_entries = 3,
                                         missing_percentage = "auto",
                                         ...) {
  text_full <- c()
  text <- c()

  for (i in 1:ncol(x)) {
    r <- report_statistics(
      x[[names(x)[i]]],
      n = n,
      centrality = centrality,
      dispersion = dispersion,
      range = range,
      distribution = distribution,
      levels_percentage = levels_percentage,
      digits = digits,
      n_entries = n_entries,
      missing_percentage = missing_percentage,
      varname = names(x)[i],
      ...
    )

    text_full <- c(text_full, r)
    text <- c(text, summary(r))
  }

  as.report_statistics(text_full, summary = text)
}


# Grouped dataframe -------------------------------------------------------

#' @keywords internal
.report_grouped_dataframe <- function(x) {
  groups <- .group_vars(x)
  ungrouped_x <- as.data.frame(x)
  dfs <- split(ungrouped_x, ungrouped_x[groups], sep = " - ")


  intro <- paste0(
    "The data contains ",
    nrow(ungrouped_x),
    " observations, grouped by ",
    groups,
    ", of the following variables:"
  )

  for (group in names(dfs)) {
    dfs[[group]] <- data_remove(dfs[[group]], groups)
  }

  list(dfs = dfs, intro = intro)
}


#' @export
report_table.grouped_df <- function(x,
                                    table = NULL,
                                    n = FALSE,
                                    centrality = "mean",
                                    dispersion = TRUE,
                                    range = TRUE,
                                    distribution = FALSE,
                                    levels_percentage = "auto",
                                    digits = 2,
                                    n_entries = 3,
                                    missing_percentage = "auto",
                                    ...) {
  out <- .report_grouped_dataframe(x)

  table_full <- data.frame()
  table <- data.frame()

  for (group in names(out$dfs)) {
    data <- out$dfs[[group]]

    current_table_full <- report_table(
      data,
      n = n,
      centrality = centrality,
      dispersion = dispersion,
      range = range,
      distribution = distribution,
      levels_percentage = levels_percentage,
      digits = digits,
      n_entries = n_entries,
      missing_percentage = missing_percentage,
      ...
    )

    current_table_full$Group <- group
    table_full <- rbind(table_full, current_table_full)
    current_table <- summary(current_table_full)
    current_table$Group <- group
    table <- rbind(table, current_table)
  }

  table <- data_reorder(table, "Group")
  table_full <- data_reorder(table_full, "Group")

  as.report_table(table_full, summary = table)
}




#' @export
report_parameters.grouped_df <- function(x,
                                         table = NULL,
                                         n = FALSE,
                                         centrality = "mean",
                                         dispersion = TRUE,
                                         range = TRUE,
                                         distribution = FALSE,
                                         levels_percentage = "auto",
                                         digits = 2,
                                         n_entries = 3,
                                         missing_percentage = "auto",
                                         ...) {
  out <- .report_grouped_dataframe(x)

  params_full <- c()
  params <- c()

  for (group in names(out$dfs)) {
    data <- out$dfs[[group]]

    r <- report_parameters(
      data,
      n = n,
      centrality = centrality,
      dispersion = dispersion,
      range = range,
      distribution = distribution,
      levels_percentage = levels_percentage,
      digits = digits,
      n_entries = n_entries,
      missing_percentage = missing_percentage,
      ...
    )

    params_full <- c(params_full, paste0(group, " - ", r))
    params <- c(params, paste0(group, " - ", summary(r)))
  }

  as.report_parameters(params_full, summary = params, ...)
}


#' @export
report_text.grouped_df <- function(x,
                                   table = NULL,
                                   n = FALSE,
                                   centrality = "mean",
                                   dispersion = TRUE,
                                   range = TRUE,
                                   distribution = FALSE,
                                   levels_percentage = "auto",
                                   digits = 2,
                                   n_entries = 3,
                                   missing_percentage = "auto",
                                   ...) {
  out <- .report_grouped_dataframe(x)

  text_full <- c(out$intro)
  text <- c(out$intro)

  for (group in names(out$dfs)) {
    data <- out$dfs[[group]]

    r <- report_parameters(
      data,
      n = n,
      centrality = centrality,
      dispersion = dispersion,
      range = range,
      distribution = distribution,
      levels_percentage = levels_percentage,
      digits = digits,
      n_entries = n_entries,
      missing_percentage = missing_percentage,
      ...
    )

    text_group <- paste0("\n- ", group, " (n = ", nrow(data), "):\n")

    text_full <- paste0(text_full, "\n", paste0(text_group, as.character(r)))
    text <- paste0(text, "\n", paste0(text_group, as.character(summary(r))))
  }

  as.report_text(text_full, summary = text)
}

#' @export
report.grouped_df <- report.data.frame



#' @export
report_statistics.grouped_df <- function(x,
                                         table = NULL,
                                         n = FALSE,
                                         centrality = "mean",
                                         dispersion = TRUE,
                                         range = TRUE,
                                         distribution = FALSE,
                                         levels_percentage = "auto",
                                         digits = 2,
                                         n_entries = 3,
                                         missing_percentage = "auto",
                                         ...) {
  out <- .report_grouped_dataframe(x)

  text_full <- c()
  text <- c()

  for (group in names(out$dfs)) {
    data <- out$dfs[[group]]

    r <- report_statistics(
      data,
      n = n,
      centrality = centrality,
      dispersion = dispersion,
      range = range,
      distribution = distribution,
      levels_percentage = levels_percentage,
      digits = digits,
      n_entries = n_entries,
      missing_percentage = missing_percentage,
      ...
    )

    text_full <- c(text_full, paste0(group, ", ", as.character(r)))
    text <- c(text, paste0(group, ", ", as.character(summary(r))))
  }

  as.report_statistics(text_full, summary = text)
}








# Utils -------------------------------------------------------------------

#' @keywords internal
.report_dataframe_percentage <- function(x, percentage = "auto") {
  if (is.null(percentage) || percentage != "auto") {
    return(percentage)
  }

  if (any(c("data.frame", "grouped_df") %in% class(x))) {
    n <- nrow(x)
  } else {
    n <- length(x)
  }

  if (n >= 100) {
    percentage <- TRUE
  } else {
    percentage <- FALSE
  }
  percentage
}
