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

report.lm <- function(x, include_effectsize = TRUE, effectsize_method = "refit", ...) {
  table <- report_table(x,
    include_effectsize = include_effectsize,
    effectsize_method = effectsize_method, ...
  )
  text <- report_text(x,
    table = table, ...
  )

  as.report(text, table = table, ...)
}


# report_effectsize -------------------------------------------------------

#' @rdname report.lm
#' @export

report_effectsize.lm <- function(x, effectsize_method = "refit", ...) {
  table <- suppressWarnings(effectsize::effectsize(x, method = effectsize_method, ...))
  method <- .text_standardize(table)
  estimate <- names(table)[effectsize::is_effectsize_name(names(table))]

  # TODO: finally solve this.
  # interpret <- effectsize::interpret_parameters(x, ...)
  if (insight::model_info(x)$is_logit) {
    interpret <- effectsize::interpret_oddsratio(table[[estimate]], log = TRUE, ...)
  } else {
    interpret <- effectsize::interpret_cohens_d(table[[estimate]], ...)
  }

  interpretation <- interpret
  main <- paste0("Std. beta = ", insight::format_value(table[[estimate]]))


  ci <- table$CI
  names(ci) <- paste0("ci_", estimate)

  statistics <- paste0(
    main,
    ", ",
    insight::format_ci(table$CI_low, table$CI_high, ci)
  )

  if ("Component" %in% colnames(table)) {
    merge_by <- c("Parameter", "Component")
    start_col <- 4L
  } else {
    merge_by <- "Parameter"
    start_col <- 3L
  }

  table <- as.data.frame(table)[c(merge_by, estimate, "CI_low", "CI_high")]
  names(table)[start_col:ncol(table)] <- c(paste0(estimate, "_CI_low"), paste0(estimate, "_CI_high"))

  rules <- .text_effectsize(attr(attr(interpret, "rules"), "rule_name"))
  parameters <- paste0(interpretation, " (", statistics, ")")

  as.report_effectsize(parameters,
    summary = parameters,
    table = table,
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
  params <- params[!tolower(params$Parameter) %in% c(
    "rmse", # lm
    "logloss", "score_log", "score_spherical", "pcp", # glm
    "icc", # lmer
    "elpd_se", "looic_se" # stanreg
  ), ]

  # Clean -----
  # Rename some columns
  # names(table_full) <- gsub("Coefficient", "beta", names(table_full))

  # Shorten ----
  if (insight::model_info(x)$is_logit) {
    params <- datawizard::data_remove(params, "df_error")
  }
  table_full <- datawizard::data_remove(params, "SE")
  table <- datawizard::data_remove(
    table_full,
    select = "(_CI_low|_CI_high)$",
    regex = TRUE,
    verbose = FALSE
  )
  table <- table[!table$Parameter %in% c("AIC", "BIC", "ELPD", "LOOIC", "WAIC"), ]

  # Prepare -----
  out <- as.report_table(table_full,
    summary = table,
    effsize = effsize,
    performance = performance,
    ...
  )
  if (!is.null(effsize)) attr(out, paste0(names(attributes(effsize)$ci))) <- attributes(effsize)$ci
  # Add attributes from params table
  for (att in c("ci", "coefficient_name", "pretty_names", "bootstrap", "iterations", "ci_method")) {
    attr(out, att) <- attributes(params)[[att]]
  }

  out
}


# report_statistics ------------------------------------------------------------

#' @rdname report.lm
#' @export
report_statistics.lm <- function(x,
                                 table = NULL,
                                 include_effectsize = TRUE,
                                 include_diagnostic = TRUE,
                                 ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }
  table <- .remove_performance(table)
  effsize <- attributes(table)$effsize

  # Estimate
  estimate <- .find_regression_estimate(table)
  if (is.null(estimate) || is.na(estimate) || !estimate %in% names(table)) {
    text <- ""
  } else if (estimate == "Coefficient") {
    text <- paste0("beta = ", insight::format_value(table[[estimate]]))
  } else {
    text <- paste0(estimate, " = ", insight::format_value(table[[estimate]]))
  }

  # CI
  if (!is.null(table$CI_low)) {
    text <- datawizard::text_paste(text, insight::format_ci(table$CI_low, table$CI_high, ci = attributes(table)$ci))
  }

  # Statistic
  if ("t" %in% names(table)) {
    text <- datawizard::text_paste(
      text,
      paste0("t(", insight::format_value(table$df, protect_integers = TRUE), ") = ", insight::format_value(table$t))
    )
  }

  # p-value
  if ("p" %in% names(table)) {
    text <- datawizard::text_paste(text, insight::format_p(table$p, stars = FALSE, digits = "apa"))
  }

  # pd
  if ("pd" %in% names(table)) {
    text <- datawizard::text_paste(text, insight::format_pd(table$pd, stars = FALSE))
  }

  # BF
  if ("ROPE_Percentage" %in% names(table)) {
    text <- datawizard::text_paste(text, insight::format_rope(table$ROPE_Percentage))
  }

  # BF
  if ("BF" %in% names(table)) {
    text <- datawizard::text_paste(text, insight::format_bf(table$BF, stars = FALSE, exact = TRUE))
  }

  # Effect size
  if (include_effectsize && !is.null(effsize)) {
    text_full <- datawizard::text_paste(text, attributes(effsize)$statistics, sep = "; ")
    text <- datawizard::text_paste(text, attributes(effsize)$main)
  } else {
    text_full <- text
  }

  # Quality / Diagnostic
  if (include_diagnostic) {
    text_diagnostic <- ""

    if ("Rhat" %in% names(table)) {
      text_diagnostic <- paste0("Rhat = ", insight::format_value(table$Rhat))
    }

    text <- datawizard::text_paste(text, text_diagnostic)

    if ("ESS" %in% names(table)) {
      text_diagnostic <- datawizard::text_paste(text_diagnostic, paste0("ESS = ", insight::format_value(table$ESS)))
    }

    text_full <- datawizard::text_paste(text_full, text_diagnostic, sep = "; ")
  }

  as.report_statistics(text_full,
    summary = text,
    table = table,
    effsize = effsize
  )
}


