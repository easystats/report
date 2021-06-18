#' @rdname format_formula
#' @examples
#' model <- lm(Sepal.Length ~ Species, data = iris)
#' format_model(model)
#'
#' if (require("lme4")) {
#'   model <- lme4::lmer(Sepal.Length ~ Sepal.Width + (1 | Species), data = iris)
#'   format_model(model)
#' }
#' @return A character string.
#' @export
format_model <- function(x) {
  UseMethod("format_model")
}

#' @export
format_model.default <- function(x) {
  info <- insight::model_info(x)

  if (insight::is_nullmodel(x)) {
    type <- "constant (intercept-only) "
  } else {
    type <- ""
  }

  if ("Mclust" %in% class(x)) {
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


#' @export
format_model.character <- function(x) {
  if (x == "lm") {
    type <- "linear model"
  } else if (x == "glm") {
    type <- "general linear model"
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
