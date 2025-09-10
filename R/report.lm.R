#' Reporting (General) Linear Models
#'
#' Create reports for (general) linear models.
#'
#' @param x Object of class `lm` or `glm`.
#' @param include_effectsize If `FALSE`, won't include effect-size related
#'   indices (standardized coefficients, etc.).
#' @param include_diagnostic If `FALSE`, won't include diagnostic related
#'   indices for Bayesian models (ESS, Rhat).
#' @param include_intercept If `FALSE`, won't include the intercept.
#' @param effectsize_method See documentation for
#'   [effectsize::effectsize()].
#' @param parameters Provide the output of `report_parameters()` to avoid
#'   its re-computation.
#' @inheritParams report
#' @inheritParams report.htest
#'
#' @inherit report return seealso
#'
#' @examples
#' \donttest{
#' library(report)
#'
#' # Linear models
#' model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' r <- report(model)
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#'
#' # Logistic models
#' model <- glm(vs ~ disp, data = mtcars, family = "binomial")
#' r <- report(model)
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#' }
#'
#' @examplesIf requireNamespace("lme4", quietly = TRUE)
#' \donttest{
#' # Mixed models
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' r <- report(model)
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#' }
#' @return An object of class [report()].
#' @export
report.lm <- function(
  x,
  include_effectsize = TRUE,
  effectsize_method = "refit",
  ...
) {
  result_table <- report_table(
    x,
    include_effectsize = include_effectsize,
    effectsize_method = effectsize_method,
    ...
  )
  result_text <- report_text(x, table = result_table, ...)

  as.report(result_text, table = result_table, ...)
}


# report_effectsize -------------------------------------------------------

#' @rdname report.lm
#' @export

report_effectsize.lm <- function(x, effectsize_method = "refit", ...) {
  effect_table <- suppressWarnings(effectsize::effectsize(
    x,
    method = effectsize_method,
    ...
  ))
  method <- .text_standardize(effect_table)
  estimate <- names(effect_table)[effectsize::is_effectsize_name(names(
    effect_table
  ))]

  # TODO: finally solve this.
  # interpret <- effectsize::interpret_parameters(x, ...)
  if (insight::model_info(x)$is_logit) {
    interpret <- effectsize::interpret_oddsratio(
      effect_table[[estimate]],
      log = TRUE,
      ...
    )
  } else {
    interpret <- effectsize::interpret_cohens_d(effect_table[[estimate]], ...)
  }

  interpretation <- interpret
  main <- paste0(
    "Std. beta = ",
    insight::format_value(effect_table[[estimate]])
  )

  ci <- effect_table$CI
  names(ci) <- paste0("ci_", estimate)

  statistics <- paste0(
    main,
    ", ",
    insight::format_ci(effect_table$CI_low, effect_table$CI_high, ci)
  )

  if ("Component" %in% colnames(effect_table)) {
    merge_by <- c("Parameter", "Component")
    start_col <- 4L
  } else {
    merge_by <- "Parameter"
    start_col <- 3L
  }

  effect_table <- as.data.frame(effect_table)[c(
    merge_by,
    estimate,
    "CI_low",
    "CI_high"
  )]
  names(effect_table)[start_col:ncol(effect_table)] <- c(
    paste0(estimate, "_CI_low"),
    paste0(estimate, "_CI_high")
  )

  rules <- .text_effectsize(attr(attr(interpret, "rules"), "rule_name"))
  parameters <- paste0(interpretation, " (", statistics, ")")

  as.report_effectsize(
    parameters,
    summary = parameters,
    table = effect_table,
    interpretation = interpretation,
    statistics = statistics,
    rules = rules,
    ci = ci,
    method = method,
    main = main
  )
}


# report_table ------------------------------------------------------------

