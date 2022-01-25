#' Report additional information
#'
#' Reports additional information relevant to the report (see list of supported
#' objects in [report()]).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return An object of class [report_info()].
#'
#' @examples
#' library(report)
#'
#' # h-tests
#' report_info(t.test(iris$Sepal.Width, iris$Sepal.Length))
#'
#' # ANOVAs
#' report_info(aov(Sepal.Length ~ Species, data = iris))
#' \donttest{
#' # GLMs
#' report_info(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' report_info(lm(Sepal.Length ~ Petal.Length * Species, data = iris), include_effectsize = TRUE)
#' report_info(glm(vs ~ disp, data = mtcars, family = "binomial"))
#'
#' # Mixed models
#' if (require("lme4")) {
#'   model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#'   report_info(model)
#' }
#'
#' # Bayesian models
#' if (require("rstanarm")) {
#'   model <- stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 300)
#'   report_info(model)
#' }
#' }
#' @export
report_info <- function(x, ...) {
  UseMethod("report_info")
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
  if (is.null(attributes(object)$summary)) {
    object
  } else {
    attributes(object)$summary
  }
}

#' @export
print.report_info <- function(x, ...) {
  cat(paste0(x, collapse = "\n"))
}



# Utils -------------------------------------------------------------------

#' @keywords internal
.info_df <- function(ci, df_method = NULL) {
  if (is.null(df_method)) {
    return("")
  }

  text <- paste0(
    insight::format_value(ci * 100, protect_integers = TRUE),
    "% Confidence Intervals (CIs) and p-values were computed using "
  )

  if (df_method == "wald") {
    text <- paste0(text, "the Wald approximation.")
  } else if (df_method == "kenward") {
    text <- paste0(text, "the Kenward-Roger approximation.")
  }
  text
}

#' @keywords internal
.info_effectsize <- function(x, effectsize = NULL, include_effectsize = FALSE) {
  text <- ""

  if (!is.null(effectsize)) {
    text <- attributes(effectsize)$method
    if (include_effectsize) {
      text <- paste0(text, attributes(effectsize)$rules)
      text <- gsub(".Effect sizes ", " and ", text)
    }
  }

  text
}
