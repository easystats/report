#' Reporting Bayesian Model Comparison
#'
#' Automatically report the results of Bayesian model comparison using the `loo` package.
#'
#' @param x An object of class [loo_compare()].
#'
#' @examplesIf require("brms", quietly = TRUE)
#' \donttest{
#' library(brms)
#'
#' m1 <- brms::brm(mpg ~ qsec, data=mtcars)
#' m2 <- brms::brm(mpg ~ qsec + drat, data=mtcars)
#'
#' x <- brms::loo_compare(brms::add_criterion(m1, "loo"),
#'                        brms::add_criterion(m2, "loo"),
#'                        model_names=c("m1", "m2"))
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
report.compare.loo <- function(x, ...) {
  # https://stats.stackexchange.com/questions/608881/how-to-interpret-elpd-diff-of-bayesian-loo-estimate-in-bayesian-logistic-regress
  # https://users.aalto.fi/%7Eave/CV-FAQ.html#12_What_is_the_interpretation_of_ELPD__elpd_loo__elpd_diff
  # https://users.aalto.fi/%7Eave/CV-FAQ.html#se_diff

  # The difference in expected log predictive density (elpd) between each model
  # and the best model as well as the standard error of this difference (assuming
  # the difference is approximately normal).
  x <- as.data.frame(x)
  # The values in the first row are 0s because the models are ordered from best to worst according to their elpd.
  modnames <- rownames(x)

  #
  z_elpd_diff <- x$elpd_diff / x$se_diff

  text <- "The difference in predictive accuracy, as index by Expected Log Predictive Density (ELPD), suggests that '"
  text <- paste0(text, modnames[1], "' is the best model, followed by '")

  for (m in 2:(nrow(x))) {
    text <- paste0(text, modnames[m ],
                   "' (diff = ",
                   insight::format_value(x$elpd_diff[m]),
                   # " ± ",
                   # insight::format_value(x$se_diff[m]),
                   ", Z-diff = ",
                   insight::format_value(z_elpd_diff[m]),
                   ")")
  }
  class(text) <- c("report_text", class(text))
  text
}