#' @rdname report.lm
#' @include utils_combine_tables.R
#' @export
report_table.lm <- function(x, include_effectsize = TRUE, ...) {
  params <- parameters::model_parameters(x, ci_random = FALSE, ...)

  # Combine -----
  # Add effectsize
  if (include_effectsize) {
    effsize <- report_effectsize(x, ...)
    params <- .combine_tables_effectsize(params, effsize)
  } else {
    effsize <- NULL
  }

  # Add performance
  performance <- performance::model_performance(x, ...)
  params <- .combine_tables_performance(params, performance)
  params <- params[
    !tolower(params$Parameter) %in%
      c(
        "rmse", # lm
        "logloss",
        "score_log",
        "score_spherical",
        "pcp", # glm
        "icc", # lmer
        "elpd_se",
        "looic_se" # stanreg
      ),
  ]

  # Clean -----
  # Rename some columns
  # names(table_full) <- gsub("Coefficient", "beta", names(table_full))

  # Shorten ----
  if (insight::model_info(x)$is_logit) {
    params <- datawizard::data_remove(params, "df_error")
  }
  table_full <- datawizard::data_remove(params, "SE")
  params_table <- datawizard::data_remove(
    table_full,
    select = "(_CI_low|_CI_high)$",
    regex = TRUE,
    verbose = FALSE
  )
  params_table <- params_table[
    !params_table$Parameter %in% c("AIC", "BIC", "ELPD", "LOOIC", "WAIC"),
  ]

  # Prepare -----
  out <- as.report_table(
    table_full,
    summary = params_table,
    effsize = effsize,
    performance = performance,
    ...
  )
  if (!is.null(effsize)) {
    attr(out, paste0(names(attributes(effsize)$ci))) <- attributes(effsize)$ci
  }
  # Add attributes from params table
  for (att in c(
    "ci",
    "coefficient_name",
    "pretty_names",
    "bootstrap",
    "iterations",
    "ci_method"
  )) {
    attr(out, att) <- attributes(params)[[att]]
  }

  out
}


# report_statistics ------------------------------------------------------------

