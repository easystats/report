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
  text <- report_text(x, table = table, ...)

  as.report(text, table = table, ...)
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

  values <- paste0(values, collapse = "; ")
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
report_parameters.stanreg <- function(x,
                                      include_intercept = TRUE,
                                      include_diagnostic = TRUE,
                                      ...) {
  # Get data
  data <- bayestestR::sexit(x, ...)

  att <- attributes(data)
  info <- paste0(att$sexit_info, " ", att$sexit_thresholds)

  params <- as.data.frame(data)

  # Parameters' names
  text <- .parameters_starting_text(x, params)

  # Replace parameters names
  for (i in seq_along(text)) {
    att$sexit_textlong[i] <- gsub(names(text)[i], text[i], att$sexit_textlong[i], fixed = TRUE)
    att$sexit_textshort[i] <- gsub(names(text)[i], text[i], att$sexit_textshort[i], fixed = TRUE)
  }

  # Include intercept
  if (isFALSE(include_intercept)) {
    idx <- !params$Parameter == "(Intercept)"
  } else {
    idx <- rep(TRUE, nrow(params))
  }

  text <- att$sexit_textshort[idx]
  text_full <- att$sexit_textlong[idx]

  # remove NAs...
  text <- text[!is.na(text)]
  text_full <- text_full[!is.na(text_full)]

  # Diagnostic / Convergence
  if (include_diagnostic) {
    diagnostic <- bayestestR::diagnostic_posterior(x, ...)

    param.dgn <- .parameters_diagnostic_bayesian(diagnostic, only_when_insufficient = TRUE)[idx]
    text <- datawizard::text_paste(text, param.dgn, sep = ". ")

    param.dgn <- .parameters_diagnostic_bayesian(diagnostic, only_when_insufficient = FALSE)[idx]
    text_full <- datawizard::text_paste(text_full, param.dgn, sep = ". ")

    info <- paste(
      info,
      "Convergence and stability of the Bayesian sampling has been assessed using R-hat,",
      "which should be below 1.01 (Vehtari et al., 2019),",
      "and Effective Sample Size (ESS), which should be greater than 1000 (Burkner, 2017)."
    )
  }

  as.report_parameters(text_full, summary = text, parameters = data, info = info, ...)
}


# report_intercept --------------------------------------------------------


#' @export
report_intercept.stanreg <- function(x, ...) {
  posteriors <- insight::get_parameters(x)

  if ("(Intercept)" %in% names(posteriors)) {
    intercept <- posteriors[["(Intercept)"]]
  } else {
    return(as.report_intercept("", summary = "", ...))
  }

  data <- bayestestR::sexit(intercept, ...)

  endtext <- paste0(
    " is at ",
    insight::format_value(data$Median),
    " (",
    insight::format_ci(data$CI_low, data$CI_high, ci = data$CI),
    ")."
  )

  text <- paste0("The model's intercept", endtext)
  text_full <- paste0(
    "The model's intercept",
    .find_intercept(x),
    endtext
  )

  as.report_intercept(text_full, summary = text, ...)
}


# report_info -------------------------------------------------------------

#' @export
report_info.stanreg <- function(x, parameters = NULL, ...) {
  if (is.null(parameters)) {
    parameters <- report_parameters(x, ...)
  }

  text <- attributes(parameters)$info

  as.report_info(text)
}
