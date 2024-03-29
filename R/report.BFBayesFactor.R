#' Reporting `BFBayesFactor` objects from the `BayesFactor` package
#'
#' Interpretation of the Bayes factor output from the `BayesFactor` package.
#'
#' @param x An object of class `BFBayesFactor`.
#' @param h0,h1 Names of the null and alternative hypotheses.
#' @param table A `parameters` table (this argument is meant for internal use).
#' @param ... Other arguments to be passed to [effectsize::interpret_bf] and [insight::format_bf].
#'
#' @examplesIf requireNamespace("BayesFactor", quietly = TRUE)
#' \donttest{
#' library(BayesFactor)
#'
#' rez <- BayesFactor::ttestBF(iris$Sepal.Width, iris$Sepal.Length)
#' report_statistics(rez, exact=TRUE)  # Print exact BF
#' report(rez, h0="the null hypothesis", h1="the alternative")
#'
#' rez <- BayesFactor::correlationBF(iris$Sepal.Width, iris$Sepal.Length)
#' report(rez)
#' }
#'
#' @export
report.BFBayesFactor <- function(x, h0="H0", h1="H1", ...) {
  if ("BFlinearModel" %in% class(x@numerator[[1]])) {
    return(report(bayestestR::bayesfactor_models(x), ...))
  }

  if (length(x@numerator) > 1) {
    insight::format_alert("Multiple `BFBayesFactor` models detected - reporting for the first numerator model.",
                          "See help(\"get_parameters\", package = \"insight\").")
    x <- x[1]
  }

  param <- parameters::parameters(x[1], ...)
  bf <- param$BF
  dir <- ifelse(bf < 1, "h0", "h1")


  if (dir == "h1") {
    text <- paste0("There is ",
                  effectsize::interpret_bf(bf, ...),
                  " ",
                  h1,
                  " over ",
                  h0,
                  " (", report_statistics(x, ...), ").")
  } else {
    text <- paste0("There is ",
                  effectsize::interpret_bf(1/bf, ...),
                  " ",
                  h0,
                  " over ",
                  h1,
                  " (", report_statistics(x, ...), ").")
  }
  text
}



#' @rdname report.BFBayesFactor
#' @export
report_statistics.BFBayesFactor <- function(x, table = NULL, ...) {
  if(is.null(table)) {
    if (length(x@numerator) > 1) {
      insight::format_alert("Multiple `BFBayesFactor` models detected - reporting for the first numerator model.",
                            "See help(\"get_parameters\", package = \"insight\").")
      x <- x[1]
    }
    table <- parameters::parameters(x, ...)
  }

  bf <- table$BF
  text <- ifelse(bf < 1,
                 insight::format_bf(1/bf, name="BF01", ...),
                 insight::format_bf(bf, name="BF10", ...))
  text
}