# report_statistics ------------------------------------------------------------

#' @rdname report.lm
#' @inheritParams report_statistics
#' @export
report_parameters.lm <- function(x,
                                 table = NULL,
                                 include_effectsize = TRUE,
                                 include_intercept = TRUE,
                                 ...) {
  # Get data
  stats <- report_statistics(x, table = table, include_effectsize = include_effectsize, ...)
  params <- attributes(stats)$table
  effsize <- attributes(stats)$effsize

  # Parameters' names
  text <- as.character(.parameters_starting_text(x, params))

  # Significance and effect size
  text <- paste0(
    text,
    " is statistically ",
    effectsize::interpret_p(params$p, rules = effectsize::rules(0.05, c("significant", "non-significant"))),
    " and ",
    effectsize::interpret_direction(params$Coefficient)
  )

  # Effect size
  # if(include_effectsize){
  #   text <- paste0(text,  " and ", attributes(effsize)$interpretation)
  # }

  # Include intercept
  if (isFALSE(include_intercept)) {
    idx <- !params$Parameter == "(Intercept)"
  } else {
    idx <- rep(TRUE, nrow(params))
  }

  text_full <- paste0(text[idx], " (", stats[idx], ")")
  text <- paste0(text[idx], " (", summary(stats)[idx], ")")


  as.report_parameters(
    text_full,
    summary = text,
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
    table <- report_table(x, ...)
  }

  if (insight::model_info(x)$is_zero_inflated && "Component" %in% colnames(table)) {
    idx <- !is.na(table$Parameter) & table$Parameter == "(Intercept)" & table$Component == "conditional"
  } else {
    idx <- !is.na(table$Parameter) & table$Parameter == "(Intercept)"
  }

  # sanity check - if model has no intercept, return NULL
  if (!any(idx)) {
    return(NULL)
  }

  intercept <- table[idx, ]

  estimate <- .find_regression_estimate(table)
  is_at <- insight::format_value(intercept[[estimate]])

  intercept[[estimate]] <- NULL

  text <- paste0(
    "The model's intercept is at ",
    insight::format_value(is_at),
    " (",
    insight::format_ci(intercept$CI_low, intercept$CI_high, attributes(intercept)$ci),
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

  as.report_intercept(text_full, summary = text, ...)
}


# report_model ------------------------------------------------------------

#' @rdname report.lm
#' @export
report_model.lm <- function(x, table = NULL, ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }

  # Model info
  info <- insight::model_info(x)
  is_nullmodel <- suppressWarnings(insight::is_nullmodel(x))

  # Boostrap
  if (attributes(table)$bootstrap) {
    boostrapped <- paste0("bootstrapped (", attributes(table)$iterations, " iterations) ")
  } else {
    boostrapped <- ""
  }

  # Initial
  text <- paste0(
    boostrapped,
    format_model(x)
  )

  # Algorithm
  algorithm <- format_algorithm(x)
  if (algorithm != "") {
    text_full <- paste0(
      text,
      " (estimated using ",
      algorithm,
      ")"
    )
  } else {
    text_full <- text
  }


  # To predict
  to_predict_text <- paste0(" to predict ", insight::find_response(x))
  if (!is_nullmodel) {
    to_predict_text <- paste0(
      to_predict_text,
      " with ",
      datawizard::text_concatenate(insight::find_predictors(x, effects = "fixed", flatten = TRUE))
    )
  }

  # Formula
  text_full <- paste0(text_full, to_predict_text, " (", format_formula(x), ")")
  text <- paste0(text, to_predict_text)

  # Random
  if (info$is_mixed) {
    random_text <- report_random(x)
    text_full <- paste0(text_full, ". ", as.character(random_text))
    text <- paste0(text, ". ", summary(random_text))
  }

  # Bayesian
  if (info$is_bayesian) {
    priors_text <- report_priors(x)
    text_full <- paste0(text_full, ". ", as.character(priors_text))
    text <- paste0(text, ". ", summary(priors_text))
  }


  as.report_model(text_full, summary = text, ...)
}