#' @rdname report.lm
#' @export
report_statistics.lm <- function(
  x,
  table = NULL,
  include_effectsize = TRUE,
  include_diagnostic = TRUE,
  ...
) {
  if (is.null(table)) {
    params_table <- report_table(x, ...)
  } else {
    params_table <- table
  }
  params_table <- .remove_performance(params_table)
  effsize <- attributes(params_table)$effsize

  # For glmmTMB models with multiple components, don't filter the table itself
  # but prepare effectsize alignment for text generation

  # Estimate
  estimate <- .find_regression_estimate(params_table)
  if (
    is.null(estimate) || is.na(estimate) || !estimate %in% names(params_table)
  ) {
    estimate_text <- ""
  } else if (estimate == "Coefficient") {
    estimate_text <- paste0(
      "beta = ",
      insight::format_value(params_table[[estimate]])
    )
  } else {
    estimate_text <- paste0(
      estimate,
      " = ",
      insight::format_value(params_table[[estimate]])
    )
  }

  # CI
  if (!is.null(params_table$CI_low)) {
    estimate_text <- datawizard::text_paste(
      estimate_text,
      insight::format_ci(
        params_table$CI_low,
        params_table$CI_high,
        ci = attributes(params_table)$ci
      )
    )
  }

  # Statistic
  if ("t" %in% names(params_table)) {
    estimate_text <- datawizard::text_paste(
      estimate_text,
      paste0(
        "t(",
        insight::format_value(
          params_table$df,
          protect_integers = TRUE
        ),
        ") = ",
        insight::format_value(params_table$t)
      )
    )
  }

  # p-value
  if ("p" %in% names(params_table)) {
    estimate_text <- datawizard::text_paste(
      estimate_text,
      insight::format_p(params_table$p, stars = FALSE, digits = "apa")
    )
  }

  # pd
  if ("pd" %in% names(params_table)) {
    estimate_text <- datawizard::text_paste(
      estimate_text,
      insight::format_pd(params_table$pd, stars = FALSE)
    )
  }

  # BF
  if ("ROPE_Percentage" %in% names(params_table)) {
    estimate_text <- datawizard::text_paste(
      estimate_text,
      insight::format_rope(params_table$ROPE_Percentage)
    )
  }

  # BF
  if ("BF" %in% names(params_table)) {
    estimate_text <- datawizard::text_paste(
      estimate_text,
      insight::format_bf(params_table$BF, stars = FALSE, exact = TRUE)
    )
  }

  # Effect size
  if (include_effectsize && !is.null(effsize)) {
    # For glmmTMB models with components, align effectsize with the table parameters
    if (inherits(x, "glmmTMB") && "Component" %in% colnames(params_table)) {
      # Find matching indices between table and effectsize
      effsize_table <- attributes(effsize)$table

      # Create matching vectors for both table and effectsize
      table_keys <- paste(params_table$Parameter, params_table$Component)
      effsize_keys <- paste(effsize_table$Parameter, effsize_table$Component)

      # Find which effectsize entries match table entries
      match_idx <- match(table_keys, effsize_keys)

      # Use only the matched effectsize elements, fill missing with empty strings
      n_params <- nrow(params_table)
      effsize_stats <- character(n_params)
      effsize_main <- character(n_params)

      for (i in seq_len(n_params)) {
        if (is.na(match_idx[i])) {
          effsize_stats[i] <- ""
          effsize_main[i] <- ""
        } else {
          effsize_stats[i] <- attributes(effsize)$statistics[match_idx[i]]
          effsize_main[i] <- attributes(effsize)$main[match_idx[i]]
        }
      }
    } else {
      effsize_stats <- attributes(effsize)$statistics
      effsize_main <- attributes(effsize)$main
    }

    # Only include non-empty effectsize information
    has_effectsize <- !is.na(effsize_stats) & effsize_stats != ""
    text_full <- ifelse(
      has_effectsize,
      datawizard::text_paste(estimate_text, effsize_stats, sep = "; "),
      estimate_text
    )
    estimate_text <- ifelse(
      has_effectsize,
      datawizard::text_paste(estimate_text, effsize_main),
      estimate_text
    )
  } else {
    text_full <- estimate_text
  }

  # Quality / Diagnostic
  if (include_diagnostic) {
    text_diagnostic <- ""

    if ("Rhat" %in% names(params_table)) {
      text_diagnostic <- paste0(
        "Rhat = ",
        insight::format_value(params_table$Rhat)
      )
    }

    estimate_text <- datawizard::text_paste(estimate_text, text_diagnostic)

    if ("ESS" %in% names(params_table)) {
      text_diagnostic <- datawizard::text_paste(
        text_diagnostic,
        paste0("ESS = ", insight::format_value(params_table$ESS))
      )
    }

    text_full <- datawizard::text_paste(text_full, text_diagnostic, sep = "; ")
  }

  as.report_statistics(
    text_full,
    summary = estimate_text,
    table = params_table,
    effsize = effsize
  )
}


# report_statistics ------------------------------------------------------------

#' @rdname report.lm
#' @inheritParams report_statistics
#' @export
report_parameters.lm <- function(
  x,
  table = NULL,
  include_effectsize = TRUE,
  include_intercept = TRUE,
  ...
) {
  # Get data
  stats <- report_statistics(
    x,
    table = table,
    include_effectsize = include_effectsize,
    ...
  )
  params <- attributes(stats)$table
  effsize <- attributes(stats)$effsize

  # For glmmTMB models, deduplicate parameters table to prevent repeated output
  # This fixes the issue where same parameter appears multiple times in the report
  if (inherits(x, "glmmTMB")) {
    # Check if we have duplicated parameters (could be due to Component structure or other reasons)
    if ("Component" %in% colnames(params)) {
      # Deduplicate based on Parameter and Component combination
      unique_idx <- !duplicated(paste(params$Parameter, params$Component))
    } else {
      # Deduplicate based on Parameter name only (for tables without Component column)
      unique_idx <- !duplicated(params$Parameter)
    }

    # Only apply deduplication if we actually found duplicates
    if (any(!unique_idx)) {
      params <- params[unique_idx, , drop = FALSE]

      # Also need to adjust the stats object to match the deduplicated table
      stats_vector <- as.character(stats)

      # Keep only the corresponding stats entries
      stats <- structure(
        stats_vector[unique_idx],
        class = class(stats),
        table = params,
        effectsize = effsize
      )
    }
  }

  # Parameters' names
  params_text <- as.character(.parameters_starting_text(x, params))

  # Significance and effect size
  params_text <- paste0(
    params_text,
    " is statistically ",
    effectsize::interpret_p(
      params$p,
      rules = effectsize::rules(0.05, c("significant", "non-significant"))
    ),
    " and ",
    effectsize::interpret_direction(params$Coefficient)
  )

  # Effect size
  # if(include_effectsize){
  #   params_text <- paste0(params_text,  " and ", attributes(effsize)$interpretation)
  # }

  # Include intercept
  if (isFALSE(include_intercept)) {
    idx <- params$Parameter != "(Intercept)"
  } else {
    idx <- rep(TRUE, nrow(params))
  }

  text_full <- paste0(params_text[idx], " (", stats[idx], ")")
  result_text <- paste0(params_text[idx], " (", summary(stats)[idx], ")")

  as.report_parameters(
    text_full,
    summary = result_text,
    table = params,
    effectsize = effsize,
    ...
  )
}


