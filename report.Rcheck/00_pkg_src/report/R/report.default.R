#' Template to add report support for new objects
#'
#' Template file to add report support for new objects. Check-out the vignette on
#' [Supporting
#' New Models](https://easystats.github.io/report/articles/new_models.html).
#'
#' @param x Object of class `NEW OBJECT`.
#' @inheritParams report
#'
#' @inherit report return seealso
#'
#' @examples
#' library(report)
#'
#' # Add a reproducible example instead of the following
#' model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' r <- report(model)
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#' @return An object of class [report()].
#' @export
report.default <- function(x, ...) {
  stop(.error_message(x, "report()"), call. = FALSE)
}


# report_effectsize -------------------------------------------------------

#' @rdname report.default
#' @export
report_effectsize.default <- function(x, ...) {
  stop(.error_message(x, "report_effectsize()"), call. = FALSE)
}


# report_table ------------------------------------------------------------

#' @rdname report.default
#' @export
report_table.default <- function(x, ...) {
  stop(.error_message(x, "report_table()"), call. = FALSE)
}


# report_statistics ------------------------------------------------------------

#' @rdname report.default
#' @export
report_statistics.default <- function(x, ...) {
  stop(.error_message(x, "report_statistics()"), call. = FALSE)
}


# report_parameters ------------------------------------------------------------

#' @rdname report.default
#' @export
report_parameters.default <- function(x, ...) {
  stop(.error_message(x, "report_parameters()"), call. = FALSE)
}


# report_intercept ------------------------------------------------------------

#' @rdname report.default
#' @export
report_intercept.default <- function(x, ...) {
  stop(.error_message(x, "report_intercept()"), call. = FALSE)
}


# report_model ------------------------------------------------------------

#' @rdname report.default
#' @export
report_model.default <- function(x, ...) {
  stop(.error_message(x, "report_model()"), call. = FALSE)
}


# report_random ------------------------------------------------------------

#' @rdname report.default
#' @export
report_random.default <- function(x, ...) {
  stop(.error_message(x, "report_random()"), call. = FALSE)
}


# report_priors ------------------------------------------------------------

#' @rdname report.default
#' @export
report_priors.default <- function(x, ...) {
  stop(.error_message(x, "report_priors()"), call. = FALSE)
}


# report_performance ------------------------------------------------------------

#' @rdname report.default
#' @export
report_performance.default <- function(x, ...) {
  stop(.error_message(x, "report_performance()"), call. = FALSE)
}


# report_info ------------------------------------------------------------

#' @rdname report.default
#' @export
report_info.default <- function(x, ...) {
  stop(.error_message(x, "report_info()"), call. = FALSE)
}


# report_text ------------------------------------------------------------

#' @rdname report.default
#' @export
report_text.default <- function(x, ...) {
  stop(.error_message(x, "report_text()"), call. = FALSE)
}
