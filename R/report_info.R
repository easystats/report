#' Report additional information
#'
#' Reports additional information relevant to the report (see list of supported objects in \code{\link{report}}).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return A \code{character} string.
#'
#' @examples
#' library(report)
#'
#' # h-tests
#' report_info(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report_info(cor.test(iris$Sepal.Width, iris$Sepal.Length))
#'
#' # ANOVAs
#' report_info(aov(Sepal.Length ~ Species, data=iris))
#'
#' # GLMs
#' report_info(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' report_info(lm(Sepal.Length ~ Petal.Length * Species, data = iris), include_effectsize=TRUE)
#' @export
report_info <- function(x, ...) {
  UseMethod("report_info")
}


#' @export
report_info.default <- function(x, ...) {
  stop(paste0("report_info() is not available for objects of class ", class(x)))
}

# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_info <- function(x, summary = NULL, ...) {
  class(x) <- unique(c("report_info", class(x)))
  attributes(x) <- c(attributes(x), list(...))

  if (!is.null(summary)) {
    attr(x, "summary") <- summary
  }
  x
}


#' @export
summary.report_info <- function(object, ...) {
  if(is.null(attributes(object)$summary)){
    object
  } else{
    attributes(object)$summary
  }
}

#' @export
print.report_info <- function(x, ...) {
  cat(paste0(x, collapse = "\n"))
}



# Utils -------------------------------------------------------------------


#' @keywords internal
# .text_ci <- function(ci, ci_method, df_method = NULL) {
#   text <- ""
#   # Frequentist --------------------------------
#
#   if (!is.null(df_method) && df_method == "wald" && !is.null(ci_method) && ci_method == "wald") {
#     return(paste0(" The ", insight::format_value(ci * 100, protect_integers = TRUE), "%", " Confidence Intervals (CIs) and p-values were computed using Wald approximation."))
#   }
#
#
#   # CI
#   if (ci_method == "wald") {
#     text <- paste0(" The ", insight::format_value(ci * 100, protect_integers = TRUE), "%", " Confidence Intervals (CIs) were computed using Wald approximation")
#   } else if (ci_method == "boot") {
#     text <- paste0(" The ", insight::format_value(ci * 100, protect_integers = TRUE), "%", " Confidence Intervals (CIs) were obtained through bootstrapping")
#   } else {
#     text <- paste0(" The ", insight::format_value(ci * 100, protect_integers = TRUE), "%", " Confidence Intervals (CIs) were obtained through ", ci_method)
#   }
#
#
#   # P values
#   if (!is.null(df_method)) {
#     if (text != "") text <- paste0(text, " and ")
#     if (df_method == "wald") text <- paste0(text, "p-values were computed using Wald approximation")
#     if (df_method == "kenward") text <- paste0(text, "p-values were computed using Kenward-Roger approximation")
#   }
#
#
#   # Bayesian --------------------------------
#   if (tolower(ci_method) == "hdi") {
#     text <- paste0(" The ", insight::format_value(ci * 100, protect_integers = TRUE), "%", " Credible Intervals (CIs) were based on Highest Density Intervals (HDI)")
#   }
#
#   if (tolower(ci_method) %in% c("eti", "quantile", "ci")) {
#     text <- paste0(" The ", insight::format_value(ci * 100, protect_integers = TRUE), "%", " Credible Intervals (CIs) are Equal-Tailed Intervals (ETI) computed using quantiles")
#   }
#
#   paste0(text, ".")
# }





#' @keywords internal
# .text_rope <- function(rope_range, rope_ci) {
#   if (rope_ci == 1) {
#     text <- paste0(
#       " The Region of Practical Equivalence (ROPE) ",
#       "percentage was defined as the proportion of the ",
#       "posterior distribution within the [",
#       insight::format_value(rope_range[1]),
#       ", ",
#       insight::format_value(rope_range[2]),
#       "] range."
#     )
#   } else {
#     text <- paste0(
#       " The Region of Practical Equivalence (ROPE) ",
#       "percentage was defined as the proportion of the ",
#       rope_ci * 100, "% CI within the [",
#       insight::format_value(rope_range[1]),
#       ", ",
#       insight::format_value(rope_range[2]),
#       "] range."
#     )
#   }
#   text
# }




#' @keywords internal
# .text_priors <- function(parameters) {
#   params <- parameters[parameters$Parameter != "(Intercept)", ]
#
#   # Return empty if no priors info
#   if (!"Prior_Distribution" %in% names(params) | nrow(params) == 0) {
#     return("")
#   }
#
#   values <- ifelse(params$Prior_Distribution == "normal",
#                    paste0("mean = ", insight::format_value(params$Prior_Location), ", SD = ", insight::format_value(params$Prior_Scale)),
#                    paste0("location = ", insight::format_value(params$Prior_Location), ", scale = ", insight::format_value(params$Prior_Scale))
#   )
#
#   values <- paste0(params$Prior_Distribution, " (", values, ")")
#
#   if (length(unique(values)) == 1 & nrow(params) > 1) {
#     text <- paste0("all set as ", values[1])
#   } else {
#     text <- paste0("set as ", format_text(values))
#   }
#
#   paste0(" Priors over parameters were ", text, " distributions.")
# }