# report_intercept ------------------------------------------------------------
#' @rdname report.lm
#' @export
report_intercept.lm <- function(x, table = NULL, ...) {
  if (is.null(table)) {
    intercept_table <- report_table(x, ...)
  } else {
    intercept_table <- table
  }

  if (
    (insight::model_info(x)$is_zero_inflated ||
      (inherits(x, "glmmTMB") && "dispersion" %in% table$Component)) &&
      "Component" %in% colnames(table)
  ) {
    idx <- !is.na(table$Parameter) &
      table$Parameter == "(Intercept)" &
      table$Component == "conditional"
  } else {
    idx <- !is.na(intercept_table$Parameter) &
      intercept_table$Parameter == "(Intercept)"
  }

  # sanity check - if model has no intercept, return NULL
  if (!any(idx)) {
    return(NULL)
  }

  intercept <- intercept_table[idx, ]

  estimate <- .find_regression_estimate(intercept_table)
  is_at <- insight::format_value(intercept[[estimate]])

  intercept[[estimate]] <- NULL

  intercept_text <- paste0(
    "The model's intercept is at ",
    insight::format_value(is_at),
    " (",
    insight::format_ci(
      intercept$CI_low,
      intercept$CI_high,
      attributes(intercept)$ci
    ),
    ")."
  )
  text_full <- paste0(
    "The model's intercept",
    .find_intercept(x),
    " is at ",
    insight::format_value(is_at),
    " (",
    report_statistics(x, intercept, include_effectsize = FALSE),
    ")."
  )

  text_full <- gsub("std. beta", "std. intercept", text_full, fixed = TRUE)

  as.report_intercept(text_full, summary = intercept_text, ...)
}


# report_model ------------------------------------------------------------

#' @rdname report.lm
#' @export
report_model.lm <- function(x, table = NULL, ...) {
  if (is.null(table)) {
    model_table <- report_table(x, ...)
  } else {
    model_table <- table
  }

  # Model info
  info <- insight::model_info(x)
  is_nullmodel <- suppressWarnings(insight::is_nullmodel(x))

  # Bootstrap
  if (attributes(model_table)$bootstrap) {
    bootstrapped <- paste0(
      "bootstrapped (",
      attributes(model_table)$iterations,
      " iterations) "
    )
  } else {
    bootstrapped <- ""
  }

  # Initial
  model_text <- paste0(
    bootstrapped,
    format_model(x)
  )

  # Algorithm
  algorithm <- format_algorithm(x)
  if (algorithm != "") {
    text_full <- paste0(
      model_text,
      " (estimated using ",
      algorithm,
      ")"
    )
  } else {
    text_full <- model_text
  }

  # To predict
  to_predict_text <- paste0(" to predict ", insight::find_response(x))
  if (!is_nullmodel) {
    to_predict_text <- paste0(
      to_predict_text,
      " with ",
      datawizard::text_concatenate(insight::find_predictors(
        x,
        effects = "fixed",
        flatten = TRUE
      ))
    )
  }

  # Formula
  text_full <- paste0(text_full, to_predict_text, " (", format_formula(x), ")")
  model_text <- paste0(model_text, to_predict_text)

  # Random
  if (info$is_mixed) {
    random_text <- report_random(x)
    text_full <- paste0(text_full, ". ", as.character(random_text))
    model_text <- paste0(model_text, ". ", summary(random_text))
  }

  # Bayesian
  if (info$is_bayesian) {
    priors_text <- report_priors(x)
    text_full <- paste0(text_full, ". ", as.character(priors_text))
    model_text <- paste0(model_text, ". ", summary(priors_text))
  }

  as.report_model(text_full, summary = model_text, ...)
}


