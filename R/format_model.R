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
    "logistic "
  } else if (info$is_probit) {
    "probit "
  } else if (info$is_linear) {
    "linear "
  } else if (info$is_poisson) {
    "poisson "
  } else if (info$is_negbin) {
    "negative-binomial "
  } else if (info$is_ordinal) {
    "ordinal "
  } else if (info$is_multinomial) {
    "multinomial "
  } else if (info$is_survival) {
    "survival "
  } else {
    "general linear "
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
  switch(
    x,
    lm = "linear model",
    glm = "general linear model",
    lmer = "linear mixed model",
    glmer = "general linear mixed model",
    gam = "general additive model",
    gamm = "general additive mixed model",
    "model"
  )
}
