#' Reporting Bayesian Models from brms
#'
#' Create reports for Bayesian models. The description of the parameters
#' follows the Sequential Effect eXistence and sIgnificance Testing framework
#' (see [SEXIT documentation][bayestestR::sexit]).
#'
#' @inheritParams report.lm
#' @inherit report return seealso
#'
#' @examplesIf requireNamespace("brms", quietly = TRUE) && packageVersion("rstan") >= "2.26.0"
#' \dontrun{
#' # Bayesian models
#' library(brms)
#' model <- suppressWarnings(brm(mpg ~ qsec + wt, data = mtcars, refresh = 0, iter = 300))
#' r <- report(model, verbose = FALSE)
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#' }
#' @return An object of class [report()].
#' @include report.lm.R report.stanreg.R report.lme4.R
#' @export
report.brmsfit <- function(x, ...) {
  table <- report_table(x, include_effectsize = FALSE, ...)
  text <- report_text(x, table = table, ...)

  as.report(text, table = table, ...)
}

#' @export
report_effectsize.brmsfit <- report_effectsize.lm

#' @export
report_table.brmsfit <- report_table.lm

#' @export
report_performance.brmsfit <- report_performance.lm

#' @export
report_statistics.brmsfit <- report_statistics.lm

#' @export
report_random.brmsfit <- report_random.merMod

#' @export
report_model.brmsfit <- report_model.lm

#' @export
report_text.brmsfit <- report_text.lm


# ==================== Specific to Bayes ===================================



# report_priors -----------------------------------------------------------

#' @export
report_priors.brmsfit <- function(x, ...) {
  params <- bayestestR::describe_prior(x)
  params <- params[params$Parameter != "(Intercept)", ]

  # Return empty if no priors info
  if (!"Prior_Distribution" %in% names(params) ||
    nrow(params) == 0 ||
    all(is.na(params$Prior_Scale))) {
    return("")
  }

  values <- ifelse(params$Prior_Distribution == "normal",
    paste0(
      "mean = ",
      insight::format_value(params$Prior_Location),
      ", SD = ",
      insight::format_value(params$Prior_Scale)
    ),
    paste0(
      "location = ",
      insight::format_value(params$Prior_Location),
      ", scale = ",
      insight::format_value(params$Prior_Scale)
    )
  )

  values <- paste0(params$Prior_Distribution, " (", values, ")")

  if (length(unique(values)) == 1 && nrow(params) > 1) {
    text <- paste0("all set as ", values[1])
  } else {
    text <- paste0("set as ", values)
  }

  text <- paste0("Priors over parameters were ", text, " distributions")
  as.report_priors(text)
}


# report_parameters -------------------------------------------------------

#' @export
report_parameters.brmsfit <- report_parameters.stanreg

# report_intercept --------------------------------------------------------

#' @export
report_intercept.brmsfit <- report_intercept.stanreg

# report_info -------------------------------------------------------------

#' @export
report_info.brmsfit <- report_info.stanreg
