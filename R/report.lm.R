#' (General) Linear Models Report
#'
#' Create a report of a (general) linear model (i.e., a regression fitted using \code{lm()} or \code{glm()}.
#'
#' @param x Object of class \code{lm} or \code{glm}.
#' @inheritParams report
#' @inherit report return seealso
#'
#' @examples
#' library(report)
#'
#' model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' r <- report(model)
#' r
#'
#' # model <- glm(vs ~ disp, data = mtcars, family = "binomial")
#' # r <- report(model)
#' @export
report.lm <- function(x, ...) {
  table <- report_table(x, ...)
  text <- report_text(x, table=table, ...)

  as.report(text, table = table, ...)
}





# report_effectsize -------------------------------------------------------



#' @importFrom effectsize effectsize is_effectsize_name interpret_d
#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_effectsize.lm <- function(x, ...) {
  table <- effectsize::effectsize(x, ...)
  method <- .text_standardize(table)
  estimate <- names(table)[effectsize::is_effectsize_name(names(table))]

  # TODO: finally solve this.
  # interpret <- effectsize::interpret_parameters(x, ...)
  interpret <- effectsize::interpret_d(table[[estimate]], ...)
  interpretation <- interpret
  main <- paste0("Std. beta = ", insight::format_value(table[[estimate]]))


  ci <- table$CI
  names(ci) <- paste0("ci_", estimate)

  statistics <- paste0(main,
                       ", ",
                       insight::format_ci(table$CI_low, table$CI_high, ci))

  table <- as.data.frame(table)[c("Parameter", estimate, "CI_low", "CI_high")]
  names(table)[3:ncol(table)] <- c(paste0(estimate, "_CI_low"), paste0(estimate, "_CI_high"))


  rules <- .text_effectsize(attributes(interpret)$rule_name)
  parameters <- paste0(interpretation, " (", statistics, ")")


  # Return output
  as.report_effectsize(parameters,
                       summary=parameters,
                       table=table,
                       interpretation=interpretation,
                       statistics=statistics,
                       rules=rules,
                       ci=ci,
                       method=method,
                       main=main)
}



# report_table ------------------------------------------------------------



#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_table.lm <- function(x, ...) {

  effsize <- report_effectsize(x, ...)
  effsize_table <- attributes(effsize)$table
  params <- parameters::model_parameters(x, ...)

  # Long table
  table_full <- merge(params, effsize_table, all = TRUE)
  table_full <- table_full[order(
    match(table_full$Parameter, params$Parameter)), ]
  row.names(table_full) <- NULL

  # Rename
  # names(table_full) <- gsub("Coefficient", "beta", names(table_full))

  # Remove cols
  table_full <- data_remove(table_full, "SE")

  # Short table
  table <- data_remove(table_full, data_findcols(table_full, ends_with=c("_CI_low|_CI_high")))

  out <- as.report_table(table_full,
                         summary=table,
                         effsize=effsize,
                         ...)
  attr(out, paste0(names(attributes(effsize)$ci))) <- attributes(effsize)$ci
  # Add attributes from params table
  for(att in c("ci", "coefficient_name", "pretty_names", "bootstrap", "iterations")){
    attr(out, att) <- attributes(params)[[att]]
  }

  out
}


# report_statistics ------------------------------------------------------------

#' @rdname report_statistics
#' @param include_effectsize If \code{FALSE}, won't include effect-size related parameters (standardized coefficients, etc.)
#' @export
report_statistics.lm <- function(x, table=NULL, include_effectsize=TRUE, ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }
  effsize <- attributes(table)$effsize

  # Estimate
  estimate <- .find_regression_estimate(table)
  if(is.na(estimate) | is.null(estimate) | !estimate %in% names(table)){
    text <- ""
  } else if(estimate == "Coefficient"){
    text <- paste0("beta = ", insight::format_value(table$Coefficient))
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
  if("p" %in% names(table)){
    text <- text_paste(text, insight::format_p(table$p, stars = FALSE, digits = "apa"))
  }

  # Effect size
  if(include_effectsize && !is.null(effsize)){
    text_full <- text_paste(text, attributes(effsize)$statistics, sep="; ")
    text <- text_paste(text, attributes(effsize)$main)
  } else{
    text_full <- text
  }

  as.report_statistics(text_full,
                       summary=text,
                       table=table,
                       effsize=effsize)
}




