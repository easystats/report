#' Report random effects and factors
#'
#' Reports random effects of mixed models (see list of supported objects in \code{\link{report}}).
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
#' # Mixed models
#' if(require("lme4")){
#'   model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#'   r <- report_random(model)
#'   r
#'   summary(r)
#' }
#'
#' # Bayesian models
#' if(require("rstanarm")){
#'   model <- stan_lmer(mpg ~ disp + (1 | cyl), data = mtcars, refresh=0, iter=1000)
#'   r <- report_random(model)
#'   r
#'   summary(r)
#' }
#' @export
report_random <- function(x, ...) {
  UseMethod("report_random")
}



# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_random <- function(x, summary = NULL, ...) {
  class(x) <- unique(c("report_random", class(x)))
  attributes(x) <- c(attributes(x), list(...))

  if (!is.null(summary)) {
    attr(x, "summary") <- summary
  }
  x
}


#' @export
summary.report_random <- function(object, ...) {
  if(is.null(attributes(object)$summary)){
    object
  } else{
    attributes(object)$summary
  }
}

#' @export
print.report_random <- function(x, ...) {
  cat(paste0(x, collapse = "\n"))
}


