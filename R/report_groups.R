#' Sample Description
#'
#' Create sample description table (Table 1).
#'
#' @param data A data frame for which descriptive statistics should be created.
#' @param group_by Character vector, indicating the column for possible grouping of the descriptive table.
#' @param centrality Character, indicates the statistics that should be calculated for numeric variables. May be \code{"mean"} (for mean and standard deviation) or \code{"median"} (for median and median absolute deviation) as summary.
#' @param select Character vector, with column names that should be included in the descriptive table.
#' @param exclude Character vector, with column names that should be excluded from the descriptive table.
#' @param digits Number of decimals.
#' @inheritParams report.data.frame
#'
#' @examples
#' data(iris)
#' report_groups(iris[, 1:4])
#' report_groups(iris, select = c("Sepal.Length", "Petal.Length", "Species"))
#' report_groups(iris, group_by = "Species")
#' @importFrom stats median sd mad
#' @export
report_groups <- function(data, group_by = NULL, centrality = "mean", select = NULL, exclude = NULL, digits = 1, ...) {
  variables <- colnames(data)

  # variables to keep
  if (!is.null(select)) {
    variables <- intersect(select, variables)
  }

  # variables to exclude
  if (!is.null(exclude)) {
    variables <- setdiff(variables, exclude)
  }

  # grouped by?
  grouping <- !is.null(group_by) && group_by %in% colnames(data)

  out <- if (isTRUE(grouping)) {
    result <- lapply(split(data[variables], factor(data[[group_by]])), function(x) {
      x[[group_by]] <- NULL
      .generate_descriptive_table(x, centrality, digits)
    })
    # remember values of first columns
    variable <- result[[1]]["Characteristic"]
    # column names for groups
    cn <- sprintf("%s (n=%g)", names(result), as.vector(table(data[[group_by]])))
    # just extract summary columns
    summaries <- do.call(cbind, lapply(result, function(i) i["Summary"]))
    colnames(summaries) <- cn
    # bind all together, including total column
    cbind(
      variable,
      summaries,
      Total = .generate_descriptive_table(data[setdiff(variables, group_by)], centrality, digits)[["Summary"]]
    )
  } else {
    .generate_descriptive_table(data[variables], centrality, digits)
  }

  class(out) <- c("report_table1", class(out))
  out
}






# helper ------------------------


.generate_descriptive_table <- function(x, centrality, digits) {
  do.call(rbind, lapply(colnames(x), function(cn) {
    .table1_row(x[[cn]], column = cn, centrality = centrality, digits = digits)
  }))
}






# create a "table row", i.e. a summary from a variable ------------------------


.table1_row <- function(x, digits = 1, ...) {
  UseMethod(".table1_row")
}



.table1_row.numeric <- function(x, column, centrality = "mean", digits = 1, ...) {
  .summary <- if (centrality == "mean") {
    sprintf("%.*f (%.*f)", digits, mean(x, na.rm = TRUE), digits, stats::sd(x, na.rm = TRUE))
  } else {
    sprintf("%.*f (%.*f)", digits, stats::median(x, na.rm = TRUE), digits, stats::mad(x, na.rm = TRUE))
  }

  if (centrality == "mean") {
    column <- sprintf("Mean %s (SD)", column)
  } else {
    column <- sprintf("Median %s (MAD)", column)
  }

  data.frame(
    Characteristic = column,
    Summary = .summary,
    stringsAsFactors = FALSE
  )
}



.table1_row.factor <- function(x, column, digits = 1, ...) {
  proportions <- prop.table(table(x))
  # for binary factors, just need one level
  if (length(proportions) == 2) {
    proportions <- proportions[2]
  }
  .summary <- sapply(proportions, function(i) sprintf("%.1f", 100 * i))
  data.frame(
    Characteristic = sprintf("%s [%s], %%", column, names(.summary)),
    Summary = as.vector(.summary),
    stringsAsFactors = FALSE
  )
}


.table1_row.character <- .table1_row.factor





# print-method --------------------------------------------


#' @importFrom insight print_colour format_table
#' @export
print.report_table1 <- function(x, ...) {
  insight::print_colour("# Descriptive Statistics\n\n", "blue")
  cat(insight::format_table(x))
}