#' (General) Linear Models Report
#'
#' Create a report of a (general) linear model (i.e., a regression fitted using \code{lm()} or \code{glm()}.
#'
#' @param x Object of class \code{lm} or \code{glm}.
#' @param include_effectsize If \code{FALSE}, won't include effect-size related indices (standardized coefficients, etc.).
#' @param include_diagnostic If \code{FALSE}, won't include diagnostic related indices for Bayesian models (ESS, Rhat).
#' @param include_intercept If \code{FALSE}, won't include the intercept.
#' @param effectsize_method See documentation for \code{\link[effectsize:effectsize]{effectsize::effectsize()}}.
#' @param parameters Provide the output of \code{report_parameters()} to avoid its re-computation.
#' @inheritParams report
#' @inheritParams report.htest
#'
#' @inherit report return seealso
#'
#' @examples
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
#'
#' # Mixed models
#' if(require("lme4")){
#'   model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#'   r <- report(model)
#'   r
#'   summary(r)
#'   as.data.frame(r)
#'   summary(as.data.frame(r))
#' }
#' @export
report.lm <- function(x, include_effectsize = TRUE, effectsize_method="refit", ...) {
  table <- report_table(x,
                        include_effectsize=include_effectsize,
                        effectsize_method=effectsize_method, ...)
  text <- report_text(x,
                      table = table, ...)

  as.report(text, table = table, ...)
}





# report_effectsize -------------------------------------------------------

#' @rdname report.lm
#' @importFrom effectsize effectsize is_effectsize_name interpret_d interpret_oddsratio
#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_effectsize.lm <- function(x, effectsize_method="refit", ...) {
  table <- effectsize::effectsize(x, method=effectsize_method, ...)
  method <- .text_standardize(table)
  estimate <- names(table)[effectsize::is_effectsize_name(names(table))]

  # TODO: finally solve this.
  # interpret <- effectsize::interpret_parameters(x, ...)
  if (insight::model_info(x)$is_logit) {
    interpret <- effectsize::interpret_oddsratio(table[[estimate]], log = TRUE, ...)
  } else {
    interpret <- effectsize::interpret_d(table[[estimate]], ...)
  }

  interpretation <- interpret
  main <- paste0("Std. beta = ", insight::format_value(table[[estimate]]))


  ci <- table$CI
  names(ci) <- paste0("ci_", estimate)

  statistics <- paste0(main,
                       ", ",
                       insight::format_ci(table$CI_low, table$CI_high, ci))

  if ("Component" %in% colnames(table)) {
    merge_by <- c("Parameter", "Component")
    start_col <- 4
  } else {
    merge_by <- "Parameter"
    start_col <- 3
  }

  table <- as.data.frame(table)[c(merge_by, estimate, "CI_low", "CI_high")]
  names(table)[start_col:ncol(table)] <- c(paste0(estimate, "_CI_low"), paste0(estimate, "_CI_high"))


  rules <- .text_effectsize(attributes(interpret)$rule_name)
  parameters <- paste0(interpretation, " (", statistics, ")")


  # Return output
  as.report_effectsize(parameters,
                       summary = parameters,
                       table = table,
                       interpretation = interpretation,
                       statistics = statistics,
                       rules = rules,
                       ci = ci,
                       method = method,
                       main = main)
}



# report_table ------------------------------------------------------------


#' @rdname report.lm
#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @include utils_combine_tables.R
#' @export
report_table.lm <- function(x, include_effectsize = TRUE, ...) {

  params <- parameters::model_parameters(x, ...)

  # Combine -----
  # Add effectsize
  if (include_effectsize) {
    effsize <- report_effectsize(x, ...)
    params <- .combine_tables_effectsize(params, effsize)
  } else{
    effsize <- NULL
  }

  # Add performance
  performance <- performance::model_performance(x, ...)
  params <- .combine_tables_performance(params, performance)
  params <- params[!tolower(params$Parameter) %in% c("rmse", # lm
                                                     "logloss", "score_log", "score_spherical", "pcp", # glm
                                                     "icc",  # lmer
                                                     "elpd_se", "looic_se"), ] # stanreg

  # Clean -----
  # Rename some columns
  # names(table_full) <- gsub("Coefficient", "beta", names(table_full))

  # Shorten ----
  if (insight::model_info(x)$is_logit) {
    params <- data_remove(params, "df_error")
  }
  table_full <- data_remove(params, "SE")
  table <- data_remove(table_full, data_findcols(table_full, ends_with = c("_CI_low|_CI_high")))
  table <- table[!table$Parameter %in% c("AIC", "BIC",
                                         "ELPD", "LOOIC", "WAIC"), ]

  # Prepare -----
  out <- as.report_table(table_full,
                         summary = table,
                         effsize = effsize,
                         performance = performance,
                         ...)
  attr(out, paste0(names(attributes(effsize)$ci))) <- attributes(effsize)$ci
  # Add attributes from params table
  for (att in c("ci", "coefficient_name", "pretty_names", "bootstrap", "iterations", "df_method")) {
    attr(out, att) <- attributes(params)[[att]]
  }

  out
}


