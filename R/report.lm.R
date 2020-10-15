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



#' @importFrom effectsize effectsize interpret_r interpret_d
#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_effectsize.lm <- function(x, ...) {
  "Soon."
}



# report_table ------------------------------------------------------------



#' @importFrom parameters model_parameters
#' @importFrom insight model_info
#' @export
report_table.lm <- function(x, ...) {
  "Soon."
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
