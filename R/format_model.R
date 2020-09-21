#' Model Name Formatting
#'
#' @param model A statistical model.
#' @inherit format_algorithm return
#'
#' @examples
#' model <- lm(Sepal.Length ~ Species, data = iris)
#' format_model(model)
#'
#' if (require("lme4")) {
#'   model <- lme4::lmer(Sepal.Length ~ Sepal.Width + (1 | Species), data = iris)
#'   format_model(model)
#' }
#' @importFrom insight model_info
#' @export
format_model <- function(model) {
  info <- insight::model_info(model)

  if (all(insight::find_parameters(model, flatten = FALSE) == "(Intercept)")) {
    type <- "constant (intercept-only) "
  } else {
    type <- ""
  }

  if (info$is_bayesian) {
    type <- paste0(type, "Bayesian ")
  }

  if (info$is_zero_inflated) {
    type <- paste0(type, "zero-inflated ")
  } else if (info$is_hurdle) {
    type <- paste0(type, "hurdle ")
  }

  if (info$is_logit) {
    type <- paste0(type, "logistic ")
  } else if (info$is_probit) {
    type <- paste0(type, "probit ")
  } else if (info$is_linear) {
    type <- paste0(type, "linear ")
  } else if (info$is_poisson) {
    type <- paste0(type, "poisson ")
  } else if (info$is_negbin) {
    type <- paste0(type, "negative-binomial ")
  } else if (info$is_ordinal) {
    type <- paste0(type, "ordinal ")
  } else if (info$is_multinomial) {
    type <- paste0(type, "multinomial ")
  } else if (info$is_survival) {
    type <- paste0(type, "survival ")
  } else {
    type <- paste0(type, "general linear ")
  }

  if (info$is_mixed) {
    type <- paste0(type, "mixed ")
  }

  type <- paste0(type, "model")

  if (grepl("general linear", type)) {
    type <- paste0(
      type,
      " (",
      info$family,
      " family with a ",
      info$link_function,
      " link)"
    )
  }

  type
}