# report_statistics ------------------------------------------------------------

#' @rdname report.lm
#' @export
report_statistics.lm <- function(x, table = NULL, include_effectsize = TRUE, include_diagnostic=TRUE, ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }
  table <- .remove_performance(table)
  effsize <- attributes(table)$effsize

  # Estimate
  estimate <- .find_regression_estimate(table)
  if (is.na(estimate) | is.null(estimate) | !estimate %in% names(table)) {
    text <- ""
  } else if (estimate == "Coefficient") {
    text <- paste0("beta = ", insight::format_value(table[[estimate]]))
  } else{
    text <- paste0(estimate, " = ", insight::format_value(table[[estimate]]))
  }

  # CI
  if (!is.null(table$CI_low)) {
    text <- text_paste(text, insight::format_ci(table$CI_low, table$CI_high, ci = attributes(table)$ci))
  }

  # Statistic
  if ("t" %in% names(table)) {
    text <- text_paste(text, paste0("t(", insight::format_value(table$df, protect_integers = TRUE), ") = ", insight::format_value(table$t)))
  }

  # p-value
  if ("p" %in% names(table)) {
    text <- text_paste(text, insight::format_p(table$p, stars = FALSE, digits = "apa"))
  }

  # pd
  if ("pd" %in% names(table)) {
    text <- text_paste(text, insight::format_pd(table$pd, stars = FALSE))
  }

  # BF
  if ("ROPE_Percentage" %in% names(table)) {
    text <- text_paste(text, insight::format_rope(table$ROPE_Percentage))
  }

  # BF
  if ("BF" %in% names(table)) {
    text <- text_paste(text, insight::format_bf(table$BF, stars = FALSE))
  }

  # Effect size
  if (include_effectsize && !is.null(effsize)) {
    text_full <- text_paste(text, attributes(effsize)$statistics, sep = "; ")
    text <- text_paste(text, attributes(effsize)$main)
  } else {
    text_full <- text
  }

  # Quality / Diagnostic
  if (include_diagnostic) {
    text_diagnostic <- ""
    if ("Rhat" %in% names(table)) {
      text_diagnostic <- paste0("Rhat = ", insight::format_value(table$Rhat))
    }
    text <- text_paste(text, text_diagnostic)
    if ("ESS" %in% names(table)) {
      text_diagnostic <- text_paste(text_diagnostic, paste0("ESS = ", insight::format_value(table$ESS)))
    }
    text_full <- text_paste(text_full, text_diagnostic, sep = "; ")
  }

  as.report_statistics(text_full,
                       summary = text,
                       table = table,
                       effsize = effsize)
}




# report_statistics ------------------------------------------------------------

