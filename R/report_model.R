#' Report the model type
#'
#' Reports the type of different R objects (see list of supported objects in [report()]).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return A `character` string.
#'
#' @examples
#' \donttest{
#' library(report)
#'
#' # h-tests
#' report_model(t.test(iris$Sepal.Width, iris$Sepal.Length))
#'
#' # ANOVA
#' report_model(aov(Sepal.Length ~ Species, data = iris))
#'
#' # GLMs
#' report_model(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' report_model(glm(vs ~ disp, data = mtcars, family = "binomial"))
#'
#' # Mixed models
#' if (require("lme4")) {
#'   model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#'   report_model(model)
#' }
#'
#' # Bayesian models
#' if (require("rstanarm")) {
#'   model <- stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600)
#'   report_model(model)
#' }
#' }
#' @export
report_model <- function(x, table = NULL, ...) {
  UseMethod("report_model")
}



# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_model <- function(x, summary = NULL, ...) {
  class(x) <- unique(c("report_model", class(x)))
  attributes(x) <- c(attributes(x), list(...))

  if (!is.null(summary)) {
    attr(x, "summary") <- summary
  }
  x
}


#' @export
summary.report_model <- function(object, ...) {
  if (is.null(attributes(object)$summary)) {
    object
  } else {
    attributes(object)$summary
  }
}

#' @export
print.report_model <- function(x, ...) {
  cat(paste0(x, collapse = "\n"))
}
