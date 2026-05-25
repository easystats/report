#' Reporting outlier detection results
#'
#' Create a brief textual report for outlier detection results from
#' [performance::check_outliers()].
#'
#' @param x Object of class `check_outliers` as returned by
#'   [performance::check_outliers()].
#' @inheritParams report
#'
#' @inherit report return seealso
#'
#' @examplesIf requireNamespace("performance", quietly = TRUE)
#' \donttest{
#' library(report)
#' library(performance)
#'
#' mt2 <- rbind(
#'   mtcars[, c("mpg", "disp", "hp")],
#'   data.frame(mpg = c(37, 40), disp = c(300, 400), hp = c(110, 120))
#' )
#' model <- lm(disp ~ mpg + hp, data = mt2)
#' rez <- performance::check_outliers(model)
#' report(rez)
#' }
#'
#' @return An object of class [report_text()].
#' @export
report_text.check_outliers <- function(x, ...) {
  n_outliers <- sum(x)
  n_total <- length(x)
  pct <- n_outliers / n_total

  methods <- attr(x, "method")
  thresholds <- attr(x, "threshold")

  method_labels <- .format_outlier_method_names(methods)

  method_parts <- vapply(
    seq_along(methods),
    function(i) {
      m <- methods[i]
      thresh <- thresholds[[m]]
      if (!is.null(thresh) && length(thresh) == 1L && !is.na(thresh)) {
        paste0(
          method_labels[i],
          " (threshold = ",
          insight::format_value(thresh, digits = 3),
          ")"
        )
      } else {
        method_labels[i]
      }
    },
    character(1L)
  )

  method_str <- paste(method_parts, collapse = " and ")

  if (n_outliers == 0L) {
    text <- "No observations were detected as potential outliers."
  } else if (n_outliers == 1L) {
    text <- paste0(
      "1 observation (",
      insight::format_value(pct, as_percent = TRUE),
      ") was detected as a potential outlier based on ",
      method_str,
      "."
    )
  } else {
    text <- paste0(
      n_outliers,
      " observations (",
      insight::format_value(pct, as_percent = TRUE),
      ") were detected as potential outliers based on ",
      method_str,
      "."
    )
  }

  as.report_text(text)
}


#' @rdname report_text.check_outliers
#' @export
report.check_outliers <- function(x, ...) {
  result_text <- report_text(x, ...)
  as.report(text = result_text, ...)
}


# Helper ------------------------------------------------------------------

.format_outlier_method_names <- function(methods) {
  method_map <- c(
    cook = "Cook's distance",
    mahalanobis = "Mahalanobis distance",
    mahalanobis_robust = "robust Mahalanobis distance",
    zscore = "z-score",
    zscore_robust = "robust z-score",
    iqr = "IQR",
    ci = "confidence intervals",
    optics = "OPTICS",
    iforest = "Isolation Forest",
    lof = "Local Outlier Factor",
    mcd = "MCD"
  )
  labels <- method_map[methods]
  # Fall back to the raw method name for any unknown method
  labels[is.na(labels)] <- methods[is.na(labels)]
  unname(labels)
}
