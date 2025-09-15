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
#' model <- suppressWarnings(brm(mpg ~ qsec + wt,
#'   data = mtcars,
#'   refresh = 0, iter = 300
#' ))
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
  tbl <- report_table(x, include_effectsize = FALSE, ...)
  txt <- report_text(x, table = tbl, ...)

  as.report(txt, table = tbl, ...)
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

  # Return empty if no priors info
  has_no_prior_information <- (!"Prior_Distribution" %in% names(params)) ||
    nrow(params) == 0L ||
    all(is.na(params$Prior_Scale))

  if (has_no_prior_information) {
    return("")
  }

  # Filter out priors with missing/empty information (both location and
  # scale are NA). This removes uninformative default priors that shouldn't
  # be reported
  valid_priors <- !is.na(params$Prior_Location) |
    !is.na(params$Prior_Scale)
  params <- params[valid_priors, ]

  # Return empty if no valid priors remain after filtering
  if (nrow(params) == 0L) {
    return("")
  }

  # Create enhanced prior descriptions with parameter information
  prior_descriptions <- vector("character", length = 0L)

  # Group parameters by type for cleaner reporting
  intercept_params <- params[params$Parameter == "(Intercept)", ]
  slope_params <- params[params$Parameter != "(Intercept)" &
    !grepl("^(sigma|sd_|cor_)", params$Parameter), ]
  scale_params <- params[grepl("^(sigma|sd_)", params$Parameter), ]

  # Helper function to format individual priors with mathematical notation
  format_prior <- function(prior_row) {
    prior_dist <- prior_row$Prior_Distribution
    prior_loc <- insight::format_value(prior_row$Prior_Location)
    prior_scale <- insight::format_value(prior_row$Prior_Scale)
    prior_df <- if (!is.null(prior_row$Prior_df) && !is.na(prior_row$Prior_df)) {
      paste0("df = ", insight::format_value(prior_row$Prior_df), ", ")
    } else {
      ""
    }

    if (prior_dist == "normal") {
      paste0("Normal(", prior_df, "\u03bc = ", prior_loc, ", \u03c3 = ", prior_scale, ")")
    } else if (prior_dist == "student_t") {
      paste0("Student-t(", prior_df, "\u03bc = ", prior_loc, ", \u03c3 = ", prior_scale, ")")
    } else {
      # Fallback for other distributions
      paste0(
        tools::toTitleCase(prior_dist), "(", prior_df,
        "location = ", prior_loc, ", scale = ", prior_scale, ")"
      )
    }
  }

  # Process intercept parameters
  if (nrow(intercept_params) > 0) {
    intercept_desc <- sapply(seq_len(nrow(intercept_params)), function(i) {
      format_prior(intercept_params[i, ])
    })
    if (length(unique(intercept_desc)) == 1L) {
      prior_descriptions <- c(
        prior_descriptions,
        paste0("Intercept ~ ", intercept_desc[1])
      )
    } else {
      prior_descriptions <- c(
        prior_descriptions,
        paste0("Intercepts ~ ", datawizard::text_concatenate(intercept_desc))
      )
    }
  }

  # Process slope parameters
  if (nrow(slope_params) > 0) {
    slope_names <- slope_params$Parameter
    slope_desc <- sapply(seq_len(nrow(slope_params)), function(i) {
      format_prior(slope_params[i, ])
    })

    if (length(unique(slope_desc)) == 1L) {
      # All slopes have the same prior
      param_list <- if (length(slope_names) > 1) {
        paste0("(", datawizard::text_concatenate(slope_names), ")")
      } else {
        paste0("(", slope_names, ")")
      }
      prior_descriptions <- c(
        prior_descriptions,
        paste0("Slopes ", param_list, " ~ ", slope_desc[1])
      )
    } else {
      # Different priors for different slopes
      individual_slopes <- paste0(slope_names, " ~ ", slope_desc)
      prior_descriptions <- c(
        prior_descriptions,
        datawizard::text_concatenate(individual_slopes)
      )
    }
  }

  # Process scale/sigma parameters
  if (nrow(scale_params) > 0) {
    scale_desc <- sapply(seq_len(nrow(scale_params)), function(i) {
      prior_row <- scale_params[i, ]
      desc <- format_prior(prior_row)
      # Add + notation for positive-only distributions when appropriate
      if (grepl("sigma|sd", prior_row$Parameter) && prior_row$Prior_Location >= 0) {
        desc <- gsub("Student-t(", "Student-t\u207a(", desc, fixed = TRUE)
        desc <- gsub("Normal(", "Normal\u207a(", desc, fixed = TRUE)
      }
      desc
    })

    if (length(unique(scale_desc)) == 1L && nrow(scale_params) > 1L) {
      prior_descriptions <- c(
        prior_descriptions,
        paste0("Residual SD (\u03c3) ~ ", scale_desc[1])
      )
    } else {
      scale_names <- gsub("sigma", "\u03c3", scale_params$Parameter, fixed = TRUE)
      individual_scales <- paste0(scale_names, " ~ ", scale_desc)
      prior_descriptions <- c(
        prior_descriptions,
        datawizard::text_concatenate(individual_scales)
      )
    }
  }

  # Combine all descriptions
  if (length(prior_descriptions) > 0) {
    report_text <- paste0(
      "Priors were: ",
      datawizard::text_concatenate(
        prior_descriptions,
        sep = "; ",
        last = "; "
      ),
      "."
    )
  } else {
    report_text <- ""
  }

  as.report_priors(report_text)
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
