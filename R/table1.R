#' Create Table 1 (Sample Description)
#'
#' Create Table 1 (Sample Description).
#'
#' @param data A data frame for which descriptive statistics should be created.
#' @param centrality Character, indicates the statistics that should be calculated for numeric variables. May be \code{"mean"} (for mean and standard deviation) or \code{"median"} (for median and median absolute deviation) as summary.
#' @param select Character vector, with column names that should be included in the descriptive table.
#' @param exclude Character vector, with column names that should be excluded from the descriptive table.
#' @param group_by Character vector, indicating the column for possible grouping of the descriptive table.
#' @param digits Number of decimals.
#'
#' @examples
#' data(iris)
#' table1(iris[, 1:4])
#' table1(iris, select = c("Sepal.Length", "Petal.Length", "Species"))
#' table1(iris, group_by = "Species")
#' @importFrom stats median sd mad
#' @export
table1 <- function(data, centrality = "mean", select = NULL, exclude = NULL, group_by = NULL, digits = 1, ...) {
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
    variable <- result[[1]]["Variable"]
    cn <- sprintf("Summary (%s)", names(result))
    summaries <- do.call(cbind, lapply(result, function(i) i["Summary"]))
    colnames(summaries) <- cn
    cbind(variable, summaries)
  } else {
    .generate_descriptive_table(data[variables], centrality, digits)
  }

  class(out) <- c("report_table1", class(out))
  out
}


.generate_descriptive_table <- function(x, centrality, digits) {
  do.call(rbind, lapply(colnames(x), function(cn) {
    .table1_row(x[[cn]], column = cn, centrality = centrality, digits = digits)
  }))
}


.table1_row <- function(x, digits = 1, ...) {
  UseMethod(".table1_row")
}


.table1_row.numeric <- function(x, column, centrality = "mean", digits = 1, ...) {
  .summary <- if (centrality == "mean") {
    sprintf("%.*f (%.*f)", digits, mean(x, na.rm = TRUE), digits, stats::sd(x, na.rm = TRUE))
  } else {
    sprintf("%.*f (%.*f)", digits, stats::median(x, na.rm = TRUE), digits, stats::mad(x, na.rm = TRUE))
  }

  data.frame(
    Variable = column,
    Summary = .summary,
    stringsAsFactors = FALSE
  )
}


.table1_row.factor <- function(x, column, digits = 1, ...) {
  .summary <- sapply(prop.table(table(x)), function(i) sprintf("%.1f%%", 100 * i))
  data.frame(
    Variable = sprintf("%s [%s]", column, names(.summary)),
    Summary = as.vector(.summary),
    stringsAsFactors = FALSE
  )
}




#' @importFrom insight print_colour format_table
#' @export
print.report_table1 <- function(x, ...) {
  insight::print_colour("# Descriptive Statistics\n\n", "blue")
  cat(insight::format_table(x))
}