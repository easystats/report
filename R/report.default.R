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
  # You can remove the following line once the functions below are implemented
  stop(.error_message(x, "report()"), call. = FALSE)

  text <- report_text(x, ...)
  table <- report_table(x, ...)
  as.report(text = text, table = table, ...)
}


# report_effectsize -------------------------------------------------------

#' @rdname report.default
#' @export
report_effectsize.default <- function(x, ...) {
  # Delete the whole function if it's NOT applicable to your model / object.
  # Don't forget to edit the documentation name above ('rdname report.NEWCLASS')
  # You can remove the following line and fill it with some (working) code :)
  stop(.error_message(x, "report_effectsize()"), call. = FALSE)

  text <- c("large", "medium", "small")
  text_short <- c("l", "m", "s")

  as.report_effectsize(text, summary = text_short, ...)
}


# report_table ------------------------------------------------------------

#' @rdname report.default
#' @export
report_table.default <- function(x, ...) {
  # Delete the whole function if it's NOT applicable to your model / object.
  # Don't forget to edit the documentation name above ('rdname report.NEWCLASS')
  # You can remove the following line and fill it with some (working) code :)
  stop(.error_message(x, "report_table()"), call. = FALSE)

  table <- data.frame(V1 = c(1, 2), V2 = c("A", "B"), V3 = c(42, 7))
  table_short <- table[c("V1", "V2")]

  as.report_table(table, summary = table_short, ...)
}


# report_statistics ------------------------------------------------------------

#' @rdname report.default
#' @export
report_statistics.default <- function(x, ...) {
  # Delete the whole function if it's NOT applicable to your model / object.
  # Don't forget to edit the documentation name above ('rdname report.NEWCLASS')
  # You can remove the following line and fill it with some (working) code :)
  stop(.error_message(x, "report_statistics()"), call. = FALSE)

  text <- c("(z = 3, p < .05)", "(z = 1, p > 0.09)")
  text_short <- c("(z = 3)", "(z = 1)")

  as.report_statistics(text, summary = text_short, ...)
}


# report_parameters ------------------------------------------------------------

#' @rdname report.default
#' @export
report_parameters.default <- function(x, ...) {
  # Delete the whole function if it's NOT applicable to your model / object.
  # Don't forget to edit the documentation name above ('rdname report.NEWCLASS')
  # You can remove the following line and fill it with some (working) code :)
  stop(.error_message(x, "report_parameters()"), call. = FALSE)

  text <- c("it's great (z = 3, p < .05)", "it's terrible (z = 1, p > 0.09)")
  text_short <- c("it's great (z = 3)", "it's terrible (z = 1)")

  as.report_parameters(text, summary = text_short, ...)
}


# report_intercept ------------------------------------------------------------

#' @rdname report.default
#' @export
report_intercept.default <- function(x, ...) {
  # Delete the whole function if it's NOT applicable to your model / object.
  # Don't forget to edit the documentation name above ('rdname report.NEWCLASS')
  # You can remove the following line and fill it with some (working) code :)
  stop(.error_message(x, "report_intercept()"), call. = FALSE)

  text <- "The intercept is at 3 (z = 1, p > 0.09)"
  text_short <- "The intercept is at 3 (z = 1)"

  as.report_intercept(text, summary = text_short, ...)
}


# report_model ------------------------------------------------------------

#' @rdname report.default
#' @export
report_model.default <- function(x, ...) {
  # Delete the whole function if it's NOT applicable to your model / object.
  # Don't forget to edit the documentation name above ('rdname report.NEWCLASS')
  # You can remove the following line and fill it with some (working) code :)
  stop(.error_message(x, "report_model()"), call. = FALSE)

  text <- "We fitted a super duper model called the 'easymodel'"
  text_short <- "We fitted a super duper model"

  as.report_model(text, summary = text_short, ...)
}


# report_random ------------------------------------------------------------

#' @rdname report.default
#' @export
report_random.default <- function(x, ...) {
  # Delete the whole function if it's NOT applicable to your model / object.
  # Don't forget to edit the documentation name above ('rdname report.NEWCLASS')
  # You can remove the following line and fill it with some (working) code :)
  stop(.error_message(x, "report_random()"), call. = FALSE)

  text <- "The random factors are entered as this and that (formula)"
  text_short <- "The random factors are entered as this and that"

  as.report_random(text, summary = text_short, ...)
}


# report_priors ------------------------------------------------------------

#' @rdname report.default
#' @export
report_priors.default <- function(x, ...) {
  # Delete the whole function if it's NOT applicable to your model / object.
  # Don't forget to edit the documentation name above ('rdname report.NEWCLASS')
  # You can remove the following line and fill it with some (working) code :)
  stop(.error_message(x, "report_priors()"), call. = FALSE)

  text <- "Priors were specified like this (formula)"
  text_short <- "Priors were specified like this"

  as.report_priors(text, summary = text_short, ...)
}


# report_performance ------------------------------------------------------------

#' @rdname report.default
#' @export
report_performance.default <- function(x, ...) {
  # Delete the whole function if it's NOT applicable to your model / object.
  # Don't forget to edit the documentation name above ('rdname report.NEWCLASS')
  # You can remove the following line and fill it with some (working) code :)
  stop(.error_message(x, "report_performance()"), call. = FALSE)

  text <- "The model is simply awesome (p < 0.0001)"
  text_short <- "The model is simply awesome"

  as.report_performance(text, summary = text_short, ...)
}


# report_info ------------------------------------------------------------

#' @rdname report.default
#' @export
report_info.default <- function(x, ...) {
  # Delete the whole function if it's NOT applicable to your model / object.
  # Don't forget to edit the documentation name above ('rdname report.NEWCLASS')
  # You can remove the following line and fill it with some (working) code :)
  stop(.error_message(x, "report_info()"), call. = FALSE)

  text <- "Degrees of freedom were computed using this method, which does that"
  text_short <- "Degrees of freedom were computed using this method"

  as.report_info(text, summary = text_short, ...)
}


# report_text ------------------------------------------------------------

#' @rdname report.default
#' @export
report_text.default <- function(x, ...) {
  # Delete the whole function if it's NOT applicable to your model / object.
  # Don't forget to edit the documentation name above ('rdname report.NEWCLASS')
  # You can remove the following line and fill it with some (working) code :)
  stop(.error_message(x, "report_text()"), call. = FALSE)

  text <- paste(
    report_model(x),
    report_performance(x),
    report_parameters(x),
    report_info(x)
  )
  text_short <- paste(
    report_performance(x),
    report_parameters(x)
  )

  as.report_text(text, summary = text_short, ...)
}