# report_info ------------------------------------------------------------

#' @rdname report.lm
#' @export
report_performance.lm <- function(x, table = NULL, ...) {
  if (!is.null(table) || is.null(attributes(table)$performance)) {
    table <- report_table(x, ...)
  }
  performance <- attributes(table)$performance


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
report_info.lm <- function(x,
                           effectsize = NULL,
                           include_effectsize = FALSE,
                           parameters = NULL,
                           ...) {
  if (is.null(effectsize)) {
    effectsize <- report_effectsize(x, ...)
  }

  info_text <- .info_effectsize(x, effectsize = effectsize, include_effectsize = include_effectsize)

  if (is.null(parameters)) {
    parameters <- report_parameters(x, ...)
  }
  if (inherits(parameters, "report_parameters")) {
    att <- attributes(attributes(parameters)$table)
  } else {
    att <- attributes(parameters)
  }

  if ("ci_method" %in% names(att)) {
    info_text <- paste0(info_text, " ", .info_df(
      ci = att$ci,
      ci_method = att$ci_method,
      test_statistic = att$test_statistic,
      bootstrap = att$bootstrap
    ))
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
  table <- attributes(params)$table

  info <- report_info(x, effectsize = attributes(params)$effectsize, parameters = params, ...)
  model <- report_model(x, table = table, ...)
  perf <- report_performance(x, table = table, ...)
  intercept <- report_intercept(x, table = table, ...)

  if (suppressWarnings(insight::is_nullmodel(x))) {
    params_text_full <- params_text <- ""
  } else {
    params_text_full <- paste0(" Within this model:\n\n", as.character(params))
    params_text <- paste0(" Within this model:\n\n", as.character(summary(params), ...))
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


# Utils -------------------------------------------------------------------

#' @keywords internal
.find_regression_estimate <- function(table, ...) {
  candidates <- "(^Coefficient|beta|Median|Mean|MAP)"
  coefname <- attributes(table)$coefficient_name
  if (!is.null(coefname) && coefname %in% names(table)) {
    estimate <- attributes(table)$coefficient_name
  } else {
    estimate <- datawizard::extract_column_names(table, candidates, regex = TRUE, verbose = FALSE)[1]
  }
  estimate
}
