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
#'
#'
#' model <- glm(vs ~ disp, data = mtcars, family = "binomial")
#' r <- report(model)
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

  # Short table
  table <- data_remove(table_full, data_findcols(table_full, ends_with=c("_CI_low|_CI_high")))

  out <- as.report_table(table_full, summary=table, ci=attributes(params)$ci, effsize=effsize)
  attr(out, paste0(names(attributes(effsize)$ci))) <- attributes(effsize)$ci
  out
}


# report_statistics ------------------------------------------------------------



#' @export
report_statistics.lm <- function(x, table=NULL, ...) {
  "Soon."
}




# report_statistics ------------------------------------------------------------



#' @export
report_parameters.lm <- function(x, table=NULL, ...) {
  "Soon."
}

# report_model ------------------------------------------------------------

#' @export
report_model.lm <- function(x, table=NULL, ...) {
  "Soon."
}


# report_info ------------------------------------------------------------

#' @export
report_info.lm <- function(x, effectsize=NULL, ...) {
  "Soon."
}



# report_text ------------------------------------------------------------

#' @export
report_text.lm <- function(x, table=NULL, ...) {
  "Soon."
}