# report_info ------------------------------------------------------------

#' @rdname report.lm
#' @export
report_performance.lm <- function(x, table = NULL, ...) {
  if (!is.null(table) || is.null(attributes(table)$performance)) {
    perf_table <- report_table(x, ...)
  } else {
    perf_table <- table
  }
  performance <- attributes(perf_table)$performance

  # Intercept-only
  if (suppressWarnings(insight::is_nullmodel(x))) {
    return(as.report_performance("", summary = ""))
  }

  out <- .text_r2(x, info = insight::model_info(x), performance)
  as.report_performance(out$text_full, summary = out$text)
}


# report_info ------------------------------------------------------------

#' @rdname report.lm
#' @export
report_info.lm <- function(
  x,
  effectsize = NULL,
  include_effectsize = FALSE,
  parameters = NULL,
  ...
) {
  if (is.null(effectsize)) {
    effectsize <- report_effectsize(x, ...)
  }

  info_text <- .info_effectsize(
    x,
    effectsize = effectsize,
    include_effectsize = include_effectsize
  )

  if (is.null(parameters)) {
    parameters <- report_parameters(x, ...)
  }
  if (inherits(parameters, "report_parameters")) {
    att <- attributes(attributes(parameters)$table)
  } else {
    att <- attributes(parameters)
  }

  # Only add CI information if effectsize info is empty or doesn't already contain CI details
  no_ci_info <- !nzchar(info_text) ||
    !grepl("Confidence Intervals.*computed using.*approximation", info_text)
  if ("ci_method" %in% names(att) && no_ci_info) {
    info_text <- paste0(
      info_text,
      ifelse(nzchar(info_text), " ", ""),
      .info_df(
        ci = att$ci,
        ci_method = att$ci_method,
        test_statistic = att$test_statistic,
        bootstrap = att$bootstrap
      )
    )
  }

  # if (!is.null(att$ci_method)) {
  #   .text_ci(ci, ci_method = ci_method, df_method = df_method)
  # }

  as.report_info(info_text)
}


# report_text ------------------------------------------------------------

#' @rdname report.lm
#' @export
report_text.lm <- function(x, table = NULL, ...) {
  params <- report_parameters(x, table = table, include_intercept = FALSE, ...)
  report_table_data <- attributes(params)$table

  info <- report_info(
    x,
    effectsize = attributes(params)$effectsize,
    parameters = params,
    ...
  )
  model <- report_model(x, table = report_table_data, ...)
  perf <- report_performance(x, table = report_table_data, ...)
  intercept <- report_intercept(x, table = report_table_data, ...)

  if (suppressWarnings(insight::is_nullmodel(x))) {
    params_text_full <- params_text <- ""
  } else {
    params_text_full <- paste0(" Within this model:\n\n", as.character(params))
    params_text <- paste0(
      " Within this model:\n\n",
      as.character(summary(params), ...)
    )
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

  result_summary <- paste0(
    "We fitted a ",
    summary(model),
    ". ",
    summary(perf),
    ifelse(nzchar(perf, keepNA = TRUE), ". ", ""),
    summary(intercept),
    params_text
  )

  as.report_text(text_full, summary = result_summary)
}


# Utils -------------------------------------------------------------------

#' @keywords internal
.find_regression_estimate <- function(table, ...) {
  candidates <- "(^Coefficient|beta|Median|Mean|MAP)"
  coefname <- attributes(table)$coefficient_name
  if (!is.null(coefname) && coefname %in% names(table)) {
    estimate <- attributes(table)$coefficient_name
  } else {
    estimate <- grep(candidates, names(table), value = TRUE)[1]
  }
  estimate
}
