#' Reporting Bayesian Models
#'
#' Create reports for Bayesian models. The description of the parameters follows
#' the Sequential Effect eXistence and sIgnificance Testing framework (see
#' [SEXIT documentation][bayestestR::sexit]).
#'
#' @inheritParams report.lm
#' @inherit report return seealso
#'
#' @examplesIf requireNamespace("rstanarm", quietly = TRUE)
#' \donttest{
#' # Bayesian models
#' library(rstanarm)
#' model <- suppressWarnings(stan_glm(mpg ~ qsec + wt, data = mtcars, refresh = 0, iter = 500))
#' r <- report(model)
#' r
#' summary(r)
#' as.data.frame(r)
#' }
#' @return An object of class [report()].
#' @include report.lm.R report.lme4.R
#' @export
report.stanreg <- function(x, ...) {
  table <- report_table(x, include_effectsize = FALSE, ...)
  report_text_result <- report_text(x, table = table, ...)

  as.report(report_text_result, table = table, ...)
}

#' @export
report_effectsize.stanreg <- report_effectsize.lm

#' @export
report_table.stanreg <- report_table.lm

#' @export
report_performance.stanreg <- report_performance.lm

#' @export
report_statistics.stanreg <- report_statistics.lm

#' @export
report_random.stanreg <- report_random.merMod

#' @export
report_model.stanreg <- report_model.lm

#' @export
report_text.stanreg <- report_text.lm


# ==================== Specific to Bayes ===================================


# report_priors -----------------------------------------------------------

#' @export
report_priors.stanreg <- function(x, ...) {
  params <- bayestestR::describe_prior(x)
  params <- params[params$Parameter != "(Intercept)", ]

  # Return empty if no priors info
  if (!"Prior_Distribution" %in% names(params) || nrow(params) == 0) {
    return("")
  }

  values <- ifelse(
    params$Prior_Distribution == "normal",
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

  values <- paste(values, collapse = "; ")
  values <- paste0(params$Prior_Distribution, " (", values, ")")

  if (length(unique(values)) == 1 && nrow(params) > 1) {
    priors_text <- paste0("all set as ", values[1])
  } else {
    priors_text <- paste0("set as ", values)
  }

  priors_text <- paste0("Priors over parameters were ", priors_text, " distributions")
  as.report_priors(priors_text)
}


# report_parameters -------------------------------------------------------


#' @export
report_parameters.stanreg <- function(x,
                                      include_intercept = TRUE,
                                      include_diagnostic = TRUE,
                                      ...) {
  # Get data
  sexit_data <- bayestestR::sexit(x, ...)

  att <- attributes(sexit_data)
  info <- paste0(att$sexit_info, " ", att$sexit_thresholds)

  params <- as.data.frame(sexit_data)

  # Parameters' names
  param_text <- .parameters_starting_text(x, params)

  # Replace parameters names
  for (i in seq_along(param_text)) {
    att$sexit_textlong[i] <- gsub(names(param_text)[i], param_text[i], att$sexit_textlong[i], fixed = TRUE)
    att$sexit_textshort[i] <- gsub(names(param_text)[i], param_text[i], att$sexit_textshort[i], fixed = TRUE)
  }

  # Include intercept
  if (isFALSE(include_intercept)) {
    idx <- params$Parameter != "(Intercept)"
  } else {
    idx <- rep(TRUE, nrow(params))
  }

  param_text <- att$sexit_textshort[idx]
  param_text_full <- att$sexit_textlong[idx]

  # remove NAs...
  param_text <- param_text[!is.na(param_text)]
  param_text_full <- param_text_full[!is.na(param_text_full)]

  # Diagnostic or Convergence
  if (include_diagnostic) {
    diagnostic <- bayestestR::diagnostic_posterior(x, ...)

    param.dgn <- .parameters_diagnostic_bayesian(diagnostic, only_when_insufficient = TRUE)[idx]
    param_text <- datawizard::text_paste(param_text, param.dgn, sep = ". ")

    param.dgn <- .parameters_diagnostic_bayesian(diagnostic, only_when_insufficient = FALSE)[idx]
    param_text_full <- datawizard::text_paste(param_text_full, param.dgn, sep = ". ")

    info <- paste(
      info,
      "Convergence and stability of the Bayesian sampling has been assessed using R-hat,",
      "which should be below 1.01 (Vehtari et al., 2019),",
      "and Effective Sample Size (ESS), which should be greater than 1000 (Burkner, 2017)."
    )
  }

  as.report_parameters(param_text_full, summary = param_text, parameters = sexit_data, info = info, ...)
}


# report_intercept --------------------------------------------------------


#' @export
report_intercept.stanreg <- function(x, ...) {
  posteriors <- insight::get_parameters(x)

  if (!("(Intercept)" %in% names(posteriors))) {
    return(as.report_intercept("", summary = "", ...))
  }
  
  intercept <- posteriors[["(Intercept)"]]

  intercept_data <- bayestestR::sexit(intercept, ...)

  endtext <- paste0(
    " is at ",
    insight::format_value(intercept_data$Median),
    " (",
    insight::format_ci(intercept_data$CI_low, intercept_data$CI_high, ci = intercept_data$CI),
    ")."
  )

  intercept_text <- paste0("The model's intercept", endtext)
  intercept_text_full <- paste0(
    "The model's intercept",
    .find_intercept(x),
    endtext
  )

  as.report_intercept(intercept_text_full, summary = intercept_text, ...)
}


# report_info -------------------------------------------------------------

#' @export
report_info.stanreg <- function(x, parameters = NULL, ...) {
  if (is.null(parameters)) {
    parameters <- report_parameters(x, ...)
  }

  info_text <- attributes(parameters)$info

  as.report_info(info_text)
}