# report_statistics ------------------------------------------------------------


#' @inheritParams report_statistics
#' @export
report_parameters.lm <- function(x, table=NULL, include_effectsize=TRUE, ...) {

  stats <- report_statistics(x, table=table, include_effectsize=include_effectsize, ...)
  params <- attributes(stats)$table
  effsize <- attributes(stats)$effsize

  # Parameters' names
  text <- sapply(attributes(params)$pretty_names[params$Parameter],
                 .format_parameters_regression,
                 simplify = TRUE, USE.NAMES = FALSE)

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

  text_full <- paste0(text, " (", stats, ")")
  text <- paste0(text, " (", summary(stats), ")")

  as.report_parameters(text_full, summary=text, table=params, effectsize=effsize, ...)
}


# report_intercept ------------------------------------------------------------

#' @export
report_intercept.lm <- function(x, table=NULL, ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }

  idx <- table$Parameter == "(Intercept)"
  intercept <- table[idx, ]

  estimate <- attributes(table)$coefficient_name
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
    report_statistics(x, intercept, include_effectsize=FALSE),
    ")."
  )

  text_full <- gsub("std. beta", "std. intercept", text_full, fixed = TRUE)

  as.report_intercept(text_full, summary=text, ...)
}



# report_model ------------------------------------------------------------

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
  text_full <- paste0(text_full, to_predict_text, " (", format_formula(x), ").")
  text <- paste0(text, to_predict_text, ".")

  # Random
  if (!is.null(insight::find_terms(x)$random)) {
    text_random <- format_text(insight::find_terms(x)$random)
    text_random <- paste0(" The model included ", text_random, " as random effects")
    text_random_full <- paste0(text_random, " (", format_formula(x, "random"), ").")
    text <- paste0(text, text_random, ".")
    text_full <- paste0(text_full, text_random_full)
  }

  as.report_intercept(text_full, summary=text, ...)
}


# report_info ------------------------------------------------------------

#' @export
report_info.lm <- function(x, effectsize=NULL, include_effectsize=FALSE, ...) {
  if (is.null(effectsize)) {
    effectsize <- report_effectsize(x, ...)
  }

  text <- ""

  if (!is.null(effectsize)) {
    text_effsize <- attributes(effectsize)$method
    if(include_effectsize){
      text_effsize <- paste0(text_effsize, attributes(effectsize)$rules)
      text_effsize <- gsub(".Effect sizes ", " and ", text_effsize)
    }
    text <- paste0(text, text_effsize)
  }

  # if (!is.null(ci_method)) {
  #   text_full <- paste0(
  #     text_full,
  #     .text_ci(ci, ci_method = ci_method, df_method = df_method)
  #   )
  # }

  # if (!is.null(interpretation)) {
  #   text_full <- paste0(
  #     text_full,
  #     .text_effsize(interpretation)
  #   )
  # }
  as.report_info(text)
}



# report_text ------------------------------------------------------------

#' @export
report_text.lm <- function(x, table=NULL, ...) {
  params <- report_parameters(x, table=table, ...)
  table <- attributes(params)$table

  info <- report_info(x, effectsize=attributes(params)$effectsize, ...)
  model <- report_model(x, table=table, ...)
  intercept <- report_intercept(x, table=table, ...)


  text_full <- paste0(
    info,
    "\n\nWe fitted a ",
    model,
    " ",
    intercept,
    " Withing this model:\n\n",
    as.character(params)
  )

  text <- paste0(
    "We fitted a ",
    summary(model),
    " ",
    summary(intercept),
    " Withing this model:\n\n",
    as.character(summary(params), ...)
  )


  as.report_text(text_full, summary=text)
}


# Utils -------------------------------------------------------------------

#' @keywords internal
.find_regression_estimate <- function(table, ...){
  if(!is.null(attributes(table)$coefficient_name)){
    estimate <- attributes(table)$coefficient_name
  } else{
    estimate <- data_findcols(table, c("^Coefficient", "beta", "Median", "Mean", "MAP"))[1]
  }
  estimate
}

