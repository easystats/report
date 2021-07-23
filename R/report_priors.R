#' Report priors of Bayesian models
#'
#' Reports priors of Bayesian models (see list of supported objects in
#' [report()]).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return An object of class [report_priors()].
#'
#' @examples
#' library(report)
#'
#' # Bayesian models
#' if (require("rstanarm")) {
#'   model <- stan_glm(mpg ~ disp, data = mtcars, refresh = 0, iter = 1000)
#'   r <- report_priors(model)
#'   r
#'   summary(r)
#' }
#' @export
report_priors <- function(x, ...) {
  UseMethod("report_priors")
}



# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_priors <- function(x, summary = NULL, ...) {
  class(x) <- unique(c("report_priors", class(x)))
  attributes(x) <- c(attributes(x), list(...))

  if (!is.null(summary)) {
    attr(x, "summary") <- summary
  }
  x
}


#' @export
summary.report_priors <- function(object, ...) {
  if (is.null(attributes(object)$summary)) {
    object
  } else {
    attributes(object)$summary
  }
}

#' @export
print.report_priors <- function(x, ...) {
  cat(paste0(x, collapse = "\n"))
}
