#' Reporting Bayesian Model Comparison
#'
#' Automatically report the results of Bayesian model comparison using the `loo` package.
#'
#' @param x An object of class [brms::loo_compare].
#' @param index type if index to report - expected log pointwise predictive
#'   density (ELPD) or information criteria (IC).
#' @param ... Additional arguments (not used for now).
#'
#' @examplesIf require("brms", quietly = TRUE)
#' \donttest{
#' library(brms)
#'
#' m1 <- brms::brm(mpg ~ qsec, data = mtcars)
#' m2 <- brms::brm(mpg ~ qsec + drat, data = mtcars)
#'
#' x <- brms::loo_compare(brms::add_criterion(m1, "loo"),
#'   brms::add_criterion(m2, "loo"),
#'   model_names = c("m1", "m2")
#' )
#' report(x)
#' }
#'
#' @details
#' The rule of thumb is that the models are "very similar" if |elpd_diff| (the
#' absolute value of elpd_diff) is less than 4 (Sivula, Magnusson and Vehtari, 2020).
#' If superior to 4, then one can use the SE to obtain a standardized difference
#' (Z-diff) and interpret it as such, assuming that the difference is normally
#' distributed.
#'
#' @return Objects of class [report_text()].
#' @export
report.compare.loo <- function(x, index = c("ELPD", "IC"), ...) {
  # nolint start
  # https://stats.stackexchange.com/questions/608881/how-to-interpret-elpd-diff-of-bayesian-loo-estimate-in-bayesian-logistic-regress
  # nolint end
  # https://users.aalto.fi/%7Eave/CV-FAQ.html#12_What_is_the_interpretation_of_ELPD__elpd_loo__elpd_diff
  # https://users.aalto.fi/%7Eave/CV-FAQ.html#se_diff

  # The difference in expected log predictive density (elpd) between each model
  # and the best model as well as the standard error of this difference (assuming
  # the difference is approximately normal).
  index <- match.arg(index)
  x <- as.data.frame(x)
  # The values in the first row are 0s because the models are ordered from best to worst according to their elpd.
  modnames <- rownames(x)

  elpd_diff <- x[["elpd_diff"]]
  ic_diff <- -2 * elpd_diff

  z_elpd_diff <- elpd_diff / x[["se_diff"]]
  z_ic_diff <- -z_elpd_diff

  if ("looic" %in% colnames(x)) {
    type <- "LOO"
    ENP <- x[["p_loo"]]
  } else {
    type <- "WAIC"
    ENP <- x[["p_waic"]]
  }

  if (index == "ELPD") {
    index_label <- sprintf("Expected Log Predictive Density (ELPD-%s)", type)
  } else if (type == "LOO") {
    index_label <- "Leave-One-Out CV Information Criterion (LOOIC)"
  } else {
    index_label <- "Widely Applicable Information Criterion (WAIC)"
  }

  out_text <- sprintf(
    paste(
      "The difference in predictive accuracy, as index by %s, suggests that '%s' ",
      "is the best model (effective number of parameters (ENP) = %.2f), followed by"
    ),
    index_label, modnames[1], ENP[1]
  )

  if (index == "ELPD") {
    other_texts <- sprintf(
      "'%s' (diff = %.2f, ENP = %.2f, z-diff = %.2f)",
      modnames[-1],
      elpd_diff[-1],
      ENP[-1],
      z_elpd_diff[-1]
    )
  } else {
    other_texts <- sprintf(
      "'%s' (diff = %.2f, ENP = %.2f, z-diff = %.2f)",
      modnames[-1],
      ic_diff[-1],
      ENP[-1],
      z_ic_diff[-1]
    )
  }

  sep <- "."
  nothermods <- length(other_texts)
  if (nothermods > 1L) {
    if (nothermods == 2L) {
      sep <- c(" and ", sep)
    } else {
      sep <- c(rep(", ", length = nothermods - 2), ", and ", sep)
    }
  }

  other_texts <- paste0(other_texts, sep, collapse = "")

  out_text <- paste(out_text, other_texts, collapse = "")
  class(text) <- c("report_text", class(text))
  out_text
}
