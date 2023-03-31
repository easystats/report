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
#' @param ci Level of confidence interval for relative frequencies (proportions).
#'   If not `NULL`, confidence intervals are shown for proportions of factor
#'   levels.
#' @param ci_method Character, indicating the method how to calculate confidence
#'   intervals for proportions. Currently implemented methods are `"wald"` and
#'   `"wilson"`. Note that `"wald"` can produce intervals outside the plausible
#'   range of \[0, 1\], and thus it is recommended to prefer the `"wilson"` method.
#'   The formulae for the confidence intervals are:
#' - `"wald"`:
#'
#'   \deqn{p \pm z \sqrt{\frac{p (1 - p)}{n}}}
#'
#' - `"wilson"`:
#'
#'   \deqn{\frac{2np + z^2 \pm z \sqrt{z^2 + 4npq}}{2(n + z^2)}}
#'
#'   where `p` is the proportion (of a factor level), `q` is `1-p`, `z` is the
#'   critical z-score based on the interval level and `n` is the length of the
#'   vector (cf. *Newcombe 1998*, *Wilson 1927*).
#' @param ci_correct Logical, it `TRUE`, applies continuity correction. See
#'   *Newcombe 1998* for different correction-methods based on the chosen
#'   `ci_method`.
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
#' @references
#' - Newcombe, R. G. (1998). Two-sided confidence intervals for the single
#'   proportion: comparison of seven methods. Statistics in Medicine. 17 (8):
#'   857–872
#'
#' - Wilson, E. B. (1927). Probable inference, the law of succession, and statistical
#'   inference. Journal of the American Statistical Association. 22 (158): 209–212
#'
#' @examples
#' library(report)
#'
#' report_sample(iris[, 1:4])
#' report_sample(iris, select = c("Sepal.Length", "Petal.Length", "Species"))
#' report_sample(iris, group_by = "Species")
#' report_sample(airquality, group_by = "Month", n = TRUE, total = FALSE)
#'
#' # confidence intervals for proportions
#' set.seed(123)
#' d <- data.frame(x = factor(sample(letters[1:3], 100, TRUE, c(0.01, 0.39, 0.6))))
#' report_sample(d, ci = 0.95, ci_method = "wald") # ups, negative CI
#' report_sample(d, ci = 0.95, ci_method = "wilson") # negative CI fixed
#' report_sample(d, ci = 0.95, ci_correct = TRUE) # continuity correction
#' @export
report_sample <- function(data,
                          group_by = NULL,
                          centrality = "mean",
                          ci = NULL,
                          ci_method = "wilson",
                          ci_correct = FALSE,
                          select = NULL,
                          exclude = NULL,
                          weights = NULL,
                          total = TRUE,
                          digits = 2,
                          n = FALSE,
                          ...) {
  # check for correct input type
  if (!is.data.frame(data)) {
    data <- tryCatch(
      as.data.frame(data, stringsAsFactors = FALSE),
      error = function(e) {
        insight::format_error("`data` must be a data frame, or an object that can be coerced to a data frame.")
      }
    )
  }

  variables <- colnames(data)

  # select all?
  if (is.null(select)) {
    select <- colnames(data)
  }

  # variables to keep
  if (!is.null(weights)) {
    select <- unique(c(select, weights))
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
      .generate_descriptive_table(
        x,
        centrality,
        weights,
        digits,
        n,
        ci,
        ci_method,
        ci_correct
      )
    })
    # remember values of first columns
    variable <- result[[1]]["Variable"]
    # number of observation, based on weights
    if (!is.null(weights)) {
      n_obs <- round(as.vector(stats::xtabs(data[[weights]] ~ data[[group_by]])))
    } else {
      n_obs <- as.vector(table(data[[group_by]]))
    }
    # column names for groups
    cn <- sprintf("%s (n=%g)", names(result), n_obs)
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
        n,
        ci,
        ci_method,
        ci_correct
      )[["Summary"]]
    )
    # Remove Total column if need be
    if (isFALSE(total)) {
      final$Total <- NULL
    }
    # define total N, based on weights
    if (!is.null(weights)) {
      total_n <- round(sum(as.vector(table(data[[group_by]]))) * mean(data[[weights]], na.rm = TRUE))
    } else {
      total_n <- sum(as.vector(table(data[[group_by]])))
    }
    # add N to column name
    colnames(final)[ncol(final)] <- sprintf(
      "%s (n=%g)",
      colnames(final)[ncol(final)],
      total_n
    )
    final
  } else {
    .generate_descriptive_table(
      data[variables],
      centrality,
      weights,
      digits,
      n,
      ci,
      ci_method,
      ci_correct
    )
  }

  attr(out, "weighted") <- !is.null(weights)
  class(out) <- c("report_sample", class(out))
  out
}


