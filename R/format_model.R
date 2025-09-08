#' @rdname format_formula
#' @examples
#' model <- lm(Sepal.Length ~ Species, data = iris)
#' format_model(model)
#'
#' @examplesIf requireNamespace("lme4", quietly = TRUE)
#' # Mixed models
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Sepal.Width + (1 | Species), data = iris)
#' format_model(model)
#' @return A character string.
#' @export
format_model <- function(x) {
  UseMethod("format_model")
}

# Helper function to determine model type prefix based on model characteristics
get_model_type_prefix <- function(info) {
  if (info$is_logit) {
    return("logistic ")
  } else if (info$is_probit) {
    return("probit ")
  } else if (info$is_linear) {
    return("linear ")
  } else if (info$is_poisson) {
    return("poisson ")
  } else if (info$is_negbin) {
    return("negative-binomial ")
  } else if (info$is_ordinal) {
    return("ordinal ")
  } else if (info$is_multinomial) {
    return("multinomial ")
  } else if (info$is_survival) {
    return("survival ")
  } else {
    return("general linear ")
  }
}

#' @export
format_model.default <- function(x) {
  info <- insight::model_info(x)

  if (suppressWarnings(insight::is_nullmodel(x))) {
    type <- "constant (intercept-only) "
  } else {
    type <- ""
  }

  if (inherits(x, "Mclust")) {
    return("Gaussian finite mixture fitted by EM algorithm")
  }

  if (info$is_bayesian) {
    type <- paste0(type, "Bayesian ")
  }

  if (info$is_zero_inflated) {
    type <- paste0(type, "zero-inflated ")
  } else if (info$is_hurdle) {
    type <- paste0(type, "hurdle ")
  }

  # Use helper function to get model type prefix
  type <- paste0(type, get_model_type_prefix(info))

  if (info$is_mixed) {
    type <- paste0(type, "mixed ")
  }

  type <- paste0(type, "model")

  if (grepl("general linear", type, fixed = TRUE)) {
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


#' @export
format_model.character <- function(x) {
  if (x == "lm") {
    type <- "linear model"
  } else if (x == "glm") {
    type <- "general linear model"
  } else if (x == "lmer") {
    type <- "linear mixed model"
  } else if (x == "glmer") {
    type <- "general linear mixed model"
  } else if (x == "gam") {
    type <- "general additive model"
  } else if (x == "gamm") {
    type <- "general additive mixed model"
  } else {
    "model"
  }
  type
}
