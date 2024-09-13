#' Reporting Bayesian Model Comparison
#'
#' Automatically report the results of Bayesian model comparison using the `loo` package.
#'
#' @param x An object of class [brms::loo_compare].
#' @param include_IC Whether to include the information criteria (IC).
#' @param include_ENP Whether to include the effective number of parameters (ENP).
#' @param ... Additional arguments (not used for now).
#'
#' @examplesIf requireNamespace("brms", quietly = TRUE) && requireNamespace)(RcppEigen) && requireNamespace)(BH)
#' \donttest{
#' library(brms)
#'
#' m1 <- brms::brm(mpg ~ qsec, data = mtcars)
#' m2 <- brms::brm(mpg ~ qsec + drat, data = mtcars)
#' m3 <- brms::brm(mpg ~ qsec + drat + wt, data = mtcars)
#'
#' x <- brms::loo_compare(
#'   brms::add_criterion(m1, "loo"),
#'   brms::add_criterion(m2, "loo"),
#'   brms::add_criterion(m3, "loo"),
#'   model_names = c("m1", "m2", "m3")
#' )
#' report(x)
#' report(x, include_IC = FALSE)
#' report(x, include_ENP = TRUE)
#' }
#'
#' @details
#' The rule of thumb is that the models are "very similar" if |elpd_diff| (the
#' absolute value of elpd_diff) is less than 4 (Sivula, Magnusson and Vehtari, 2020).
#' If superior to 4, then one can use the SE to obtain a standardized difference
#' (Z-diff) and interpret it as such, assuming that the difference is normally
#' distributed. The corresponding p-value is then calculated as `2 * pnorm(-abs(Z-diff))`.
#' However, note that if the raw ELPD difference is small (less than 4), it doesn't
#' make much sense to rely on its standardized value: it is not very useful to
#' conclude that a model is much better than another if both models make very
#' similar predictions.
#'
#' @return Objects of class [report_text()].
#' @export
report.compare.loo <- function(x, include_IC = TRUE, include_ENP = FALSE, ...) {
  # nolint start
  # https://stats.stackexchange.com/questions/608881/how-to-interpret-elpd-diff-of-bayesian-loo-estimate-in-bayesian-logistic-regress
  # nolint end
  # https://users.aalto.fi/%7Eave/CV-FAQ.html#12_What_is_the_interpretation_of_ELPD__elpd_loo__elpd_diff
  # https://users.aalto.fi/%7Eave/CV-FAQ.html#se_diff

  # The difference in expected log predictive density (elpd) between each model
  # and the best model as well as the standard error of this difference (assuming
  # the difference is approximately normal).

  # The values in the first row are 0s because the models are ordered from best to worst according to their elpd.
  x <- as.data.frame(x)
  modnames <- rownames(x)

  elpd_diff <- x[["elpd_diff"]]
  se_elpd_diff <- x[["se_diff"]]
  ic_diff <- -2 * elpd_diff

  z_elpd_diff <- elpd_diff / se_elpd_diff
  p_elpd_diff <- 2 * stats::pnorm(-abs(z_elpd_diff))
  z_ic_diff <- -z_elpd_diff

  if ("looic" %in% colnames(x)) {
    elpd <- x[["elpd_loo"]]
    enp <- x[["p_loo"]]
    index_label <- "ELPD-LOO"
    ic <- x[["looic"]]
    index_ic <- "LOOIC"
  } else {
    elpd <- x[["elpd_waic"]]
    enp <- x[["p_waic"]]
    index_label <- "ELPD-WAIC"
    ic <- x[["waic"]]
    index_ic <- "WAIC"
  }

  # TODO: The above indices-computation and name-matching should be implemented
  # in a parameters.compare.loo() function which would be run here.

  # Starting text -----
  text1 <- sprintf(
    paste0(
      "The difference in predictive accuracy, as indexed by Expected Log ",
      "Predictive Density (%s), suggests that '%s' is the best model ("
    ),
    index_label, modnames[1]
  )
  if (all(c(include_IC, include_ENP))) {
    if (include_IC) {
      text1 <- sprintf(paste0(text1, "%s = %.2f"), index_ic, ic[1])
    }
    if (include_ENP) {
      if (include_IC) {
        text1 <- sprintf(paste0(text1, ", ENP = %.2f)"), enp[1])
      } else {
        text1 <- sprintf(paste0(text1, "ENP = %.2f)"), enp[1])
      }
    } else {
      text1 <- paste0(text1, ")")
    }
  } else {
    text1 <- sprintf(paste0(text1, "ELPD = %.2f)"), elpd[1])
  }

  # Other models ---
  text_models <- sprintf(
    "'%s' (diff-ELPD = %.2f +- %.2f, %s",
    modnames[-1],
    elpd_diff[-1],
    se_elpd_diff[-1],
    insight::format_p(p_elpd_diff[-1])
  )

  if (all(c(include_IC, include_ENP))) {
    if (include_IC) {
      text_models <- sprintf(paste0(text_models, ", %s = %.2f"), index_ic, ic[-1])
    }
    if (include_ENP) {
      if (include_IC) {
        text_models <- sprintf(paste0(text_models, ", ENP = %.2f)"), enp[-1])
      } else {
        text_models <- sprintf(paste0(text_models, "ENP = %.2f)"), enp[-1])
      }
    } else {
      text_models <- sprintf(paste0(text_models, ")"))
    }
  } else {
    text_models <- paste0(text_models, ")")
  }


  text1 <- paste0(text1, ", followed by ", datawizard::text_concatenate(text_models))
  class(text1) <- c("report_text", class(text1))
  text1
}