#' @rdname report.lm
#' @inheritParams report_statistics
#' @export
report_parameters.lm <- function(x, table = NULL, include_effectsize = TRUE, include_intercept = TRUE, ...) {

  # Get data
  stats <- report_statistics(x, table = table, include_effectsize = include_effectsize, ...)
  params <- attributes(stats)$table
  effsize <- attributes(stats)$effsize

  # Parameters' names
  text <- as.character(.parameters_starting_text(x, params))

  # Significance and effect size
  text <- paste0(
    text,
    " is ",
    effectsize::interpret_p(params$p),
    "ly ",
    effectsize::interpret_direction(params$Coefficient))

  # Effect size
  # if(include_effectsize){
  #   text <- paste0(text,  " and ", attributes(effsize)$interpretation)
  # }

  # Include intercept
  if (isFALSE(include_intercept)) {
    idx <- !params$Parameter == "(Intercept)"
  } else{
    idx <- rep(TRUE, nrow(params))
  }

  text_full <- paste0(text[idx], " (", stats[idx], ")")
  text <- paste0(text[idx], " (", summary(stats)[idx], ")")


  as.report_parameters(text_full, summary = text, table = params, effectsize = effsize, ...)
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
  intercept <- table[idx, ]

  estimate <- .find_regression_estimate(table)
  is_at <- insight::format_value(intercept[[estimate]])

  intercept[[estimate]] <- NULL

  text <- paste0(
    "The model's intercept is at ",
    insight::format_value(is_at),
    "."
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
report_model.lm <- function(x, table=NULL, ...) {

  if (is.null(table)) {
    table <- report_table(x, ...)
  }

  # Model info
  info <- insight::model_info(x)
  is_nullmodel <- insight::is_nullmodel(x)

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
  text_full <- paste0(
    text,
    " (estimated using ",
    format_algorithm(x),
    ")"
  )

  # To predict
  to_predict_text <- paste0(" to predict ", insight::find_response(x))
  if (!is_nullmodel) {
    to_predict_text <- paste0(
      to_predict_text,
      " with ",
      format_text(insight::find_predictors(x, effects = "fixed", flatten = TRUE))
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

  as.report_model(text_full, summary = text, ...)
}





# report_info ------------------------------------------------------------

#' @rdname report.lm
#' @export
report_performance.lm <- function(x, table=NULL, ...) {
  if (!is.null(table) | is.null(attributes(table)$performance)) {
    table <- report_table(x, ...)
  }
  performance <- attributes(table)$performance


  # Intercept-only
  if (insight::is_nullmodel(x)) {
    return(as.report_performance("", summary = ""))
  }

  out <- .text_r2(x, info = insight::model_info(x), performance)
  as.report_performance(out$text_full, summary = out$text)
}



# report_info ------------------------------------------------------------

#' @rdname report.lm
#' @export
report_info.lm <- function(x, effectsize=NULL, include_effectsize=FALSE, parameters=NULL, ...) {
  if (is.null(effectsize)) {
    effectsize <- report_effectsize(x, ...)
  }

  text <- ""

  if (!is.null(effectsize)) {
    text_effsize <- attributes(effectsize)$method
    if (include_effectsize) {
      text_effsize <- paste0(text_effsize, attributes(effectsize)$rules)
      text_effsize <- gsub(".Effect sizes ", " and ", text_effsize)
    }
    text <- paste0(text, text_effsize)
  }

  if (is.null(parameters)) {
    parameters <- report_parameters(x, ...)
  }
  if (inherits(parameters, "report_parameters")) {
    att <- attributes(attributes(parameters)$table)
  } else {
  att <- attributes(parameters)
  }

  if ("df_method" %in% names(att)) {
    text <- paste0(text, " ", .text_df(ci=att$ci, df_method = att$df_method))
  }

  # if (!is.null(att$ci_method)) {
  #   .text_ci(ci, ci_method = ci_method, df_method = df_method)
  # }


  as.report_info(text)
}



# report_text ------------------------------------------------------------

#' @rdname report.lm
#' @export
report_text.lm <- function(x, table = NULL, ...) {
  params <- report_parameters(x, table = table, include_intercept = FALSE, ...)
  table <- attributes(params)$table

  info <- report_info(x, effectsize = attributes(params)$effectsize, parameters = attributes(params)$table, ...)
  model <- report_model(x, table = table, ...)
  perf <- report_performance(x, table = table, ...)
  intercept <- report_intercept(x, table = table, ...)


  text_full <- paste0(
    "We fitted a ",
    model,
    ". ",
    perf,
    ". ",
    intercept,
    " Within this model:\n\n",
    as.character(params),
    "\n\n",
    info
  )

  text <- paste0(
    "We fitted a ",
    summary(model),
    ". ",
    summary(perf),
    ". ",
    summary(intercept),
    " Within this model:\n\n",
    as.character(summary(params), ...)
  )


  as.report_text(text_full, summary = text)
}


# Utils -------------------------------------------------------------------

#' @keywords internal
.find_regression_estimate <- function(table, ...) {
  candidates <- c("^Coefficient", "beta", "Median", "Mean", "MAP")
  coefname <- attributes(table)$coefficient_name
  if (!is.null(coefname) && coefname %in% names(table)) {
    estimate <- attributes(table)$coefficient_name
  } else{
    estimate <- data_findcols(table, candidates)[1]
  }
  estimate
}