# helper ------------------------

.generate_descriptive_table <- function(x,
                                        centrality,
                                        weights,
                                        digits,
                                        n = FALSE,
                                        ci = NULL,
                                        ci_method = "wilson",
                                        ci_correct = FALSE) {
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
      n = n,
      ci = ci,
      ci_method = ci_method,
      ci_correct = ci_correct
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
    sprintf("%.*f (%.*f)%s", digits, .weighted_median(x, weights), digits, .weighted_mad(x, weights), n_stat)
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
                                      ci = NULL,
                                      ci_method = "wilson",
                                      ci_correct = FALSE,
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

  # CI for proportions?
  if (!is.null(ci)) {
    ci_low_high <- .ci_proportion(x, proportions, weights, ci, ci_method, ci_correct)
    .summary <- sprintf(
      "%.1f (%.1f, %.1f)",
      100 * proportions,
      100 * ci_low_high$ci_low,
      100 * ci_low_high$ci_high
    )
  } else {
    .summary <- sprintf("%.1f", 100 * proportions)
  }

  data.frame(
    Variable = sprintf("%s [%s], %%", column, names(proportions)),
    Summary = as.vector(.summary),
    stringsAsFactors = FALSE
  )
}


.report_sample_row.character <- .report_sample_row.factor



# Standard error for confidence interval of proportions ----

.ci_proportion <- function(x, proportions, weights, ci, ci_method, ci_correct) {
  ci_method <- match.arg(tolower(ci_method), c("wald", "wilson"))

  # variables
  p <- as.vector(proportions)
  q <- 1 - p
  n <- length(stats::na.omit(x))
  z <- stats::qnorm((1 + ci) / 2)

  ## FIXME: Once know how to do, calculate accurate SE for weighted data

  # There is a formula how to deal with SE for weighted data, see
  # https://en.wikipedia.org/wiki/Binomial_proportion_confidence_interval
  # but it seems "p" is unknown. For now, we give a warning instead of
  # estimating p for weighted data
  if (!is.null(weights)) {
    insight::format_warning("Confidence intervals are not accurate for weighted data.")
  }

  if (ci_method == "wilson") {
    # Wilson CIs -------------------
    if (isTRUE(ci_correct)) {
      ci_low <- (2 * n * p + z^2 - 1 - z * sqrt(z^2 - 2 - 1 / n + 4 * p * (n * q + 1))) / (2 * (n + z^2))
      ci_high <- (2 * n * p + z^2 + 1 + z * sqrt(z^2 + 2 - 1 / n + 4 * p * (n * q - 1))) / (2 * (n + z^2))
      # close to 0 or 1, then CI is 0 resp. 1
      fix <- p < 0.00001 | ci_low < 0.00001
      if (any(fix)) {
        ci_low[fix] <- 0
      }
      fix <- p > 0.99999 | ci_high > 0.99999
      if (any(fix)) {
        ci_high[fix] <- 1
      }
      out <- list(ci_low = ci_low, ci_high = ci_high)
    } else {
      prop <- (2 * n * p) + z^2
      moe <- z * sqrt(z^2 + 4 * n * p * q)
      correction <- 2 * (n + z^2)
      out <- list(
        ci_low = (prop - moe) / correction,
        ci_high = (prop + moe) / correction
      )
    }
  } else {
    # Wald CIs -------------------
    moe <- z * suppressWarnings(sqrt(p * q / n))
    if (isTRUE(ci_correct)) {
      moe <- moe + 1 / (2 * n)
    }
    out <- list(ci_low = p - moe, ci_high = p + moe)
  }
  out
}



# print-method --------------------------------------------

#' @export
print.report_sample <- function(x, ...) {
  if (isTRUE(attributes(x)$weighted)) {
    header <- "# Descriptive Statistics (weighted)\n\n"
  } else {
    header <- "# Descriptive Statistics\n\n"
  }
  insight::print_colour(header, "blue")
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


.weighted_mad <- function(x, weights = NULL, constant = 1.4826) {
  center <- .weighted_median(x, weights = weights)
  x <- abs(x - center)
  constant * .weighted_median(x, weights = weights)
}
