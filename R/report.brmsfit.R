#' Reporting Bayesian Models from brms
#'
#' Create reports for Bayesian models. The description of the parameters
#' follows the Sequential Effect eXistence and sIgnificance Testing framework
#' (see [SEXIT documentation][bayestestR::sexit]).
#'
#' @inheritParams report.lm
#' @inherit report return seealso
#'
#' @examplesIf require("brms", quietly = TRUE)
#' \donttest{
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

  # Create the report object
  result <- as.report(text, table = table, ...)
  
  # Add a flag to track that this is a brmsfit report to prevent duplication
  attr(result, "model_class") <- "brmsfit"
  
  result
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
report_text.brmsfit <- function(x, table = NULL, ...) {
  # For brmsfit objects, ensure proper text assembly without duplication
  # The issue occurs when brms-specific methods create text that conflicts
  # with the lm-based text assembly pipeline
  
  params <- report_parameters(x, table = table, include_intercept = FALSE, ...)
  table <- attributes(params)$table

  info <- report_info(x, effectsize = attributes(params)$effectsize, parameters = params, ...)
  model <- report_model(x, table = table, ...)
  perf <- report_performance(x, table = table, ...)
  intercept <- report_intercept(x, table = table, ...)

  if (suppressWarnings(insight::is_nullmodel(x))) {
    params_text_full <- params_text <- ""
  } else {
    # Convert parameters to character once to avoid multiple conversions
    # that might cause duplication in brms processing
    params_char <- as.character(params)
    params_summary_char <- as.character(summary(params))
    
    params_text_full <- paste0(" Within this model:\n\n", params_char)
    params_text <- paste0(" Within this model:\n\n", params_summary_char)
  }

  text_full <- paste0(
    "We fitted a ",
    model,
    ". ",
    perf,
    ifelse(nzchar(perf, keepNA = TRUE), ". ", ""),
    intercept,
    params_text_full,
    "\n\n",
    info
  )

  summary_text <- paste0(
    "We fitted a ",
    summary(model),
    ". ",
    summary(perf),
    ifelse(nzchar(perf, keepNA = TRUE), ". ", ""),
    summary(intercept),
    params_text
  )

  as.report_text(text_full, summary = summary_text)
}


# ==================== Specific to Bayes ===================================


# report_priors -----------------------------------------------------------

#' @export
report_priors.brmsfit <- function(x, ...) {
  params <- bayestestR::describe_prior(x)
  params <- params[params$Parameter != "(Intercept)", ]

  # Return empty if no priors info
  has_no_prior_information <- (!"Prior_Distribution" %in% names(params)) ||
    nrow(params) == 0L ||
    all(is.na(params$Prior_Scale))

  if (has_no_prior_information) {
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

  if (length(unique(values)) == 1L && nrow(params) > 1L) {
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
