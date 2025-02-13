#' Convenient formatting of text components
#'
#' @inheritParams report
#' @param what The name of the item returned by `insight::find_formula`.
#'
#' @return A character string.
#'
#' @examples
#' model <- lm(Sepal.Length ~ Species, data = iris)
#' format_formula(model)
#'
#' @examplesIf requireNamespace("lme4", quietly = TRUE)
#' # Mixed models
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Sepal.Width + (1 | Species), data = iris)
#' format_formula(model)
#' format_formula(model, "random")
#' @export
format_formula <- function(x, what = "conditional") {
  f <- insight::safe_deparse(insight::find_formula(x, verbose = FALSE)[[what]])
  paste0("formula: ", paste(f, collapse = " + "))
}
