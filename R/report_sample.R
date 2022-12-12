#' Sample Description
#'
#' Create sample description table (also referred to as "Table 1").
#'
#' @param data A data frame for which descriptive statistics should be created.
#' @param group_by Character vector, indicating the column for possible grouping
#'   of the descriptive table.
#' @param centrality Character, indicates the statistics that should be
#'   calculated for numeric variables. May be `"mean"` (for mean and
#'   standard deviation) or `"median"` (for median and median absolute
#'   deviation) as summary.
#' @param select Character vector, with column names that should be included in
#'   the descriptive table.
#' @param exclude Character vector, with column names that should be excluded
#'   from the descriptive table.
#' @param weights Character vector, indicating the name of a potential
#'   weight-variable. Reported descriptive statistics will be weighted by
#'   `weight`.
#' @param total Add a `Total` column.
#' @param digits Number of decimals.
#' @param n Logical, actual sample size used in the calculation of the
#' reported descriptive statistics (i.e., without the missing values).
#' @inheritParams report.data.frame
#'
#' @return A data frame of class `report_sample` with variable names and
#'   their related summary statistics.
#'
#' @examples
#' library(report)
#'
#' report_sample(iris[, 1:4])
#' report_sample(iris, select = c("Sepal.Length", "Petal.Length", "Species"))
#' report_sample(iris, group_by = "Species")
#' report_sample(airquality, group_by = "Month", n = TRUE, total = FALSE)
#' @export
report_sample <- function(data,
                          group_by = NULL,
                          centrality = "mean",
                          select = NULL,
                          exclude = NULL,
                          weights = NULL,
                          total = TRUE,
                          digits = 2,
                          n = FALSE,
                          ...) {
  variables <- colnames(data)

  # variables to keep
  if (!is.null(weights)) {
    select <- c(select, weights)
  }

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
      .generate_descriptive_table(x, centrality, weights, digits, n)
    })
    # remember values of first columns
    variable <- result[[1]]["Variable"]
    # column names for groups
    cn <- sprintf("%s (n=%g)", names(result), as.vector(table(data[[group_by]])))
    # just extract summary columns
    summaries <- do.call(cbind, lapply(result, function(i) i["Summary"]))
    colnames(summaries) <- cn
    # generate data for total column, but make sure to remove missings
    total_data <- data[!is.na(data[[group_by]]), unique(c(variables, group_by))]
    # bind all together, including total column
    final <- cbind(
      variable,
      summaries,
      Total = .generate_descriptive_table(
        total_data[setdiff(variables, group_by)],
        centrality,
        weights,
        digits,
        n
      )[["Summary"]]
    )
    # Remove Total column if need be
    if (isFALSE(total)) {
      final$Total <- NULL
    }
    # add N to column name
    colnames(final)[ncol(final)] <- sprintf(
      "%s (n=%g)",
      colnames(final)[ncol(final)],
      sum(as.vector(table(data[[group_by]])))
    )
    final
  } else {
    .generate_descriptive_table(data[variables], centrality, weights, digits, n)
  }

  class(out) <- c("report_sample", class(out))
  out
}


# helper ------------------------

.generate_descriptive_table <- function(x, centrality, weights, digits, n = FALSE) {
  if (!is.null(weights)) {
    w <- x[[weights]]
    columns <- setdiff(colnames(x), weights)
  } else {
    w <- NULL
    columns <- colnames(x)
  }

  do.call(rbind, lapply(columns, function(cn) {
    .report_sample_row(
      x[[cn]],
      column = cn,
      centrality = centrality,
      weights = w,
      digits = digits,
      n = n
    )
  }))
}


# create a "table row", i.e. a summary from a variable ------------------------

.report_sample_row <- function(x, digits = 1, ...) {
  UseMethod(".report_sample_row")
}

.report_sample_row.numeric <- function(x,
                                       column,
                                       centrality = "mean",
                                       weights = NULL,
                                       digits = 1,
                                       n = FALSE,
                                       ...) {

  n_stat <- ifelse(n, paste0(", ", sum(!is.na(x))), "")

  .summary <- if (centrality == "mean") {
    sprintf("%.*f (%.*f)%s", digits, .weighted_mean(x, weights), digits, .weighted_sd(x, weights), n_stat)
  } else {
    sprintf("%.*f (%.*f)%s", digits, .weighted_median(x, weights), digits, stats::mad(x, na.rm = TRUE), n_stat)
  }

  n.label <- ifelse(n, ", n", "")
  if (centrality == "mean") {
    column <- sprintf("Mean %s (SD)%s", column, n.label)
  } else {
    column <- sprintf("Median %s (MAD)%s", column, n.label)
  }

  out <- data.frame(
    Variable = column,
    Summary = .summary,
    stringsAsFactors = FALSE
  )

  # if(isTRUE(n)) {
  #   out$n <- sum(!is.na(x))
  # }

  out

}



.report_sample_row.factor <- function(x,
                                      column,
                                      weights = NULL,
                                      digits = 1,
                                      ...) {
  if (!is.null(weights)) {
    x[is.na(weights)] <- NA
    weights[is.na(x)] <- NA
    weights <- stats::na.omit(weights)
    x <- stats::na.omit(x)
    proportions <- prop.table(stats::xtabs(weights ~ x))
  } else {
    proportions <- prop.table(table(x))
  }

  # for binary factors, just need one level
  if (length(proportions) == 2) {
    proportions <- proportions[2]
  }
  .summary <- sapply(proportions, function(i) sprintf("%.1f", 100 * i))
  data.frame(
    Variable = sprintf("%s [%s], %%", column, names(.summary)),
    Summary = as.vector(.summary),
    stringsAsFactors = FALSE
  )
}


.report_sample_row.character <- .report_sample_row.factor



# print-method --------------------------------------------


#' @export
print.report_sample <- function(x, ...) {
  insight::print_colour("# Descriptive Statistics\n\n", "blue")
  cat(insight::export_table(x))
}



# helper for weighted stuff --------------------------


.weighted_variance <- function(x, weights = NULL) {
  if (is.null(weights)) {
    return(stats::var(x, na.rm = TRUE))
  }
  x[is.na(weights)] <- NA
  weights[is.na(x)] <- NA
  weights <- stats::na.omit(weights)
  x <- stats::na.omit(x)
  xbar <- sum(weights * x) / sum(weights)
  sum(weights * ((x - xbar)^2)) / (sum(weights) - 1)
}



.weighted_sd <- function(x, weights = NULL) {
  if (is.null(weights)) {
    return(stats::sd(x, na.rm = TRUE))
  }
  sqrt(.weighted_variance(x, weights))
}



.weighted_median <- function(x, weights = NULL, p = 0.5) {
  if (is.null(weights)) {
    return(stats::median(x, na.rm = TRUE))
  }
  x[is.na(weights)] <- NA
  weights[is.na(x)] <- NA
  weights <- stats::na.omit(weights)
  x <- stats::na.omit(x)
  order <- order(x)
  x <- x[order]
  weights <- weights[order]
  rw <- cumsum(weights) / sum(weights)
  md.values <- min(which(rw >= p))
  if (rw[md.values] == p) {
    mean(x[md.values:(md.values + 1)])
  } else {
    x[md.values]
  }
}



.weighted_mean <- function(x, weights = NULL) {
  if (is.null(weights)) {
    return(mean(x, na.rm = TRUE))
  }
  x[is.na(weights)] <- NA
  weights[is.na(x)] <- NA
  weights <- stats::na.omit(weights)
  x <- stats::na.omit(x)
  stats::weighted.mean(x, w = weights, na.rm = TRUE)
}
